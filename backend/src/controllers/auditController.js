const db = require('../config/database');

/**
 * GET /api/audit
 * Returns the audit log for the company. Admin only.
 * Task 32: Audit trail for sensitive actions.
 */
const getAuditLog = async (req, res) => {
  const companyId = req.user.companyId;
  const { action, user_id, entity_type, page = 1, limit = 30 } = req.query;
  const offset = (parseInt(page) - 1) * parseInt(limit);

  let where    = 'al.company_id = ?';
  const params = [companyId];

  if (action)      { where += ' AND al.action LIKE ?';       params.push(`%${action}%`); }
  if (user_id)     { where += ' AND al.user_id = ?';         params.push(user_id); }
  if (entity_type) { where += ' AND al.entity_type = ?';     params.push(entity_type); }

  try {
    const [rows] = await db.query(
      `SELECT
         al.id, al.action, al.entity_type, al.entity_id,
         al.description, al.ip_address, al.created_at,
         u.name  AS user_name,
         u.email AS user_email,
         u.role  AS user_role
       FROM audit_logs al
       LEFT JOIN users u ON u.id = al.user_id
       WHERE ${where}
       ORDER BY al.created_at DESC
       LIMIT ? OFFSET ?`,
      [...params, parseInt(limit), offset]
    );

    const [[{ total }]] = await db.query(
      `SELECT COUNT(*) AS total FROM audit_logs al WHERE ${where}`,
      params
    );

    return res.json({
      success: true,
      data: {
        logs: rows,
        pagination: {
          total: parseInt(total),
          page:  parseInt(page),
          limit: parseInt(limit),
          pages: Math.ceil(total / limit),
        },
      },
    });
  } catch (err) {
    console.error('getAuditLog error:', err);
    return res.status(500).json({ success: false, message: 'Failed to fetch audit log.' });
  }
};

module.exports = { getAuditLog };
