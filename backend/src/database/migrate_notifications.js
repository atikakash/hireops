const db = require('../config/database');

async function migrateNotificationSettings() {
  const conn = await db.getConnection();
  try {
    console.log('🚀 Running Notification Settings migration...\n');

    await conn.query(`
      CREATE TABLE IF NOT EXISTS notification_settings (
        id                    INT AUTO_INCREMENT PRIMARY KEY,
        company_id            INT         NOT NULL UNIQUE,
        notify_cv_upload      TINYINT(1)  DEFAULT 1,
        notify_stage_change   TINYINT(1)  DEFAULT 1,
        email_notifications   TINYINT(1)  DEFAULT 1,
        created_at            TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
        updated_at            TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE
      )
    `);
    const [emailNotificationColumn] = await conn.query(
      `SELECT 1
       FROM information_schema.COLUMNS
       WHERE TABLE_SCHEMA = DATABASE()
         AND TABLE_NAME = 'notification_settings'
         AND COLUMN_NAME = 'email_notifications'
       LIMIT 1`
    );

    if (!emailNotificationColumn.length) {
      await conn.query(`
        ALTER TABLE notification_settings
        ADD COLUMN email_notifications TINYINT(1) DEFAULT 1
      `);
    }
    console.log('✅ notification_settings table created');
    console.log('\n🎉 Notification Settings migration completed!');
  } catch (err) {
    console.error('❌ Migration failed:', err.message);
    throw err;
  } finally {
    conn.release();
    process.exit(0);
  }
}

migrateNotificationSettings();
