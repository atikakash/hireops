const db = require('../config/database');

const getDashboard = async (req, res) => {
  try {
    const data = await loadDashboardData(req.user.companyId);
    return res.json({
      success: true,
      data,
    });
  } catch (err) {
    console.error('getDashboard error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to load dashboard.',
    });
  }
};

const getDashboardStats = async (req, res) => {
  try {
    const data = await loadDashboardData(req.user.companyId);
    return res.json({
      success: true,
      data: {
        stats: {
          totalCandidates: toNumber(data.candidates.total),
          activeJobs: toNumber(data.jobs.open),
          totalHired: toNumber(data.candidates.hired),
          totalRejected: toNumber(data.candidates.rejected),
          candidatesPerStage: data.pipeline_stages.reduce((acc, stage) => {
            acc[stage.name] = toNumber(stage.candidate_count);
            return acc;
          }, {}),
          recentActivity: data.recent_activity,
        },
      },
    });
  } catch (err) {
    console.error('getDashboardStats error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to load dashboard stats.',
    });
  }
};

const getRecentActivity = async (req, res) => {
  try {
    const data = await loadDashboardData(req.user.companyId);
    return res.json({
      success: true,
      data: {
        activities: data.recent_activity,
      },
    });
  } catch (err) {
    console.error('getRecentActivity error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to load recent activity.',
    });
  }
};

async function loadDashboardData(companyId) {
  const addedTodaySql = db.isPostgres
    ? "SUM(CASE WHEN DATE(created_at) = CURRENT_DATE THEN 1 ELSE 0 END) AS added_today"
    : 'SUM(DATE(created_at) = CURDATE()) AS added_today';
  const addedWeekSql = db.isPostgres
    ? "SUM(CASE WHEN created_at >= NOW() - INTERVAL '7 days' THEN 1 ELSE 0 END) AS added_this_week"
    : 'SUM(created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)) AS added_this_week';
  const trendWindowSql = db.isPostgres
    ? "created_at >= NOW() - INTERVAL '7 days'"
    : 'created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)';

  const [
    [candidateStats],
    [jobStats],
    [stageStats],
    [recentActivity],
    [recentCandidates],
    [pipelineTrend],
  ] = await Promise.all([
    db.query(
      `SELECT
         COUNT(*) AS total,
         SUM(CASE WHEN status = 'new' THEN 1 ELSE 0 END) AS new_count,
         SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) AS active_count,
         SUM(CASE WHEN status = 'hired' THEN 1 ELSE 0 END) AS hired_count,
         SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) AS rejected_count,
         ${addedTodaySql},
         ${addedWeekSql}
       FROM candidates
       WHERE company_id = ? AND deleted_at IS NULL`,
      [companyId]
    ),
    db.query(
      `SELECT
         COUNT(*) AS total,
         SUM(CASE WHEN is_open = 1 THEN 1 ELSE 0 END) AS open_count,
         SUM(CASE WHEN is_open = 0 THEN 1 ELSE 0 END) AS closed_count
       FROM jobs
       WHERE company_id = ? AND deleted_at IS NULL`,
      [companyId]
    ),
    db.query(
      `SELECT
         ps.id,
         ps.name,
         ps.color,
         ps.order_index,
         COUNT(jc.id) AS candidate_count
       FROM pipeline_stages ps
       LEFT JOIN job_candidates jc
         ON jc.stage_id = ps.id
        AND jc.company_id = ps.company_id
       WHERE ps.company_id = ?
       GROUP BY ps.id, ps.name, ps.color, ps.order_index
       ORDER BY ps.order_index ASC`,
      [companyId]
    ),
    db.query(
      `SELECT
         al.id,
         al.entity_type,
         al.action,
         al.description,
         al.created_at,
         u.name AS user_name
       FROM activity_logs al
       LEFT JOIN users u ON u.id = al.user_id
       WHERE al.company_id = ?
       ORDER BY al.created_at DESC
       LIMIT 10`,
      [companyId]
    ),
    db.query(
      `SELECT
         c.id,
         c.name,
         c.current_title,
         c.experience_years,
         c.status,
         c.created_at,
         cv.original_name AS cv_name
       FROM candidates c
       LEFT JOIN cvs cv ON cv.candidate_id = c.id
       WHERE c.company_id = ? AND c.deleted_at IS NULL
       ORDER BY c.created_at DESC
       LIMIT 5`,
      [companyId]
    ),
    db.query(
      `SELECT
         DATE(created_at) AS date,
         COUNT(*) AS count
       FROM candidates
       WHERE company_id = ?
         AND ${trendWindowSql}
         AND deleted_at IS NULL
       GROUP BY DATE(created_at)
       ORDER BY date ASC`,
      [companyId]
    ),
  ]);

  return {
    candidates: {
      total: toNumber(candidateStats[0].total),
      new: toNumber(candidateStats[0].new_count),
      active: toNumber(candidateStats[0].active_count),
      hired: toNumber(candidateStats[0].hired_count),
      rejected: toNumber(candidateStats[0].rejected_count),
      added_today: toNumber(candidateStats[0].added_today),
      added_this_week: toNumber(candidateStats[0].added_this_week),
    },
    jobs: {
      total: toNumber(jobStats[0].total),
      open: toNumber(jobStats[0].open_count),
      closed: toNumber(jobStats[0].closed_count),
    },
    pipeline_stages: stageStats.map((stage) => ({
      id: stage.id,
      name: stage.name,
      color: stage.color,
      order_index: stage.order_index,
      candidate_count: toNumber(stage.candidate_count),
    })),
    recent_activity: recentActivity.map(toRecentActivityItem),
    recent_candidates: recentCandidates,
    cv_trend: fillMissingDays(pipelineTrend, 7),
  };
}

function toRecentActivityItem(row) {
  return {
    id: String(row.id),
    action: row.action || 'updated',
    actorName: row.user_name || 'System',
    targetName: row.description || null,
    createdAt:
      row.created_at instanceof Date
        ? row.created_at.toISOString()
        : new Date(row.created_at).toISOString(),
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

function fillMissingDays(rows, days) {
  const result = [];
  const map = {};

  rows.forEach((row) => {
    map[toIsoDateKey(row.date)] = toNumber(row.count);
  });

  for (let i = days - 1; i >= 0; i -= 1) {
    const date = new Date();
    date.setDate(date.getDate() - i);
    const key = date.toISOString().split('T')[0];
    result.push({ date: key, count: map[key] || 0 });
  }

  return result;
}

function toNumber(value) {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
}

function toIsoDateKey(value) {
  if (value instanceof Date) {
    return value.toISOString().split('T')[0];
  }

  return new Date(value).toISOString().split('T')[0];
}

module.exports = {
  getDashboard,
  getDashboardStats,
  getRecentActivity,
};
