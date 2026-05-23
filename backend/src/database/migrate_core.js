const db = require('../config/database');
const { hashPassword } = require('../auth/passwords');

async function migrateCore() {
  const conn = await db.getConnection();
  const demoPasswordHash = hashPassword('password123');

  try {
    console.log('Running core schema migrations...\n');
    await conn.beginTransaction();

    await conn.query(`
      CREATE TABLE IF NOT EXISTS companies (
        id          INT AUTO_INCREMENT PRIMARY KEY,
        name        VARCHAR(255) NOT NULL,
        slug        VARCHAR(255) NOT NULL UNIQUE,
        email       VARCHAR(255) NOT NULL UNIQUE,
        phone       VARCHAR(20),
        website     VARCHAR(255),
        industry    VARCHAR(100),
        address     VARCHAR(500),
        logo        VARCHAR(500),
        is_active   TINYINT(1) DEFAULT 1,
        created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        deleted_at  TIMESTAMP NULL
      )
    `);
    console.log('OK companies table ready');

    await conn.query(`
      CREATE TABLE IF NOT EXISTS users (
        id             INT AUTO_INCREMENT PRIMARY KEY,
        company_id     INT NOT NULL,
        name           VARCHAR(255) NOT NULL,
        email          VARCHAR(255) NOT NULL UNIQUE,
        password_hash  VARCHAR(255),
        role           ENUM('admin', 'recruiter') DEFAULT 'admin',
        email_verified_at TIMESTAMP NULL,
        is_active      TINYINT(1) DEFAULT 1,
        created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        deleted_at     TIMESTAMP NULL,
        FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE
      )
    `);
    console.log('OK users table ready');

    try {
      await conn.query('ALTER TABLE users ADD COLUMN email_verified_at TIMESTAMP NULL');
    } catch (err) {
      if (err.code !== 'ER_DUP_FIELDNAME') {
        throw err;
      }
    }

    await conn.query(`
      CREATE TABLE IF NOT EXISTS candidates (
        id                INT AUTO_INCREMENT PRIMARY KEY,
        company_id        INT NOT NULL,
        name              VARCHAR(255) NOT NULL,
        email             VARCHAR(255) NOT NULL,
        phone             VARCHAR(20),
        current_title     VARCHAR(255),
        experience_years  DECIMAL(4,1) DEFAULT 0,
        skills            TEXT,
        tags              TEXT,
        status            ENUM('new', 'active', 'hired', 'rejected') DEFAULT 'new',
        created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        deleted_at        TIMESTAMP NULL,
        UNIQUE KEY unique_candidate_email_per_company (company_id, email),
        FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE
      )
    `);
    console.log('OK candidates table ready');

    await conn.query(`
      CREATE TABLE IF NOT EXISTS cvs (
        id             INT AUTO_INCREMENT PRIMARY KEY,
        company_id     INT NOT NULL,
        candidate_id   INT,
        original_name  VARCHAR(255) NOT NULL,
        stored_name    VARCHAR(255),
        file_path      VARCHAR(500),
        mime_type      VARCHAR(150),
        size_bytes     INT,
        created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted_at     TIMESTAMP NULL,
        KEY idx_cvs_company_candidate (company_id, candidate_id),
        FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
        FOREIGN KEY (candidate_id) REFERENCES candidates(id) ON DELETE CASCADE
      )
    `);
    console.log('OK cvs table ready');

    await conn.query(`
      CREATE TABLE IF NOT EXISTS activity_logs (
        id           INT AUTO_INCREMENT PRIMARY KEY,
        company_id   INT NOT NULL,
        user_id      INT,
        entity_type  VARCHAR(100) NOT NULL,
        entity_id    INT,
        action       VARCHAR(100) NOT NULL,
        description  TEXT,
        created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        KEY idx_activity_company_created (company_id, created_at),
        FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
      )
    `);
    console.log('OK activity_logs table ready');

    await conn.query(`
      CREATE TABLE IF NOT EXISTS candidate_notes (
        id            INT AUTO_INCREMENT PRIMARY KEY,
        company_id    INT NOT NULL,
        candidate_id  INT NOT NULL,
        user_id       INT,
        content       TEXT NOT NULL,
        created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        deleted_at    TIMESTAMP NULL,
        KEY idx_candidate_notes_candidate (candidate_id, created_at),
        FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
        FOREIGN KEY (candidate_id) REFERENCES candidates(id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
      )
    `);
    console.log('OK candidate_notes table ready');

    await conn.query(`
      CREATE TABLE IF NOT EXISTS audit_logs (
        id           INT AUTO_INCREMENT PRIMARY KEY,
        company_id   INT NOT NULL,
        user_id      INT,
        action       VARCHAR(100),
        entity_type  VARCHAR(100),
        entity_id    INT,
        description  TEXT,
        method       VARCHAR(10),
        endpoint     VARCHAR(255),
        status_code  INT,
        ip_address   VARCHAR(45),
        user_agent   VARCHAR(255),
        request_body TEXT,
        created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        KEY idx_audit_company_created (company_id, created_at),
        FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
      )
    `);
    console.log('OK audit_logs table ready');

    await conn.query(
      `INSERT INTO companies (id, name, slug, email, phone, website, industry, address)
       VALUES (1, 'HireOps Demo', 'hireops-demo', 'admin@hireops.io', '+1 555 0100',
               'https://hireops.io', 'Recruitment SaaS', 'Demo HQ')
       ON DUPLICATE KEY UPDATE
         name = VALUES(name),
         email = VALUES(email),
         website = VALUES(website),
         industry = VALUES(industry),
         address = VALUES(address),
         deleted_at = NULL`
    );

    await conn.query(
      `INSERT INTO users (id, company_id, name, email, password_hash, role, email_verified_at)
       VALUES (1, 1, 'Demo Admin', 'admin@hireops.io', ?, 'admin', CURRENT_TIMESTAMP)
       ON DUPLICATE KEY UPDATE
         company_id = VALUES(company_id),
         name = VALUES(name),
         password_hash = VALUES(password_hash),
         role = VALUES(role),
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
         '["Node.js","MySQL","REST"]', '["backend"]', 'new')
       ON DUPLICATE KEY UPDATE
         current_title = VALUES(current_title),
         experience_years = VALUES(experience_years),
         skills = VALUES(skills),
         tags = VALUES(tags),
         status = VALUES(status),
         deleted_at = NULL`
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

    await conn.query(`
      DELETE c FROM companies c
      WHERE c.id <> 1
        AND EXISTS (
          SELECT 1
          FROM users u
          WHERE u.company_id = c.id
            AND u.email_verified_at IS NULL
            AND u.deleted_at IS NULL
        )
        AND NOT EXISTS (
          SELECT 1
          FROM users u
          WHERE u.company_id = c.id
            AND u.email_verified_at IS NOT NULL
            AND u.deleted_at IS NULL
        )
    `);

    await conn.commit();
    console.log('\nCore schema migration completed.');
    console.log('Seeded demo company/user for dev headers: x-company-id=1, x-user-id=1, x-user-role=admin');
  } catch (err) {
    await conn.rollback();
    console.error('Core migration failed:', err.message);
    throw err;
  } finally {
    conn.release();
    process.exit(0);
  }
}

migrateCore();
