const db = require('../config/database');
const { hashPassword } = require('../auth/passwords');

async function migratePostgres() {
  if (!db.isPostgres) {
    throw new Error('migrate:postgres requires DATABASE_URL or DB_CLIENT=postgres');
  }

  const conn = await db.getConnection();
  const demoPasswordHash = hashPassword('password123');

  try {
    console.log('Running PostgreSQL schema migrations...');
    await conn.beginTransaction();

    await conn.query(`
      CREATE TABLE IF NOT EXISTS companies (
        id          SERIAL PRIMARY KEY,
        name        VARCHAR(255) NOT NULL,
        slug        VARCHAR(255) NOT NULL UNIQUE,
        email       VARCHAR(255) NOT NULL UNIQUE,
        phone       VARCHAR(20),
        website     VARCHAR(255),
        industry    VARCHAR(100),
        address     VARCHAR(500),
        logo        VARCHAR(500),
        is_active   INTEGER DEFAULT 1,
        created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted_at  TIMESTAMP NULL
      )
    `);

    await conn.query(`
      CREATE TABLE IF NOT EXISTS users (
        id             SERIAL PRIMARY KEY,
        company_id     INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
        name           VARCHAR(255) NOT NULL,
        email          VARCHAR(255) NOT NULL UNIQUE,
        password_hash  VARCHAR(255),
        role           VARCHAR(30) DEFAULT 'admin',
        email_verified_at TIMESTAMP NULL,
        is_active      INTEGER DEFAULT 1,
        created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted_at     TIMESTAMP NULL
      )
    `);

    await conn.query(`
      ALTER TABLE users
      ADD COLUMN IF NOT EXISTS email_verified_at TIMESTAMP NULL
    `);

    await conn.query(`
      UPDATE users
      SET email_verified_at = CURRENT_TIMESTAMP
      WHERE email_verified_at IS NULL
    `);

    await conn.query(`
      CREATE TABLE IF NOT EXISTS candidates (
        id                SERIAL PRIMARY KEY,
        company_id        INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
        name              VARCHAR(255) NOT NULL,
        email             VARCHAR(255) NOT NULL,
        phone             VARCHAR(20),
        current_title     VARCHAR(255),
        experience_years  NUMERIC(4,1) DEFAULT 0,
        skills            TEXT,
        tags              TEXT,
        status            VARCHAR(30) DEFAULT 'new',
        created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted_at        TIMESTAMP NULL,
        UNIQUE (company_id, email)
      )
    `);

    await conn.query(`
      CREATE TABLE IF NOT EXISTS cvs (
        id             SERIAL PRIMARY KEY,
        company_id     INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
        candidate_id   INTEGER REFERENCES candidates(id) ON DELETE CASCADE,
        original_name  VARCHAR(255) NOT NULL,
        stored_name    VARCHAR(255),
        file_path      VARCHAR(500),
        mime_type      VARCHAR(150),
        size_bytes     INTEGER,
        created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted_at     TIMESTAMP NULL
      )
    `);

    await conn.query(`
      CREATE INDEX IF NOT EXISTS idx_cvs_company_candidate
      ON cvs(company_id, candidate_id)
    `);

    await conn.query(`
      CREATE TABLE IF NOT EXISTS activity_logs (
        id           SERIAL PRIMARY KEY,
        company_id   INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
        user_id      INTEGER REFERENCES users(id) ON DELETE SET NULL,
        entity_type  VARCHAR(100) NOT NULL,
        entity_id    INTEGER,
        action       VARCHAR(100) NOT NULL,
        description  TEXT,
        created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    await conn.query(`
      CREATE INDEX IF NOT EXISTS idx_activity_company_created
      ON activity_logs(company_id, created_at)
    `);

    await conn.query(`
      CREATE TABLE IF NOT EXISTS candidate_notes (
        id            SERIAL PRIMARY KEY,
        company_id    INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
        candidate_id  INTEGER NOT NULL REFERENCES candidates(id) ON DELETE CASCADE,
        user_id       INTEGER REFERENCES users(id) ON DELETE SET NULL,
        content       TEXT NOT NULL,
        created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted_at    TIMESTAMP NULL
      )
    `);

    await conn.query(`
      CREATE INDEX IF NOT EXISTS idx_candidate_notes_candidate
      ON candidate_notes(candidate_id, created_at)
    `);

    await conn.query(`
      CREATE TABLE IF NOT EXISTS audit_logs (
        id           SERIAL PRIMARY KEY,
        company_id   INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
        user_id      INTEGER REFERENCES users(id) ON DELETE SET NULL,
        action       VARCHAR(100),
        entity_type  VARCHAR(100),
        entity_id    INTEGER,
        description  TEXT,
        method       VARCHAR(10),
        endpoint     VARCHAR(255),
        status_code  INTEGER,
        ip_address   VARCHAR(45),
        user_agent   VARCHAR(255),
        request_body TEXT,
        created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    await conn.query(`
      CREATE INDEX IF NOT EXISTS idx_audit_company_created
      ON audit_logs(company_id, created_at)
    `);

    await conn.query(`
      CREATE TABLE IF NOT EXISTS jobs (
        id           SERIAL PRIMARY KEY,
        company_id   INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
        title        VARCHAR(255) NOT NULL,
        department   VARCHAR(255),
        location     VARCHAR(255),
        type         VARCHAR(30) DEFAULT 'full_time',
        description  TEXT,
        requirements TEXT,
        is_open      INTEGER DEFAULT 1,
        created_by   INTEGER NOT NULL REFERENCES users(id),
        created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted_at   TIMESTAMP NULL
      )
    `);

    await conn.query(`
      CREATE TABLE IF NOT EXISTS pipeline_stages (
        id          SERIAL PRIMARY KEY,
        company_id  INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
        name        VARCHAR(100) NOT NULL,
        order_index INTEGER NOT NULL DEFAULT 0,
        color       VARCHAR(20) DEFAULT '#1A73E8',
        created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    await conn.query(`
      CREATE TABLE IF NOT EXISTS job_candidates (
        id           SERIAL PRIMARY KEY,
        company_id   INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
        job_id       INTEGER NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
        candidate_id INTEGER NOT NULL REFERENCES candidates(id) ON DELETE CASCADE,
        stage_id     INTEGER NOT NULL REFERENCES pipeline_stages(id),
        notes        TEXT,
        assigned_by  INTEGER NOT NULL REFERENCES users(id),
        assigned_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE (job_id, candidate_id)
      )
    `);

    await conn.query(`
      CREATE TABLE IF NOT EXISTS notification_settings (
        id                    SERIAL PRIMARY KEY,
        company_id            INTEGER NOT NULL UNIQUE REFERENCES companies(id) ON DELETE CASCADE,
        notify_cv_upload      INTEGER DEFAULT 1,
        notify_stage_change   INTEGER DEFAULT 1,
        email_notifications   INTEGER DEFAULT 1,
        created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    await seedDemoData(conn, demoPasswordHash);
    await resetSerialSequences(conn);

    await conn.commit();
    console.log('PostgreSQL migrations completed.');
  } catch (err) {
    await conn.rollback();
    console.error('PostgreSQL migration failed:', err);
    throw err;
  } finally {
    conn.release();
    await db.end();
  }
}

async function seedDemoData(conn, demoPasswordHash) {
  await conn.query(
    `INSERT INTO companies (id, name, slug, email, phone, website, industry, address)
     VALUES (1, 'HireOps Demo', 'hireops-demo', 'admin@hireops.io', '+1 555 0100',
             'https://hireops.io', 'Recruitment SaaS', 'Demo HQ')
     ON CONFLICT (id) DO UPDATE SET
       name = EXCLUDED.name,
       email = EXCLUDED.email,
       website = EXCLUDED.website,
       industry = EXCLUDED.industry,
       address = EXCLUDED.address,
       deleted_at = NULL`
  );

  await conn.query(
    `INSERT INTO users (id, company_id, name, email, password_hash, role, email_verified_at)
     VALUES (1, 1, 'Demo Admin', 'admin@hireops.io', ?, 'admin', CURRENT_TIMESTAMP)
     ON CONFLICT (id) DO UPDATE SET
       company_id = EXCLUDED.company_id,
       name = EXCLUDED.name,
       password_hash = EXCLUDED.password_hash,
       role = EXCLUDED.role,
       email_verified_at = CURRENT_TIMESTAMP,
       deleted_at = NULL`,
    [demoPasswordHash]
  );

  await conn.query(
    `INSERT INTO candidates
      (company_id, name, email, phone, current_title, experience_years, skills, tags, status)
     VALUES
      (1, 'Ava Patel', 'ava.patel@example.com', '+1 555 0110', 'Frontend Engineer', 5.0,
       '["Flutter","React","TypeScript"]', '["frontend","senior"]', 'active'),
      (1, 'Noah Kim', 'noah.kim@example.com', '+1 555 0111', 'Backend Engineer', 4.0,
       '["Node.js","PostgreSQL","REST"]', '["backend"]', 'new')
     ON CONFLICT (company_id, email) DO UPDATE SET
       current_title = EXCLUDED.current_title,
       experience_years = EXCLUDED.experience_years,
       skills = EXCLUDED.skills,
       tags = EXCLUDED.tags,
       status = EXCLUDED.status,
       deleted_at = NULL`
  );

  for (const [index, stage] of [
    ['Applied', '#8E8E93'],
    ['Shortlisted', '#1A73E8'],
    ['Interview', '#F9AB00'],
    ['Offered', '#9C27B0'],
    ['Hired', '#34A853'],
    ['Rejected', '#EA4335'],
  ].entries()) {
    await conn.query(
      `INSERT INTO pipeline_stages (company_id, name, order_index, color)
       SELECT 1, ?, ?, ?
       WHERE NOT EXISTS (
         SELECT 1 FROM pipeline_stages WHERE company_id = 1 AND name = ?
       )`,
      [stage[0], index + 1, stage[1], stage[0]]
    );
  }

  await conn.query(
    `INSERT INTO notification_settings
       (company_id, notify_cv_upload, notify_stage_change, email_notifications)
     VALUES (1, 1, 1, 1)
     ON CONFLICT (company_id) DO NOTHING`
  );

  await conn.query(
    `INSERT INTO activity_logs (company_id, user_id, entity_type, entity_id, action, description)
     SELECT 1, 1, 'candidate', c.id, 'candidate.created', CONCAT('Candidate added: ', c.name)
     FROM candidates c
     WHERE c.company_id = 1
       AND NOT EXISTS (
         SELECT 1
         FROM activity_logs al
         WHERE al.company_id = 1
           AND al.entity_type = 'candidate'
           AND al.entity_id = c.id
           AND al.action = 'candidate.created'
       )`
  );
}

async function resetSerialSequences(conn) {
  const serialTables = [
    'companies',
    'users',
    'candidates',
    'cvs',
    'activity_logs',
    'candidate_notes',
    'audit_logs',
    'jobs',
    'pipeline_stages',
    'job_candidates',
    'notification_settings',
  ];

  for (const table of serialTables) {
    await conn.query(`
      SELECT setval(
        pg_get_serial_sequence('${table}', 'id'),
        GREATEST(COALESCE((SELECT MAX(id) FROM ${table}), 0) + 1, 1),
        false
      )
    `);
  }
}

migratePostgres().catch(() => process.exit(1));
