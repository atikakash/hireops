const db = require('../config/database');

async function getActivityLog(req, res) {
  try {
    const limit = Math.min(Number(req.query.limit || 50), 100);
    const [rows] = await db.query(
      `SELECT al.id, al.entity_type, al.action, al.description, al.created_at,
              u.name AS user_name
       FROM activity_logs al
       LEFT JOIN users u ON u.id = al.user_id
       WHERE al.company_id = ?
       ORDER BY al.created_at DESC
       LIMIT ?`,
      [req.user.companyId, limit]
    );

    return res.json({
      success: true,
      data: { activities: rows.map(toActivityResponse) },
    });
  } catch (err) {
    console.error('getActivityLog error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to load activity log.',
    });
  }
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

function toIso(value) {
  if (!value) {
    return new Date().toISOString();
  }
  return value instanceof Date ? value.toISOString() : new Date(value).toISOString();
}

module.exports = {
  getActivityLog,
  toActivityResponse,
};
