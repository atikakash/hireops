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
  saveEmailVerificationOtp,
  consumeEmailVerificationOtp,
  savePendingRegistration,
  getPendingRegistration,
  consumePendingRegistration,
} = require('../auth/sessionStore');
const {
  sendEmailVerificationOtp,
  sendPasswordResetOtp,
} = require('../services/emailService');

const loginSchema = Joi.object({
  email: Joi.string().trim().lowercase().email().max(255).required(),
  password: Joi.string().min(8).max(128).required(),
});

const registerSchema = Joi.object({
  name: Joi.string().max(255).required(),
  email: Joi.string().trim().lowercase().email().max(255).required(),
  password: Joi.string().min(8).max(128).required(),
  company_name: Joi.string().max(255).required(),
  company_email: Joi.string().trim().lowercase().email().max(255).required(),
  company_phone: Joi.string().max(20).allow('', null),
  company_website: Joi.string().uri().max(255).allow('', null),
  company_industry: Joi.string().max(100).allow('', null),
  company_address: Joi.string().max(500).allow('', null),
});

const forgotPasswordSchema = Joi.object({
  email: Joi.string().trim().lowercase().email().max(255).required(),
});

const verifyEmailSchema = Joi.object({
  email: Joi.string().trim().lowercase().email().max(255).required(),
  otp: Joi.string().length(6).required(),
});

const resendVerificationSchema = Joi.object({
  email: Joi.string().trim().lowercase().email().max(255).required(),
});

const resetPasswordSchema = Joi.object({
  email: Joi.string().trim().lowercase().email().max(255).required(),
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
              u.email_verified_at,
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

    if (!rows[0].email_verified_at) {
      return res.status(403).json({
        success: false,
        message: 'Please verify your email before signing in.',
        needsEmailVerification: true,
        email: value.email,
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

  try {
    const normalizedUserEmail = value.email.toLowerCase();
    const normalizedCompanyEmail = value.company_email.toLowerCase();

    const [existingUsers] = await db.query(
      'SELECT id, company_id, email_verified_at FROM users WHERE email = ? AND deleted_at IS NULL LIMIT 1',
      [normalizedUserEmail]
    );
    if (existingUsers.length) {
      if (!existingUsers[0].email_verified_at) {
        await deleteUnverifiedAccount(existingUsers[0]);
      } else {
        return res.status(422).json({
          success: false,
          message: 'Validation failed.',
          errors: {
            email: ['Email is already registered.'],
          },
        });
      }
    }

    const [existingCompanies] = await db.query(
      'SELECT id FROM companies WHERE email = ? AND deleted_at IS NULL LIMIT 1',
      [normalizedCompanyEmail]
    );
    if (existingCompanies.length) {
      return res.status(422).json({
        success: false,
        message: 'Validation failed.',
        errors: {
          company_email: ['Company email is already registered.'],
        },
      });
    }

    savePendingRegistration(normalizedUserEmail, {
      name: value.name.trim(),
      email: normalizedUserEmail,
      password: value.password,
      company_name: value.company_name.trim(),
      company_email: normalizedCompanyEmail,
      company_phone: normalizeOptional(value.company_phone),
      company_website: normalizeOptional(value.company_website),
      company_industry: normalizeOptional(value.company_industry),
      company_address: normalizeOptional(value.company_address),
    });

    const otpResult = await issueEmailVerificationOtp({
      email: normalizedUserEmail,
      name: value.name.trim(),
    });

    return res.status(201).json({
      success: true,
      message: 'Account created. Verify your email to sign in.',
      data: {
        requiresEmailVerification: true,
        email: normalizedUserEmail,
      },
      ...(otpResult.debugOtp ? { debug_otp: otpResult.debugOtp } : {}),
    });
  } catch (err) {
    console.error('register error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to create account.',
    });
  }
}

async function verifyEmail(req, res) {
  const { error, value } = verifyEmailSchema.validate(req.body);
  if (error) {
    return validationFailed(res, error);
  }

  if (!consumeEmailVerificationOtp(value.email, value.otp)) {
    return res.status(422).json({
      success: false,
      message: 'Invalid or expired verification code.',
      errors: {
        otp: ['Invalid or expired verification code.'],
      },
    });
  }

  try {
    const pendingRegistration = consumePendingRegistration(value.email);
    if (pendingRegistration) {
      const authUser = await createVerifiedAccount(pendingRegistration);
      return res.json(buildAuthPayload(authUser));
    }

    const [existingRows] = await db.query(
      `SELECT u.id, u.company_id, u.name, u.email, u.role, u.email_verified_at,
              c.name AS company_name, c.slug AS company_slug
       FROM users u
       JOIN companies c ON c.id = u.company_id
       WHERE u.email = ? AND u.deleted_at IS NULL AND c.deleted_at IS NULL
       LIMIT 1`,
      [value.email]
    );

    if (!existingRows.length) {
      return res.status(404).json({
        success: false,
        message: 'Verification expired. Please create your account again.',
      });
    }

    const [result] = await db.query(
      `UPDATE users
       SET email_verified_at = NOW(), updated_at = NOW()
       WHERE email = ? AND deleted_at IS NULL`,
      [value.email]
    );

    if (!result.affectedRows) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    return res.json(buildAuthPayload(existingRows[0]));
  } catch (err) {
    console.error('verifyEmail error:', err);
    return res.status(500).json({
      success: false,
      message: 'Could not verify email.',
    });
  }
}

async function resendVerification(req, res) {
  const { error, value } = resendVerificationSchema.validate(req.body);
  if (error) {
    return validationFailed(res, error);
  }

  try {
    const pendingRegistration = getPendingRegistration(value.email);
    if (pendingRegistration) {
      const otpResult = await issueEmailVerificationOtp({
        email: pendingRegistration.email,
        name: pendingRegistration.name,
      });

      return res.json({
        success: true,
        message: 'Verification code sent.',
        ...(otpResult.debugOtp ? { debug_otp: otpResult.debugOtp } : {}),
      });
    }

    const [rows] = await db.query(
      `SELECT id, name, email, email_verified_at
       FROM users
       WHERE email = ? AND deleted_at IS NULL
       LIMIT 1`,
      [value.email]
    );

    if (!rows.length) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    if (rows[0].email_verified_at) {
      return res.json({
        success: true,
        message: 'Email is already verified. You can sign in now.',
      });
    }

    const otpResult = await issueEmailVerificationOtp({
      email: rows[0].email,
      name: rows[0].name,
    });

    return res.json({
      success: true,
      message: 'Verification code sent.',
      ...(otpResult.debugOtp ? { debug_otp: otpResult.debugOtp } : {}),
    });
  } catch (err) {
    console.error('resendVerification error:', err);
    return res.status(500).json({
      success: false,
      message: 'Could not resend verification code.',
    });
  }
}

async function forgotPassword(req, res) {
  const { error, value } = forgotPasswordSchema.validate(req.body);
  if (error) {
    return validationFailed(res, error);
  }

  try {
    const [rows] = await db.query(
      'SELECT id, name, email FROM users WHERE email = ? AND deleted_at IS NULL LIMIT 1',
      [value.email.toLowerCase()]
    );

    if (!rows.length) {
      return res.status(404).json({
        success: false,
        message: 'No account was found for that email address.',
      });
    }

    const otp = createOtp();
    savePasswordResetOtp(rows[0].email, otp);
    const sent = await withTimeout(
      sendPasswordResetOtp({
        to: rows[0].email,
        name: rows[0].name || 'there',
        otp,
      }),
      Number(process.env.MAIL_TIMEOUT_MS || 5000),
      false
    );

    return res.json({
      success: true,
      message: sent
        ? 'Password reset OTP sent to your email.'
        : 'Email could not be sent. Use the temporary OTP shown here.',
      ...(sent ? {} : { debug_otp: otp }),
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

async function createVerifiedAccount(registration) {
  const conn = await db.getConnection();

  try {
    await conn.beginTransaction();

    const [existingUsers] = await conn.query(
      'SELECT id FROM users WHERE email = ? AND deleted_at IS NULL LIMIT 1',
      [registration.email]
    );
    if (existingUsers.length) {
      throw new Error('Email is already registered.');
    }

    const [existingCompanies] = await conn.query(
      'SELECT id FROM companies WHERE email = ? AND deleted_at IS NULL LIMIT 1',
      [registration.company_email]
    );
    if (existingCompanies.length) {
      throw new Error('Company email is already registered.');
    }

    const slug = await uniqueCompanySlug(conn, registration.company_name);

    const [companyResult] = await conn.query(
      `INSERT INTO companies (name, slug, email, phone, website, industry, address)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        registration.company_name,
        slug,
        registration.company_email,
        registration.company_phone,
        registration.company_website,
        registration.company_industry,
        registration.company_address,
      ]
    );

    const companyId = companyResult.insertId;

    const [userResult] = await conn.query(
      `INSERT INTO users (company_id, name, email, password_hash, role, email_verified_at)
       VALUES (?, ?, ?, ?, 'admin', NOW())`,
      [
        companyId,
        registration.name,
        registration.email,
        hashPassword(registration.password),
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
        `Created company account for ${registration.company_name}.`,
      ]
    );

    await conn.commit();

    return {
      id: userResult.insertId,
      company_id: companyId,
      name: registration.name,
      email: registration.email,
      role: 'admin',
      company_name: registration.company_name,
      company_slug: slug,
      avatar_url: null,
    };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

async function deleteUnverifiedAccount(user) {
  await db.query(
    'DELETE FROM companies WHERE id = ? AND NOT EXISTS (SELECT 1 FROM users WHERE company_id = ? AND email_verified_at IS NOT NULL AND deleted_at IS NULL)',
    [user.company_id, user.company_id]
  );
}

async function issueEmailVerificationOtp({ email, name }) {
  const otp = createOtp();
  saveEmailVerificationOtp(email, otp);
  const sent = await withTimeout(
    sendEmailVerificationOtp({ to: email, name, otp }),
    Number(process.env.MAIL_TIMEOUT_MS || 5000),
    false
  );
  return { sent, debugOtp: sent ? null : otp };
}

function withTimeout(promise, timeoutMs, fallbackValue) {
  return Promise.race([
    promise,
    new Promise((resolve) => {
      setTimeout(() => resolve(fallbackValue), timeoutMs);
    }),
  ]);
}

function createOtp() {
  return `${Math.floor(100000 + Math.random() * 900000)}`;
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
  verifyEmail,
  resendVerification,
  forgotPassword,
  resetPassword,
  refreshToken,
  logout,
};
