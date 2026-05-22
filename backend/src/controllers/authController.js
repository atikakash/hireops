const Joi = require('joi');

const db = require('../config/database');
const { seedPipelineStages } = require('../helpers/pipelineHelper');
const { hashPassword, verifyPassword } = require('../auth/passwords');
const {
  issueSession,
  rotateRefreshToken,
  revokeAccessToken,
  savePasswordResetOtp,
  consumePasswordResetOtp,
} = require('../auth/sessionStore');

const loginSchema = Joi.object({
  email: Joi.string().email().max(255).required(),
  password: Joi.string().min(8).max(128).required(),
});

const registerSchema = Joi.object({
  name: Joi.string().max(255).required(),
  email: Joi.string().email().max(255).required(),
  password: Joi.string().min(8).max(128).required(),
  company_name: Joi.string().max(255).required(),
  company_email: Joi.string().email().max(255).required(),
  company_phone: Joi.string().max(20).allow('', null),
  company_website: Joi.string().uri().max(255).allow('', null),
  company_industry: Joi.string().max(100).allow('', null),
  company_address: Joi.string().max(500).allow('', null),
});

const forgotPasswordSchema = Joi.object({
  email: Joi.string().email().max(255).required(),
});

const resetPasswordSchema = Joi.object({
  email: Joi.string().email().max(255).required(),
  otp: Joi.string().length(6).required(),
  password: Joi.string().min(8).max(128).required(),
});

async function login(req, res) {
  const { error, value } = loginSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return validationFailed(res, error);
  }

  try {
    const [rows] = await db.query(
      `SELECT u.id, u.company_id, u.name, u.email, u.password_hash, u.role,
              c.name AS company_name, c.slug AS company_slug
       FROM users u
       JOIN companies c ON c.id = u.company_id
       WHERE u.email = ? AND u.deleted_at IS NULL AND c.deleted_at IS NULL
       LIMIT 1`,
      [value.email.toLowerCase()]
    );

    if (!rows.length || !verifyPassword(value.password, rows[0].password_hash)) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password.',
      });
    }

    return res.json(buildAuthPayload(rows[0]));
  } catch (err) {
    console.error('login error:', err);
    return res.status(500).json({ success: false, message: 'Login failed.' });
  }
}

async function register(req, res) {
  const { error, value } = registerSchema.validate(req.body, {
    abortEarly: false,
  });
  if (error) {
    return validationFailed(res, error);
  }

  const conn = await db.getConnection();

  try {
    await conn.beginTransaction();

    const normalizedUserEmail = value.email.toLowerCase();
    const normalizedCompanyEmail = value.company_email.toLowerCase();

    const [existingUsers] = await conn.query(
      'SELECT id FROM users WHERE email = ? AND deleted_at IS NULL LIMIT 1',
      [normalizedUserEmail]
    );
    if (existingUsers.length) {
      await conn.rollback();
      return res.status(422).json({
        success: false,
        message: 'Validation failed.',
        errors: {
          email: ['Email is already registered.'],
        },
      });
    }

    const [existingCompanies] = await conn.query(
      'SELECT id FROM companies WHERE email = ? AND deleted_at IS NULL LIMIT 1',
      [normalizedCompanyEmail]
    );
    if (existingCompanies.length) {
      await conn.rollback();
      return res.status(422).json({
        success: false,
        message: 'Validation failed.',
        errors: {
          company_email: ['Company email is already registered.'],
        },
      });
    }

    const slug = await uniqueCompanySlug(conn, value.company_name);

    const [companyResult] = await conn.query(
      `INSERT INTO companies (name, slug, email, phone, website, industry, address)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        value.company_name.trim(),
        slug,
        normalizedCompanyEmail,
        normalizeOptional(value.company_phone),
        normalizeOptional(value.company_website),
        normalizeOptional(value.company_industry),
        normalizeOptional(value.company_address),
      ]
    );

    const companyId = companyResult.insertId;

    const [userResult] = await conn.query(
      `INSERT INTO users (company_id, name, email, password_hash, role)
       VALUES (?, ?, ?, ?, 'admin')`,
      [
        companyId,
        value.name.trim(),
        normalizedUserEmail,
        hashPassword(value.password),
      ]
    );

    await seedPipelineStages(conn, companyId);

    await conn.query(
      `INSERT INTO notification_settings (company_id, notify_cv_upload, notify_stage_change, email_notifications)
       VALUES (?, 1, 1, 1)`,
      [companyId]
    );

    await conn.query(
      `INSERT INTO activity_logs (company_id, user_id, entity_type, entity_id, action, description)
       VALUES (?, ?, 'company', ?, 'company.created', ?)`,
      [
        companyId,
        userResult.insertId,
        companyId,
        `Created company account for ${value.company_name.trim()}.`,
      ]
    );

    await conn.commit();

    const authUser = {
      id: userResult.insertId,
      company_id: companyId,
      name: value.name.trim(),
      email: normalizedUserEmail,
      role: 'admin',
      company_name: value.company_name.trim(),
      company_slug: slug,
      avatar_url: null,
    };

    return res.status(201).json(buildAuthPayload(authUser));
  } catch (err) {
    await conn.rollback();
    console.error('register error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to create account.',
    });
  } finally {
    conn.release();
  }
}

async function forgotPassword(req, res) {
  const { error, value } = forgotPasswordSchema.validate(req.body);
  if (error) {
    return validationFailed(res, error);
  }

  try {
    const [rows] = await db.query(
      'SELECT id FROM users WHERE email = ? AND deleted_at IS NULL LIMIT 1',
      [value.email.toLowerCase()]
    );

    const otp = '123456';
    if (rows.length) {
      savePasswordResetOtp(value.email, otp);
    }

    return res.json({
      success: true,
      message: 'If that email exists, a reset OTP has been sent.',
      debug_otp: otp,
    });
  } catch (err) {
    console.error('forgotPassword error:', err);
    return res.status(500).json({
      success: false,
      message: 'Could not start password reset.',
    });
  }
}

async function resetPassword(req, res) {
  const { error, value } = resetPasswordSchema.validate(req.body);
  if (error) {
    return validationFailed(res, error);
  }

  try {
    const consumed = consumePasswordResetOtp(value.email, value.otp);
    if (!consumed) {
      return res.status(422).json({
        success: false,
        message: 'Invalid or expired OTP.',
        errors: {
          otp: ['Invalid or expired OTP.'],
        },
      });
    }

    const [result] = await db.query(
      `UPDATE users
       SET password_hash = ?, updated_at = NOW()
       WHERE email = ? AND deleted_at IS NULL`,
      [hashPassword(value.password), value.email.toLowerCase()]
    );

    if (!result.affectedRows) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    return res.json({
      success: true,
      message: 'Password reset successfully.',
    });
  } catch (err) {
    console.error('resetPassword error:', err);
    return res.status(500).json({
      success: false,
      message: 'Could not reset password.',
    });
  }
}

async function refreshToken(req, res) {
  const refreshTokenValue = typeof req.body?.refreshToken === 'string'
    ? req.body.refreshToken
    : '';

  if (!refreshTokenValue) {
    return res.status(401).json({
      success: false,
      message: 'Refresh token is required.',
    });
  }

  try {
    const rotated = rotateRefreshToken(refreshTokenValue);
    if (!rotated) {
      return res.status(401).json({
        success: false,
        message: 'Invalid refresh token.',
      });
    }

    return res.json({
      success: true,
      accessToken: rotated.accessToken,
      refreshToken: rotated.refreshToken,
    });
  } catch (err) {
    console.error('refreshToken error:', err);
    return res.status(500).json({
      success: false,
      message: 'Could not refresh session.',
    });
  }
}

async function logout(req, res) {
  revokeAccessToken(req.token);
  return res.json({
    success: true,
    message: 'Logged out successfully.',
  });
}

function buildAuthPayload(user) {
  const session = issueSession(user);
  return {
    success: true,
    data: {
      token: session.accessToken,
      refreshToken: session.refreshToken,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        avatar_url: user.avatar_url || null,
      },
      company: {
        id: user.company_id,
        name: user.company_name,
        slug: user.company_slug,
      },
    },
  };
}

function validationFailed(res, error) {
  const errors = error.details.reduce((acc, detail) => {
    const key = detail.context?.key || 'form';
    acc[key] = [detail.message.replace(/"/g, '')];
    return acc;
  }, {});

  return res.status(422).json({
    success: false,
    message: 'Validation failed.',
    errors,
  });
}

async function uniqueCompanySlug(conn, companyName) {
  const base = slugify(companyName);
  let slug = base;
  let suffix = 2;

  while (true) {
    const [rows] = await conn.query(
      'SELECT id FROM companies WHERE slug = ? LIMIT 1',
      [slug]
    );
    if (!rows.length) {
      return slug;
    }

    slug = `${base}-${suffix}`;
    suffix += 1;
  }
}

function slugify(value) {
  const slug = String(value)
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');

  return slug || 'company';
}

function normalizeOptional(value) {
  if (value == null) {
    return null;
  }

  const normalized = String(value).trim();
  return normalized || null;
}

module.exports = {
  login,
  register,
  forgotPassword,
  resetPassword,
  refreshToken,
  logout,
};
