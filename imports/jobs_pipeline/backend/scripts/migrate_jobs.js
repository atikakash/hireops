const db = require('../config/database');

async function migrateJobsModule() {
  const conn = await db.getConnection();

  try {
    console.log('🚀 Running Jobs & Pipeline migrations...\n');

    // ── Jobs table ────────────────────────────────────────────────────────────
    await conn.query(`
      CREATE TABLE IF NOT EXISTS jobs (
        id           INT AUTO_INCREMENT PRIMARY KEY,
        company_id   INT          NOT NULL,
        title        VARCHAR(255) NOT NULL,
        department   VARCHAR(255),
        location     VARCHAR(255),
        type         ENUM('full_time','part_time','contract','internship') DEFAULT 'full_time',
        description  TEXT,
        requirements TEXT,
        is_open      TINYINT(1) DEFAULT 1,
        created_by   INT NOT NULL,
        created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        deleted_at   TIMESTAMP NULL,
        FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
        FOREIGN KEY (created_by) REFERENCES users(id)
      )
    `);
    console.log('✅ jobs table created');

    // ── Pipeline stages table (customizable per company) ──────────────────────
    await conn.query(`
      CREATE TABLE IF NOT EXISTS pipeline_stages (
        id         INT AUTO_INCREMENT PRIMARY KEY,
        company_id INT          NOT NULL,
        name       VARCHAR(100) NOT NULL,
        order_index INT         NOT NULL DEFAULT 0,
        color      VARCHAR(20)  DEFAULT '#1A73E8',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE
      )
    `);
    console.log('✅ pipeline_stages table created');

    // ── Job candidates (pipeline assignments) ─────────────────────────────────
    await conn.query(`
      CREATE TABLE IF NOT EXISTS job_candidates (
        id           INT AUTO_INCREMENT PRIMARY KEY,
        company_id   INT NOT NULL,
        job_id       INT NOT NULL,
        candidate_id INT NOT NULL,
        stage_id     INT NOT NULL,
        notes        TEXT,
        assigned_by  INT NOT NULL,
        assigned_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE KEY unique_job_candidate (job_id, candidate_id),
        FOREIGN KEY (company_id)   REFERENCES companies(id)   ON DELETE CASCADE,
        FOREIGN KEY (job_id)       REFERENCES jobs(id)        ON DELETE CASCADE,
        FOREIGN KEY (candidate_id) REFERENCES candidates(id)  ON DELETE CASCADE,
        FOREIGN KEY (stage_id)     REFERENCES pipeline_stages(id),
        FOREIGN KEY (assigned_by)  REFERENCES users(id)
      )
    `);
    console.log('✅ job_candidates table created');

    // ── Seed default pipeline stages for new companies ────────────────────────
    // (These are inserted when a company registers; here for reference)
    console.log('\n📋 Default pipeline stages: Applied → Shortlisted → Interview → Offered → Hired / Rejected');
    console.log('   (Seeded automatically on company registration)\n');

    console.log('🎉 Jobs & Pipeline migrations completed!');
  } catch (err) {
    console.error('❌ Migration failed:', err.message);
    throw err;
  } finally {
    conn.release();
    process.exit(0);
  }
}

migrateJobsModule();
