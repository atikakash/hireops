const Joi = require('joi');

const db = require('../config/database');

const stageRenameSchema = Joi.object({
  stages: Joi.array()
    .items(
      Joi.object({
        id: Joi.number().integer().required(),
        name: Joi.string().max(100).required(),
        color: Joi.string().max(20).allow('', null),
      })
    )
    .min(1)
    .required(),
});

const getAllSettings = async (req, res) => {
  const companyId = req.user.companyId;

  try {
    const [[companies], [stages], [notificationRows]] = await Promise.all([
      db.query(
        `SELECT id, name, slug, email, phone, website, industry, address, logo
         FROM companies
         WHERE id = ? AND deleted_at IS NULL
         LIMIT 1`,
        [companyId]
      ),
      db.query(
        `SELECT id, name, color, order_index
         FROM pipeline_stages
         WHERE company_id = ?
         ORDER BY order_index ASC`,
        [companyId]
      ),
      db.query(
        `SELECT notify_cv_upload, notify_stage_change, email_notifications
         FROM notification_settings
         WHERE company_id = ?
         LIMIT 1`,
        [companyId]
      ),
    ]);

    if (!companies.length) {
      return res.status(404).json({
        success: false,
        message: 'Company not found.',
      });
    }

    const defaultNotifications = {
      notify_cv_upload: true,
      notify_stage_change: true,
      email_notifications: true,
    };

    return res.json({
      success: true,
      data: {
        company: companies[0],
        pipeline_stages: stages,
        notifications: notificationRows.length
            ? notificationRows[0]
            : defaultNotifications,
      },
    });
  } catch (err) {
    console.error('getAllSettings error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to load settings.',
    });
  }
};

const updateCompanySettings = async (req, res) => {
  const schema = Joi.object({
    name: Joi.string().max(255).required(),
    email: Joi.string().email().max(255).required(),
    phone: Joi.string().max(20).allow('', null),
    website: Joi.string().uri().max(255).allow('', null),
    industry: Joi.string().max(100).allow('', null),
    address: Joi.string().max(500).allow('', null),
  });

  const { error, value } = schema.validate(req.body, { abortEarly: false });
  if (error) {
    const errors = error.details.reduce((acc, detail) => {
      acc[detail.context.key] = detail.message.replace(/"/g, '');
      return acc;
    }, {});

    return res.status(422).json({
      success: false,
      message: 'Validation failed.',
      errors,
    });
  }

  try {
    const [existing] = await db.query(
      'SELECT id FROM companies WHERE email = ? AND id != ? LIMIT 1',
      [value.email, req.user.companyId]
    );

    if (existing.length) {
      return res.status(422).json({
        success: false,
        message: 'Validation failed.',
        errors: { email: 'Email is already used by another company.' },
      });
    }

    await db.query(
      `UPDATE companies
       SET name = ?, email = ?, phone = ?, website = ?, industry = ?, address = ?, updated_at = NOW()
       WHERE id = ?`,
      [
        value.name,
        value.email,
        value.phone || null,
        value.website || null,
        value.industry || null,
        value.address || null,
        req.user.companyId,
      ]
    );

    const [companyRows] = await db.query(
      `SELECT id, name, slug, email, phone, website, industry, address, logo
       FROM companies
       WHERE id = ?
       LIMIT 1`,
      [req.user.companyId]
    );

    return res.json({
      success: true,
      message: 'Company settings updated successfully.',
      data: {
        company: companyRows[0],
      },
    });
  } catch (err) {
    console.error('updateCompanySettings error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to update company settings.',
    });
  }
};

const renamePipelineStages = async (req, res) => {
  const { error, value } = stageRenameSchema.validate(req.body, {
    abortEarly: false,
  });
  if (error) {
    return res.status(422).json({
      success: false,
      message: 'Invalid stages data.',
    });
  }

  const conn = await db.getConnection();

  try {
    await conn.beginTransaction();

    for (const stage of value.stages) {
      const [rows] = await conn.query(
        'SELECT id FROM pipeline_stages WHERE id = ? AND company_id = ? LIMIT 1',
        [stage.id, req.user.companyId]
      );

      if (!rows.length) {
        continue;
      }

      await conn.query(
        'UPDATE pipeline_stages SET name = ?, color = ? WHERE id = ?',
        [stage.name, stage.color || '#1A73E8', stage.id]
      );
    }

    await conn.commit();

    const [stages] = await db.query(
      `SELECT id, name, color, order_index
       FROM pipeline_stages
       WHERE company_id = ?
       ORDER BY order_index ASC`,
      [req.user.companyId]
    );

    return res.json({
      success: true,
      message: 'Pipeline stages updated successfully.',
      data: { stages },
    });
  } catch (err) {
    await conn.rollback();
    console.error('renamePipelineStages error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to update pipeline stages.',
    });
  } finally {
    conn.release();
  }
};

const updateNotificationSettings = async (req, res) => {
  const schema = Joi.object({
    notify_cv_upload: Joi.boolean().required(),
    notify_stage_change: Joi.boolean().required(),
  });

  const { error, value } = schema.validate(req.body);
  if (error) {
    return res.status(422).json({
      success: false,
      message: 'Invalid notification settings.',
    });
  }

  try {
    await db.query(
      db.isPostgres
        ? `INSERT INTO notification_settings (company_id, notify_cv_upload, notify_stage_change)
           VALUES (?, ?, ?)
           ON CONFLICT (company_id) DO UPDATE SET
             notify_cv_upload = EXCLUDED.notify_cv_upload,
             notify_stage_change = EXCLUDED.notify_stage_change,
             updated_at = NOW()`
        : `INSERT INTO notification_settings (company_id, notify_cv_upload, notify_stage_change)
           VALUES (?, ?, ?)
           ON DUPLICATE KEY UPDATE
             notify_cv_upload = VALUES(notify_cv_upload),
             notify_stage_change = VALUES(notify_stage_change),
             updated_at = NOW()`,
      [
        req.user.companyId,
        value.notify_cv_upload ? 1 : 0,
        value.notify_stage_change ? 1 : 0,
      ]
    );

    return res.json({
      success: true,
      message: 'Notification settings updated.',
      data: {
        notifications: {
          notify_cv_upload: value.notify_cv_upload,
          notify_stage_change: value.notify_stage_change,
          email_notifications: true,
        },
      },
    });
  } catch (err) {
    console.error('updateNotificationSettings error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to update notification settings.',
    });
  }
};

module.exports = {
  getAllSettings,
  updateCompanySettings,
  renamePipelineStages,
  updateNotificationSettings,
};
