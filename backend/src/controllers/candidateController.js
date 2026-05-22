const Joi = require('joi');
const db = require('../config/database');

const candidateSchema = Joi.object({
  name: Joi.string().max(255).required(),
  email: Joi.string().email().max(255).required(),
  phone: Joi.string().max(20).allow('', null),
  experienceYears: Joi.number().integer().min(0).max(80).default(0),
  skills: Joi.array().items(Joi.string().max(80)).default([]),
  tags: Joi.array().items(Joi.string().max(80)).default([]),
});

const partialCandidateSchema = candidateSchema.fork(
  ['name', 'email'],
  (schema) => schema.optional()
);

const noteSchema = Joi.object({
  content: Joi.string().max(2000).required(),
});

async function listCandidates(req, res) {
  try {
    const { q, tag, minExp, maxExp, stage } = req.query;
    const params = [req.user.companyId];
    let where = 'c.company_id = ? AND c.deleted_at IS NULL';

    if (q) {
      where += ' AND (c.name LIKE ? OR c.email LIKE ? OR c.current_title LIKE ?)';
      const search = `%${q}%`;
      params.push(search, search, search);
    }

    if (minExp !== undefined) {
      where += ' AND c.experience_years >= ?';
      params.push(Number(minExp));
    }

    if (maxExp !== undefined) {
      where += ' AND c.experience_years <= ?';
      params.push(Number(maxExp));
    }

    if (stage) {
      where += ' AND c.status = ?';
      params.push(stageToStatus(stage));
    }

    const [rows] = await db.query(
      `SELECT c.*,
              (SELECT cv.id FROM cvs cv
               WHERE cv.candidate_id = c.id AND cv.deleted_at IS NULL
               ORDER BY cv.created_at DESC LIMIT 1) AS cv_id,
              (SELECT cv.file_path FROM cvs cv
               WHERE cv.candidate_id = c.id AND cv.deleted_at IS NULL
               ORDER BY cv.created_at DESC LIMIT 1) AS cv_url,
              (SELECT jc.job_id FROM job_candidates jc
               WHERE jc.candidate_id = c.id AND jc.company_id = c.company_id
               ORDER BY jc.updated_at DESC LIMIT 1) AS job_id,
              (SELECT j.title
               FROM job_candidates jc
               JOIN jobs j ON j.id = jc.job_id AND j.deleted_at IS NULL
               WHERE jc.candidate_id = c.id AND jc.company_id = c.company_id
               ORDER BY jc.updated_at DESC LIMIT 1) AS job_title,
              (SELECT ps.name
               FROM job_candidates jc
               JOIN pipeline_stages ps ON ps.id = jc.stage_id
               WHERE jc.candidate_id = c.id AND jc.company_id = c.company_id
               ORDER BY jc.updated_at DESC LIMIT 1) AS stage_name
       FROM candidates c
       WHERE ${where}
       ORDER BY c.created_at DESC`,
      params
    );

    let candidates = rows.map((row) => toCandidateResponse(row));
    if (tag) {
      candidates = candidates.filter((candidate) =>
        candidate.tags.includes(String(tag))
      );
    }

    return res.json({ success: true, data: { candidates } });
  } catch (err) {
    console.error('listCandidates error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch candidates.',
    });
  }
}

async function getCandidate(req, res) {
  try {
    const candidate = await loadCandidate(req.params.id, req.user.companyId);
    if (!candidate) {
      return notFound(res, 'Candidate not found.');
    }

    return res.json({ success: true, data: { candidate } });
  } catch (err) {
    console.error('getCandidate error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch candidate.',
    });
  }
}

async function createCandidate(req, res) {
  const { error, value } = candidateSchema.validate(req.body, {
    abortEarly: false,
  });
  if (error) {
    return validationFailed(res, error);
  }

  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();

    const [result] = await conn.query(
      `INSERT INTO candidates
        (company_id, name, email, phone, experience_years, skills, tags, status)
       VALUES (?, ?, ?, ?, ?, ?, ?, 'new')`,
      [
        req.user.companyId,
        value.name.trim(),
        value.email.toLowerCase(),
        nullable(value.phone),
        value.experienceYears,
        JSON.stringify(value.skills),
        JSON.stringify(value.tags),
      ]
    );

    await logActivity(
      conn,
      req.user,
      'candidate',
      result.insertId,
      'candidate.created',
      `Candidate added: ${value.name.trim()}`
    );

    await conn.commit();

    const candidate = await loadCandidate(result.insertId, req.user.companyId);
    return res.status(201).json({ success: true, data: { candidate } });
  } catch (err) {
    await conn.rollback();
    if (err && err.code === 'ER_DUP_ENTRY') {
      return res.status(422).json({
        success: false,
        message: 'Validation failed.',
        errors: { email: ['Email is already registered for this company.'] },
      });
    }

    console.error('createCandidate error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to create candidate.',
    });
  } finally {
    conn.release();
  }
}

async function updateCandidate(req, res) {
  const { error, value } = partialCandidateSchema.validate(req.body, {
    abortEarly: false,
  });
  if (error) {
    return validationFailed(res, error);
  }

  try {
    const [existing] = await db.query(
      'SELECT id FROM candidates WHERE id = ? AND company_id = ? AND deleted_at IS NULL LIMIT 1',
      [req.params.id, req.user.companyId]
    );
    if (!existing.length) {
      return notFound(res, 'Candidate not found.');
    }

    const fields = [];
    const params = [];
    const setField = (name, item) => {
      if (item !== undefined) {
        fields.push(`${name} = ?`);
        params.push(item);
      }
    };

    setField('name', value.name?.trim());
    setField('email', value.email?.toLowerCase());
    setField('phone', nullable(value.phone));
    setField('experience_years', value.experienceYears);
    if (value.skills !== undefined) {
      setField('skills', JSON.stringify(value.skills));
    }
    if (value.tags !== undefined) {
      setField('tags', JSON.stringify(value.tags));
    }

    if (fields.length) {
      params.push(req.params.id, req.user.companyId);
      await db.query(
        `UPDATE candidates SET ${fields.join(', ')}, updated_at = NOW()
         WHERE id = ? AND company_id = ?`,
        params
      );
    }

    const candidate = await loadCandidate(req.params.id, req.user.companyId);
    return res.json({ success: true, data: { candidate } });
  } catch (err) {
    if (err && err.code === 'ER_DUP_ENTRY') {
      return res.status(422).json({
        success: false,
        message: 'Validation failed.',
        errors: { email: ['Email is already registered for this company.'] },
      });
    }

    console.error('updateCandidate error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to update candidate.',
    });
  }
}

async function deleteCandidate(req, res) {
  try {
    const [result] = await db.query(
      `UPDATE candidates
       SET deleted_at = NOW()
       WHERE id = ? AND company_id = ? AND deleted_at IS NULL`,
      [req.params.id, req.user.companyId]
    );
    if (!result.affectedRows) {
      return notFound(res, 'Candidate not found.');
    }

    return res.json({ success: true, message: 'Candidate deleted.' });
  } catch (err) {
    console.error('deleteCandidate error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to delete candidate.',
    });
  }
}

async function addTag(req, res) {
  const tag = String(req.body.tag || '').trim();
  if (!tag) {
    return res.status(422).json({
      success: false,
      message: 'Tag is required.',
    });
  }

  return mutateTags(req, res, (tags) =>
    tags.includes(tag) ? tags : [...tags, tag]
  );
}

async function removeTag(req, res) {
  const tag = String(req.body.tag || '').trim();
  return mutateTags(req, res, (tags) => tags.filter((item) => item !== tag));
}

async function addNote(req, res) {
  const { error, value } = noteSchema.validate(req.body);
  if (error) {
    return validationFailed(res, error);
  }

  try {
    const [candidateRows] = await db.query(
      'SELECT id FROM candidates WHERE id = ? AND company_id = ? AND deleted_at IS NULL LIMIT 1',
      [req.params.id, req.user.companyId]
    );
    if (!candidateRows.length) {
      return notFound(res, 'Candidate not found.');
    }

    const [result] = await db.query(
      `INSERT INTO candidate_notes (company_id, candidate_id, user_id, content)
       VALUES (?, ?, ?, ?)`,
      [req.user.companyId, req.params.id, req.user.userId, value.content.trim()]
    );

    await db.query(
      `INSERT INTO activity_logs (company_id, user_id, entity_type, entity_id, action, description)
       VALUES (?, ?, 'candidate', ?, 'note.added', ?)`,
      [req.user.companyId, req.user.userId, req.params.id, 'Added candidate note']
    );

    const [rows] = await db.query(
      `SELECT n.*, u.name AS author_name
       FROM candidate_notes n
       LEFT JOIN users u ON u.id = n.user_id
       WHERE n.id = ?`,
      [result.insertId]
    );

    return res.status(201).json({
      success: true,
      data: { note: toNoteResponse(rows[0]) },
    });
  } catch (err) {
    console.error('addNote error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to add note.',
    });
  }
}

async function deleteNote(req, res) {
  try {
    const [result] = await db.query(
      `UPDATE candidate_notes
       SET deleted_at = NOW()
       WHERE id = ? AND candidate_id = ? AND company_id = ? AND deleted_at IS NULL`,
      [req.params.noteId, req.params.id, req.user.companyId]
    );
    if (!result.affectedRows) {
      return notFound(res, 'Note not found.');
    }

    return res.json({ success: true, message: 'Note deleted.' });
  } catch (err) {
    console.error('deleteNote error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to delete note.',
    });
  }
}

async function getCandidateActivity(req, res) {
  try {
    const [rows] = await db.query(
      `SELECT al.id, al.entity_type, al.action, al.description, al.created_at,
              u.name AS user_name
       FROM activity_logs al
       LEFT JOIN users u ON u.id = al.user_id
       WHERE al.company_id = ?
         AND al.entity_type = 'candidate'
         AND al.entity_id = ?
       ORDER BY al.created_at DESC
       LIMIT 50`,
      [req.user.companyId, req.params.id]
    );

    return res.json({
      success: true,
      data: { activities: rows.map(toActivityResponse) },
    });
  } catch (err) {
    console.error('getCandidateActivity error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch candidate activity.',
    });
  }
}

async function mutateTags(req, res, mutate) {
  try {
    const candidate = await loadCandidate(req.params.id, req.user.companyId);
    if (!candidate) {
      return notFound(res, 'Candidate not found.');
    }

    const tags = mutate(candidate.tags);
    await db.query(
      `UPDATE candidates
       SET tags = ?, updated_at = NOW()
       WHERE id = ? AND company_id = ?`,
      [JSON.stringify(tags), req.params.id, req.user.companyId]
    );

    const updated = await loadCandidate(req.params.id, req.user.companyId);
    return res.json({ success: true, data: { candidate: updated } });
  } catch (err) {
    console.error('mutateTags error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to update tags.',
    });
  }
}

async function loadCandidate(id, companyId) {
  const [rows] = await db.query(
    `SELECT c.*,
            (SELECT cv.id FROM cvs cv
             WHERE cv.candidate_id = c.id AND cv.deleted_at IS NULL
             ORDER BY cv.created_at DESC LIMIT 1) AS cv_id,
            (SELECT cv.file_path FROM cvs cv
             WHERE cv.candidate_id = c.id AND cv.deleted_at IS NULL
             ORDER BY cv.created_at DESC LIMIT 1) AS cv_url,
            (SELECT jc.job_id FROM job_candidates jc
             WHERE jc.candidate_id = c.id AND jc.company_id = c.company_id
             ORDER BY jc.updated_at DESC LIMIT 1) AS job_id,
            (SELECT j.title
             FROM job_candidates jc
             JOIN jobs j ON j.id = jc.job_id AND j.deleted_at IS NULL
             WHERE jc.candidate_id = c.id AND jc.company_id = c.company_id
             ORDER BY jc.updated_at DESC LIMIT 1) AS job_title,
            (SELECT ps.name
             FROM job_candidates jc
             JOIN pipeline_stages ps ON ps.id = jc.stage_id
             WHERE jc.candidate_id = c.id AND jc.company_id = c.company_id
             ORDER BY jc.updated_at DESC LIMIT 1) AS stage_name
     FROM candidates c
     WHERE c.id = ? AND c.company_id = ? AND c.deleted_at IS NULL
     LIMIT 1`,
    [id, companyId]
  );

  if (!rows.length) {
    return null;
  }

  const [notes] = await db.query(
    `SELECT n.*, u.name AS author_name
     FROM candidate_notes n
     LEFT JOIN users u ON u.id = n.user_id
     WHERE n.candidate_id = ? AND n.company_id = ? AND n.deleted_at IS NULL
     ORDER BY n.created_at DESC`,
    [id, companyId]
  );

  const [history] = await db.query(
    `SELECT al.id, al.action, al.description, al.created_at, u.name AS user_name
     FROM activity_logs al
     LEFT JOIN users u ON u.id = al.user_id
     WHERE al.company_id = ?
       AND al.entity_type = 'candidate'
       AND al.entity_id = ?
     ORDER BY al.created_at ASC`,
    [companyId, id]
  );

  return toCandidateResponse(rows[0], notes, history);
}

function toCandidateResponse(row, notes = [], history = []) {
  const stage = row.stage_name
    ? stageNameToKey(row.stage_name)
    : statusToStage(row.status);

  return {
    id: String(row.id),
    name: row.name,
    email: row.email,
    phone: row.phone,
    experienceYears: toInt(row.experience_years),
    skills: parseList(row.skills),
    tags: parseList(row.tags),
    notes: notes.map(toNoteResponse),
    stageHistory: history.length
      ? history.map((item) => toStageHistoryResponse(item, stage))
      : [
          {
            id: `history-${row.id}`,
            stage,
            movedByName: 'System',
            movedAt: toIso(row.created_at),
            note: 'Candidate added.',
          },
        ],
    currentStage: stage,
    cvUrl: row.cv_url || null,
    cvId: row.cv_id == null ? null : String(row.cv_id),
    jobId: row.job_id == null ? null : String(row.job_id),
    jobTitle: row.job_title || null,
    avatarUrl: null,
    createdAt: toIso(row.created_at),
    updatedAt: toIso(row.updated_at),
  };
}

function toNoteResponse(row) {
  return {
    id: String(row.id),
    content: row.content,
    authorName: row.author_name || 'System',
    createdAt: toIso(row.created_at),
    updatedAt: row.updated_at ? toIso(row.updated_at) : null,
  };
}

function toStageHistoryResponse(row, fallbackStage) {
  return {
    id: String(row.id),
    stage: row.action && row.action.includes('stage') ? fallbackStage : fallbackStage,
    movedByName: row.user_name || 'System',
    movedAt: toIso(row.created_at),
    note: row.description || null,
  };
}

function toActivityResponse(row) {
  return {
    id: String(row.id),
    action: row.action || 'updated',
    actorName: row.user_name || 'System',
    targetName: row.description || null,
    createdAt: toIso(row.created_at),
    type: mapActivityType(row.entity_type, row.action),
  };
}

function mapActivityType(entityType, action) {
  const normalizedAction = String(action || '').toLowerCase();
  const normalizedEntity = String(entityType || '').toLowerCase();

  if (normalizedAction.includes('stage') || normalizedEntity === 'pipeline') {
    return 'stageMoved';
  }
  if (normalizedAction.includes('job')) {
    return 'jobCreated';
  }
  if (normalizedAction.includes('note')) {
    return 'noteAdded';
  }
  return 'candidateAdded';
}

async function logActivity(conn, user, entityType, entityId, action, description) {
  await conn.query(
    `INSERT INTO activity_logs (company_id, user_id, entity_type, entity_id, action, description)
     VALUES (?, ?, ?, ?, ?, ?)`,
    [user.companyId, user.userId, entityType, entityId, action, description]
  );
}

function validationFailed(res, error) {
  const errors = {};
  for (const detail of error.details) {
    errors[detail.path.join('.')] = [detail.message.replace(/"/g, '')];
  }

  return res.status(422).json({
    success: false,
    message: 'Validation failed.',
    errors,
  });
}

function notFound(res, message) {
  return res.status(404).json({ success: false, message });
}

function parseList(value) {
  if (Array.isArray(value)) {
    return value.map(String);
  }
  if (typeof value !== 'string' || value.trim() === '') {
    return [];
  }
  try {
    const parsed = JSON.parse(value);
    return Array.isArray(parsed) ? parsed.map(String) : [];
  } catch (_err) {
    return value
      .split(',')
      .map((item) => item.trim())
      .filter(Boolean);
  }
}

function nullable(value) {
  if (value === undefined || value === null) {
    return null;
  }
  const normalized = String(value).trim();
  return normalized === '' ? null : normalized;
}

function toInt(value) {
  return Number.parseInt(value || 0, 10) || 0;
}

function toIso(value) {
  if (!value) {
    return new Date().toISOString();
  }
  return value instanceof Date ? value.toISOString() : new Date(value).toISOString();
}

function statusToStage(status) {
  return {
    new: 'applied',
    active: 'shortlisted',
    hired: 'hired',
    rejected: 'rejected',
  }[status] || 'applied';
}

function stageToStatus(stage) {
  return {
    applied: 'new',
    shortlisted: 'active',
    interview: 'active',
    hired: 'hired',
    rejected: 'rejected',
  }[stage] || 'new';
}

function stageNameToKey(name) {
  const normalized = String(name || '').toLowerCase();
  if (normalized.includes('short')) return 'shortlisted';
  if (normalized.includes('interview')) return 'interview';
  if (normalized.includes('hire')) return 'hired';
  if (normalized.includes('reject')) return 'rejected';
  return 'applied';
}

module.exports = {
  listCandidates,
  getCandidate,
  createCandidate,
  updateCandidate,
  deleteCandidate,
  addTag,
  removeTag,
  addNote,
  deleteNote,
  getCandidateActivity,
  toCandidateResponse,
  statusToStage,
  stageToStatus,
};
