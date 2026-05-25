const db = require('../config/database');
const { notifyCVUploaded } = require('../services/emailService');

const DEMO_PDF_URL =
  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

async function uploadCv(req, res) {
  const conn = await db.getConnection();

  try {
    const file = req.file;
    const fileName = file?.originalname || 'uploaded-cv.pdf';
    const mimeType = file?.mimetype || 'application/pdf';
    const sizeBytes = file?.size || 0;
    const candidateName = normalizeOptional(req.body.name) || nameFromFile(fileName);
    const candidateEmail =
      normalizeOptional(req.body.email)?.toLowerCase() ||
      generatedCandidateEmail(fileName);
    const candidatePhone = normalizeOptional(req.body.phone);
    const experienceYears = toExperienceYears(req.body.experienceYears ?? req.body.experience_years);
    const skills = parseList(req.body.skills);
    const tags = parseList(req.body.tags);

    await conn.beginTransaction();

    const [candidateResult] = await conn.query(
      `INSERT INTO candidates
        (company_id, name, email, phone, experience_years, skills, tags, status)
       VALUES (?, ?, ?, ?, ?, ?, ?, 'new')`,
      [
        req.user.companyId,
        candidateName,
        candidateEmail,
        candidatePhone,
        experienceYears,
        JSON.stringify(skills),
        JSON.stringify(tags.length ? tags : ['cv-upload']),
      ]
    );

    const candidateId = candidateResult.insertId;

    const [result] = await conn.query(
      `INSERT INTO cvs
        (company_id, candidate_id, original_name, stored_name, file_path, mime_type, size_bytes)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        req.user.companyId,
        candidateId,
        fileName,
        `${Date.now()}-${fileName}`,
        DEMO_PDF_URL,
        mimeType,
        sizeBytes,
      ]
    );

    await conn.query(
      `INSERT INTO activity_logs (company_id, user_id, entity_type, entity_id, action, description)
       VALUES (?, ?, 'candidate', ?, 'candidate.created', ?)`,
      [req.user.companyId, req.user.userId, candidateId, `Candidate added from CV: ${candidateName}`]
    );

    await conn.query(
      `INSERT INTO activity_logs (company_id, user_id, entity_type, entity_id, action, description)
       VALUES (?, ?, 'cv', ?, 'cv.uploaded', ?)`,
      [req.user.companyId, req.user.userId, result.insertId, `Uploaded CV: ${fileName}`]
    );

    await conn.commit();

    notifyCVUploaded({
      db,
      companyId: req.user.companyId,
      candidateName,
      fileName,
      uploadedByName: req.user.name || 'A team member',
    }).catch((err) => console.error('notifyCVUploaded error:', err));

    return res.status(201).json({
      success: true,
      data: {
        cv: {
          id: String(result.insertId),
          fileName,
          fileUrl: DEMO_PDF_URL,
          fileSizeBytes: sizeBytes,
          mimeType,
          candidateId: String(candidateId),
          uploadedAt: new Date().toISOString(),
        },
        candidate: {
          id: String(candidateId),
          name: candidateName,
          email: candidateEmail,
          phone: candidatePhone,
          experienceYears,
          skills,
          tags: tags.length ? tags : ['cv-upload'],
          currentStage: 'applied',
          cvUrl: DEMO_PDF_URL,
          cvId: String(result.insertId),
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        },
      },
    });
  } catch (err) {
    await conn.rollback();
    if (err && err.code === 'ER_DUP_ENTRY') {
      return res.status(422).json({
        success: false,
        message: 'A candidate with that email already exists.',
      });
    }

    if (err && err.code === '23505') {
      return res.status(422).json({
        success: false,
        message: 'A candidate with that email already exists.',
      });
    }

    console.error('uploadCv error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to upload CV.',
    });
  } finally {
    conn.release();
  }
}

async function getDownloadUrl(req, res) {
  try {
    const [rows] = await db.query(
      `SELECT file_path
       FROM cvs
       WHERE id = ? AND company_id = ? AND deleted_at IS NULL
       LIMIT 1`,
      [req.params.id, req.user.companyId]
    );

    return res.json({
      success: true,
      data: { url: rows[0]?.file_path || DEMO_PDF_URL },
    });
  } catch (err) {
    console.error('getDownloadUrl error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to get CV download URL.',
    });
  }
}

module.exports = {
  uploadCv,
  getDownloadUrl,
};

function nameFromFile(fileName) {
  const base = String(fileName || 'Candidate')
    .replace(/\.[^.]+$/, '')
    .replace(/[_-]+/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();

  if (!base) {
    return 'Uploaded Candidate';
  }

  return base.replace(/\b\w/g, (char) => char.toUpperCase());
}

function generatedCandidateEmail(fileName) {
  const slug = String(fileName || 'cv')
    .toLowerCase()
    .replace(/\.[^.]+$/, '')
    .replace(/[^a-z0-9]+/g, '.')
    .replace(/^\.+|\.+$/g, '')
    .slice(0, 40) || 'cv';
  return `${slug}.${Date.now()}@uploaded.hireops.local`;
}

function normalizeOptional(value) {
  if (value == null) {
    return null;
  }

  const normalized = String(value).trim();
  return normalized || null;
}

function toExperienceYears(value) {
  const parsed = Number(value);
  return Number.isFinite(parsed) && parsed >= 0 ? parsed : 0;
}

function parseList(value) {
  if (Array.isArray(value)) {
    return value.map(String).map((item) => item.trim()).filter(Boolean);
  }

  if (value == null || String(value).trim() === '') {
    return [];
  }

  try {
    const parsed = JSON.parse(value);
    if (Array.isArray(parsed)) {
      return parsed.map(String).map((item) => item.trim()).filter(Boolean);
    }
  } catch (_err) {
    // Fall back to comma-separated values.
  }

  return String(value)
    .split(',')
    .map((item) => item.trim())
    .filter(Boolean);
}
