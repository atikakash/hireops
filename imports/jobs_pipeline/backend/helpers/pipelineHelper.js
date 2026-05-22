const db = require('../config/database');

const DEFAULT_STAGES = [
  { name: 'Applied',     order_index: 1, color: '#8E8E93' },
  { name: 'Shortlisted', order_index: 2, color: '#1A73E8' },
  { name: 'Interview',   order_index: 3, color: '#F9AB00' },
  { name: 'Offered',     order_index: 4, color: '#9C27B0' },
  { name: 'Hired',       order_index: 5, color: '#34A853' },
  { name: 'Rejected',    order_index: 6, color: '#EA4335' },
];

/**
 * Seeds default pipeline stages for a newly registered company.
 * Call this inside the register transaction.
 */
async function seedPipelineStages(conn, companyId) {
  for (const stage of DEFAULT_STAGES) {
    await conn.query(
      `INSERT INTO pipeline_stages (company_id, name, order_index, color)
       VALUES (?, ?, ?, ?)`,
      [companyId, stage.name, stage.order_index, stage.color]
    );
  }
}

/**
 * Get all pipeline stages for a company.
 */
async function getStages(companyId) {
  const [rows] = await db.query(
    `SELECT id, name, order_index, color
     FROM pipeline_stages WHERE company_id = ?
     ORDER BY order_index ASC`,
    [companyId]
  );
  return rows;
}

module.exports = { seedPipelineStages, getStages, DEFAULT_STAGES };
