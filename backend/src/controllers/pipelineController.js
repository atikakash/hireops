const db = require('../config/database');
const { DEFAULT_STAGES, getStages, seedPipelineStages } = require('../helpers/pipelineHelper');
const {
  toCandidateResponse,
  stageToStatus,
} = require('./candidateController');

async function listPipelineStages(req, res) {
  try {
    const stages = await ensureStages(req.user.companyId);
    const [candidates] = await db.query(
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
       WHERE c.company_id = ? AND c.deleted_at IS NULL
       ORDER BY c.created_at DESC`,
      [req.user.companyId]
    );

    const mappedCandidates = candidates.map((row) => toCandidateResponse(row));
    const payload = stages
      .filter((stage) => stageToKey(stage.name) !== 'offered')
      .map((stage, index) => {
        const key = stageToKey(stage.name);
        return {
          id: String(stage.id),
          stage: key,
          name: stage.name,
          order: index,
          candidates: mappedCandidates.filter(
            (candidate) => candidate.currentStage === key
          ),
        };
      });

    return res.json({ success: true, data: { stages: payload } });
  } catch (err) {
    console.error('listPipelineStages error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to load pipeline stages.',
    });
  }
}

async function moveCandidate(req, res) {
  const stage = String(req.body.stage || '').trim();
  const status = stageToStatus(stage);

  try {
    const [result] = await db.query(
      `UPDATE candidates
       SET status = ?, updated_at = NOW()
       WHERE id = ? AND company_id = ? AND deleted_at IS NULL`,
      [status, req.params.id, req.user.companyId]
    );
    if (!result.affectedRows) {
      return res.status(404).json({
        success: false,
        message: 'Candidate not found.',
      });
    }

    await db.query(
      `INSERT INTO activity_logs (company_id, user_id, entity_type, entity_id, action, description)
       VALUES (?, ?, 'candidate', ?, 'candidate.stage_moved', ?)`,
      [
        req.user.companyId,
        req.user.userId,
        req.params.id,
        `Candidate moved to ${stage || 'applied'}`,
      ]
    );

    return res.json({
      success: true,
      message: 'Candidate moved successfully.',
    });
  } catch (err) {
    console.error('moveCandidate error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to move candidate.',
    });
  }
}

async function renameStage(req, res) {
  const name = String(req.body.name || '').trim();
  if (!name) {
    return res.status(422).json({
      success: false,
      message: 'Stage name is required.',
    });
  }

  try {
    const [result] = await db.query(
      `UPDATE pipeline_stages
       SET name = ?
       WHERE id = ? AND company_id = ?`,
      [name, req.params.id, req.user.companyId]
    );
    if (!result.affectedRows) {
      return res.status(404).json({
        success: false,
        message: 'Stage not found.',
      });
    }

    return res.json({
      success: true,
      data: { stage: { id: String(req.params.id), name } },
    });
  } catch (err) {
    console.error('renameStage error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to rename stage.',
    });
  }
}

async function ensureStages(companyId) {
  let stages = await getStages(companyId);
  if (stages.length) {
    return stages;
  }

  const conn = await db.getConnection();
  try {
    await seedPipelineStages(conn, companyId);
  } finally {
    conn.release();
  }

  stages = await getStages(companyId);
  if (stages.length) {
    return stages;
  }

  return DEFAULT_STAGES.map((stage, index) => ({
    id: stage.name.toLowerCase(),
    name: stage.name,
    order_index: index,
    color: stage.color,
  }));
}

function stageToKey(name) {
  const normalized = String(name || '').toLowerCase();
  if (normalized.includes('short')) return 'shortlisted';
  if (normalized.includes('interview')) return 'interview';
  if (normalized.includes('offer')) return 'offered';
  if (normalized.includes('hire')) return 'hired';
  if (normalized.includes('reject')) return 'rejected';
  return 'applied';
}

module.exports = {
  listPipelineStages,
  moveCandidate,
  renameStage,
};
