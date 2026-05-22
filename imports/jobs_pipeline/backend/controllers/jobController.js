const Joi = require('joi');
const db  = require('../config/database');
const { getStages } = require('../helpers/pipelineHelper');

// ── Validation ────────────────────────────────────────────────────────────────
const jobSchema = Joi.object({
  title:        Joi.string().max(255).required(),
  department:   Joi.string().max(255).allow('', null),
  location:     Joi.string().max(255).allow('', null),
  type:         Joi.string().valid('full_time','part_time','contract','internship').default('full_time'),
  description:  Joi.string().allow('', null),
  requirements: Joi.string().allow('', null),
  is_open:      Joi.boolean().default(true),
});

const assignSchema = Joi.object({
  candidate_id: Joi.number().integer().required(),
  stage_id:     Joi.number().integer().required(),
  notes:        Joi.string().allow('', null),
});

const moveStageSchema = Joi.object({
  stage_id: Joi.number().integer().required(),
  notes:    Joi.string().allow('', null),
});

// ── Jobs CRUD ─────────────────────────────────────────────────────────────────

/**
 * GET /api/jobs
 * List all jobs for the company
 */
const listJobs = async (req, res) => {
  try {
    const { is_open, search } = req.query;

    let where  = 'j.company_id = ? AND j.deleted_at IS NULL';
    const params = [req.user.companyId];

    if (is_open !== undefined) {
      where += ' AND j.is_open = ?';
      params.push(is_open === 'true' ? 1 : 0);
    }
    if (search) {
      where += ' AND (j.title LIKE ? OR j.department LIKE ?)';
      const s = `%${search}%`;
      params.push(s, s);
    }

    const [jobs] = await db.query(
      `SELECT j.*, u.name AS created_by_name,
              COUNT(jc.id) AS candidate_count
       FROM jobs j
       LEFT JOIN users u ON u.id = j.created_by
       LEFT JOIN job_candidates jc ON jc.job_id = j.id
       WHERE ${where}
       GROUP BY j.id
       ORDER BY j.created_at DESC`,
      params
    );

    return res.json({ success: true, data: { jobs } });
  } catch (err) {
    console.error('listJobs error:', err);
    return res.status(500).json({ success: false, message: 'Failed to fetch jobs.' });
  }
};

/**
 * POST /api/jobs
 * Create a new job position
 */
const createJob = async (req, res) => {
  const { error, value } = jobSchema.validate(req.body, { abortEarly: false });
  if (error) {
    const errors = error.details.reduce((acc, d) => {
      acc[d.context.key] = d.message.replace(/"/g, '');
      return acc;
    }, {});
    return res.status(422).json({ success: false, message: 'Validation failed.', errors });
  }

  try {
    const [result] = await db.query(
      `INSERT INTO jobs (company_id, title, department, location, type, description, requirements, is_open, created_by)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        req.user.companyId,
        value.title, value.department || null, value.location || null,
        value.type, value.description || null, value.requirements || null,
        value.is_open ? 1 : 0, req.user.userId,
      ]
    );

    return res.status(201).json({
      success: true,
      message: 'Job created successfully.',
      data: { job: { id: result.insertId, ...value } },
    });
  } catch (err) {
    console.error('createJob error:', err);
    return res.status(500).json({ success: false, message: 'Failed to create job.' });
  }
};

/**
 * GET /api/jobs/:id
 */
const getJob = async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT j.*, u.name AS created_by_name
       FROM jobs j
       LEFT JOIN users u ON u.id = j.created_by
       WHERE j.id = ? AND j.company_id = ? AND j.deleted_at IS NULL LIMIT 1`,
      [req.params.id, req.user.companyId]
    );
    if (!rows.length) return res.status(404).json({ success: false, message: 'Job not found.' });
    return res.json({ success: true, data: { job: rows[0] } });
  } catch (err) {
    console.error('getJob error:', err);
    return res.status(500).json({ success: false, message: 'Failed to fetch job.' });
  }
};

/**
 * PUT /api/jobs/:id
 */
const updateJob = async (req, res) => {
  const { error, value } = jobSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(422).json({ success: false, message: 'Validation failed.' });
  }
  try {
    const [rows] = await db.query(
      'SELECT id FROM jobs WHERE id = ? AND company_id = ? AND deleted_at IS NULL LIMIT 1',
      [req.params.id, req.user.companyId]
    );
    if (!rows.length) return res.status(404).json({ success: false, message: 'Job not found.' });

    await db.query(
      `UPDATE jobs SET title=?, department=?, location=?, type=?, description=?,
       requirements=?, is_open=?, updated_at=NOW() WHERE id=?`,
      [value.title, value.department||null, value.location||null, value.type,
       value.description||null, value.requirements||null, value.is_open?1:0, req.params.id]
    );
    return res.json({ success: true, message: 'Job updated successfully.' });
  } catch (err) {
    console.error('updateJob error:', err);
    return res.status(500).json({ success: false, message: 'Failed to update job.' });
  }
};

/**
 * DELETE /api/jobs/:id
 */
const deleteJob = async (req, res) => {
  try {
    await db.query('UPDATE jobs SET deleted_at=NOW() WHERE id=? AND company_id=?',
      [req.params.id, req.user.companyId]);
    return res.json({ success: true, message: 'Job deleted.' });
  } catch (err) {
    return res.status(500).json({ success: false, message: 'Failed to delete job.' });
  }
};

// ── Pipeline ──────────────────────────────────────────────────────────────────

/**
 * GET /api/jobs/:id/pipeline
 * Get full pipeline board for a job — candidates grouped by stage
 */
const getPipeline = async (req, res) => {
  try {
    const [jobRows] = await db.query(
      'SELECT id, title FROM jobs WHERE id=? AND company_id=? AND deleted_at IS NULL LIMIT 1',
      [req.params.id, req.user.companyId]
    );
    if (!jobRows.length) return res.status(404).json({ success: false, message: 'Job not found.' });

    // Get all stages for this company
    const stages = await getStages(req.user.companyId);

    // Get all candidates in this job's pipeline
    const [assignments] = await db.query(
      `SELECT jc.id AS assignment_id, jc.stage_id, jc.notes, jc.assigned_at, jc.updated_at,
              c.id AS candidate_id, c.name, c.email, c.current_title,
              c.experience_years, c.skills, c.tags,
              cv.original_name AS cv_name
       FROM job_candidates jc
       JOIN candidates c ON c.id = jc.candidate_id
       LEFT JOIN cvs cv ON cv.candidate_id = c.id
       WHERE jc.job_id = ? AND jc.company_id = ?
       ORDER BY jc.updated_at DESC`,
      [req.params.id, req.user.companyId]
    );

    // Group candidates by stage
    const board = stages.map(stage => ({
      stage,
      candidates: assignments
        .filter(a => a.stage_id === stage.id)
        .map(a => ({
          assignment_id:    a.assignment_id,
          candidate_id:     a.candidate_id,
          name:             a.name,
          email:            a.email,
          current_title:    a.current_title,
          experience_years: a.experience_years,
          skills: typeof a.skills === 'string' ? JSON.parse(a.skills || '[]') : (a.skills || []),
          tags:   typeof a.tags   === 'string' ? JSON.parse(a.tags   || '[]') : (a.tags   || []),
          cv_name:          a.cv_name,
          notes:            a.notes,
          moved_at:         a.updated_at,
        })),
    }));

    return res.json({
      success: true,
      data: { job: jobRows[0], board },
    });
  } catch (err) {
    console.error('getPipeline error:', err);
    return res.status(500).json({ success: false, message: 'Failed to fetch pipeline.' });
  }
};

/**
 * POST /api/jobs/:id/candidates
 * Assign a candidate to a job at a specific stage
 */
const assignCandidate = async (req, res) => {
  const { error, value } = assignSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(422).json({ success: false, message: 'candidate_id and stage_id are required.' });
  }

  try {
    // Verify candidate belongs to this company
    const [cRows] = await db.query(
      'SELECT id FROM candidates WHERE id=? AND company_id=? AND deleted_at IS NULL LIMIT 1',
      [value.candidate_id, req.user.companyId]
    );
    if (!cRows.length) return res.status(404).json({ success: false, message: 'Candidate not found.' });

    // Verify stage belongs to this company
    const [sRows] = await db.query(
      'SELECT id FROM pipeline_stages WHERE id=? AND company_id=? LIMIT 1',
      [value.stage_id, req.user.companyId]
    );
    if (!sRows.length) return res.status(404).json({ success: false, message: 'Stage not found.' });

    // Insert or update (candidate may already be in this job)
    await db.query(
      `INSERT INTO job_candidates (company_id, job_id, candidate_id, stage_id, notes, assigned_by)
       VALUES (?, ?, ?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE stage_id=VALUES(stage_id), notes=VALUES(notes), updated_at=NOW()`,
      [req.user.companyId, req.params.id, value.candidate_id,
       value.stage_id, value.notes || null, req.user.userId]
    );

    return res.status(201).json({
      success: true,
      message: 'Candidate added to pipeline.',
    });
  } catch (err) {
    console.error('assignCandidate error:', err);
    return res.status(500).json({ success: false, message: 'Failed to assign candidate.' });
  }
};

/**
 * PATCH /api/jobs/:id/candidates/:candidateId/stage
 * Move a candidate to a different pipeline stage (Task 16)
 */
const moveCandidateStage = async (req, res) => {
  const { error, value } = moveStageSchema.validate(req.body);
  if (error) {
    return res.status(422).json({ success: false, message: 'stage_id is required.' });
  }

  try {
    // Verify stage belongs to company
    const [sRows] = await db.query(
      'SELECT id, name FROM pipeline_stages WHERE id=? AND company_id=? LIMIT 1',
      [value.stage_id, req.user.companyId]
    );
    if (!sRows.length) return res.status(404).json({ success: false, message: 'Stage not found.' });

    const [result] = await db.query(
      `UPDATE job_candidates SET stage_id=?, notes=?, updated_at=NOW()
       WHERE job_id=? AND candidate_id=? AND company_id=?`,
      [value.stage_id, value.notes || null,
       req.params.id, req.params.candidateId, req.user.companyId]
    );

    if (!result.affectedRows) {
      return res.status(404).json({ success: false, message: 'Assignment not found.' });
    }

    return res.json({
      success: true,
      message: `Candidate moved to "${sRows[0].name}".`,
      data: { stage_id: value.stage_id, stage_name: sRows[0].name },
    });
  } catch (err) {
    console.error('moveCandidateStage error:', err);
    return res.status(500).json({ success: false, message: 'Failed to move candidate.' });
  }
};

/**
 * DELETE /api/jobs/:id/candidates/:candidateId
 * Remove a candidate from a job pipeline
 */
const removeFromPipeline = async (req, res) => {
  try {
    await db.query(
      'DELETE FROM job_candidates WHERE job_id=? AND candidate_id=? AND company_id=?',
      [req.params.id, req.params.candidateId, req.user.companyId]
    );
    return res.json({ success: true, message: 'Candidate removed from pipeline.' });
  } catch (err) {
    return res.status(500).json({ success: false, message: 'Failed to remove candidate.' });
  }
};

/**
 * GET /api/pipeline/stages
 * Get all pipeline stages for this company
 */
const listStages = async (req, res) => {
  try {
    const stages = await getStages(req.user.companyId);
    return res.json({ success: true, data: { stages } });
  } catch (err) {
    return res.status(500).json({ success: false, message: 'Failed to fetch stages.' });
  }
};

module.exports = {
  listJobs, createJob, getJob, updateJob, deleteJob,
  getPipeline, assignCandidate, moveCandidateStage,
  removeFromPipeline, listStages,
};
