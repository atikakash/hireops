const db = require('../config/database');

const listNotifications = async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT al.id, al.entity_type, al.entity_id, al.action, al.description,
              al.created_at, u.name AS user_name
       FROM activity_logs al
       LEFT JOIN users u ON u.id = al.user_id
       WHERE al.company_id = ?
       ORDER BY al.created_at DESC
       LIMIT 30`,
      [req.user.companyId]
    );

    return res.json({
      success: true,
      data: { notifications: rows.map(toNotificationResponse) },
    });
  } catch (err) {
    console.error('listNotifications error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch notifications.',
    });
  }
};

/**
 * GET /api/notifications/settings
 * Get notification preferences for the company.
 */
const getSettings = async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM notification_settings WHERE company_id = ? LIMIT 1',
      [req.user.companyId]
    );

    // If no settings row yet, return defaults
    if (!rows.length) {
      return res.json({
        success: true,
        data: {
          settings: {
            notify_cv_upload:    true,
            notify_stage_change: true,
            cvUploadedEmail: true,
            stageMovedEmail: true,
            jobAssignedEmail: true,
            pushEnabled: true,
          },
        },
      });
    }

    return res.json({
      success: true,
      data: {
        settings: {
          notify_cv_upload:    !!rows[0].notify_cv_upload,
          notify_stage_change: !!rows[0].notify_stage_change,
          cvUploadedEmail: !!rows[0].notify_cv_upload,
          stageMovedEmail: !!rows[0].notify_stage_change,
          jobAssignedEmail: !!rows[0].email_notifications,
          pushEnabled: true,
        },
      },
    });
  } catch (err) {
    console.error('getSettings error:', err);
    return res.status(500).json({ success: false, message: 'Failed to fetch notification settings.' });
  }
};

/**
 * PUT /api/notifications/settings
 * Update notification preferences. Admin only.
 */
const updateSettings = async (req, res) => {
  const notify_cv_upload =
    req.body.notify_cv_upload ?? req.body.cvUploadedEmail;
  const notify_stage_change =
    req.body.notify_stage_change ?? req.body.stageMovedEmail;
  const email_notifications =
    req.body.email_notifications ?? req.body.jobAssignedEmail;

  try {
    // Upsert — insert or update on duplicate company_id
    await db.query(
      db.isPostgres
        ? `INSERT INTO notification_settings
            (company_id, notify_cv_upload, notify_stage_change, email_notifications)
           VALUES (?, ?, ?, ?)
           ON CONFLICT (company_id) DO UPDATE SET
             notify_cv_upload = EXCLUDED.notify_cv_upload,
             notify_stage_change = EXCLUDED.notify_stage_change,
             email_notifications = EXCLUDED.email_notifications,
             updated_at = NOW()`
        : `INSERT INTO notification_settings
            (company_id, notify_cv_upload, notify_stage_change, email_notifications)
           VALUES (?, ?, ?, ?)
           ON DUPLICATE KEY UPDATE
             notify_cv_upload = VALUES(notify_cv_upload),
             notify_stage_change = VALUES(notify_stage_change),
             email_notifications = VALUES(email_notifications),
             updated_at = NOW()`,
      [
        req.user.companyId,
        notify_cv_upload    !== undefined ? (notify_cv_upload    ? 1 : 0) : 1,
        notify_stage_change !== undefined ? (notify_stage_change ? 1 : 0) : 1,
        email_notifications !== undefined ? (email_notifications ? 1 : 0) : 1,
      ]
    );

    return res.json({
      success: true,
      message: 'Notification settings updated.',
      data: {
        settings: {
          notify_cv_upload:    !!notify_cv_upload,
          notify_stage_change: !!notify_stage_change,
          cvUploadedEmail: notify_cv_upload !== undefined ? !!notify_cv_upload : true,
          stageMovedEmail:
            notify_stage_change !== undefined ? !!notify_stage_change : true,
          jobAssignedEmail:
            email_notifications !== undefined ? !!email_notifications : true,
          pushEnabled: true,
        },
      },
    });
  } catch (err) {
    console.error('updateSettings error:', err);
    return res.status(500).json({ success: false, message: 'Failed to update notification settings.' });
  }
};

const markRead = (_req, res) =>
  res.json({ success: true, message: 'Notification marked as read.' });

const markAllRead = (_req, res) =>
  res.json({ success: true, message: 'Notifications marked as read.' });

function toNotificationResponse(row) {
  const type = mapActivityType(row.entity_type, row.action);
  return {
    id: String(row.id),
    title: notificationTitle(type),
    body: row.description || `${row.user_name || 'Someone'} updated HireOps.`,
    type,
    createdAt: toIso(row.created_at),
    isRead: false,
    candidateId:
      row.entity_type === 'candidate' && row.entity_id != null
        ? String(row.entity_id)
        : null,
    jobId:
      row.entity_type === 'job' && row.entity_id != null
        ? String(row.entity_id)
        : null,
  };
}

function notificationTitle(type) {
  return {
    cvUploaded: 'CV uploaded',
    stageMoved: 'Candidate stage updated',
    jobAssigned: 'Job assignment updated',
    system: 'HireOps update',
  }[type] || 'HireOps update';
}

function mapActivityType(entityType, action) {
  const normalizedAction = String(action || '').toLowerCase();
  const normalizedEntity = String(entityType || '').toLowerCase();

  if (normalizedAction.includes('cv') || normalizedEntity === 'cv') {
    return 'cvUploaded';
  }
  if (normalizedAction.includes('stage') || normalizedEntity === 'pipeline') {
    return 'stageMoved';
  }
  if (normalizedAction.includes('job') || normalizedEntity === 'job') {
    return 'jobAssigned';
  }
  return 'system';
}

function toIso(value) {
  if (!value) {
    return new Date().toISOString();
  }
  return value instanceof Date ? value.toISOString() : new Date(value).toISOString();
}

module.exports = {
  listNotifications,
  getSettings,
  updateSettings,
  markRead,
  markAllRead,
};
