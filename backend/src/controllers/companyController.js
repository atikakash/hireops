const Joi = require('joi');
const db = require('../config/database');
const { hashPassword } = require('../auth/passwords');

const companySchema = Joi.object({
  name: Joi.string().max(255).required(),
  email: Joi.string().email().max(255).required(),
  phone: Joi.string().max(20).allow('', null),
  website: Joi.string().uri().max(255).allow('', null),
  industry: Joi.string().max(100).allow('', null),
  address: Joi.string().max(500).allow('', null),
});

const memberSchema = Joi.object({
  name: Joi.string().max(255).required(),
  email: Joi.string().trim().lowercase().email().max(255).required(),
  role: Joi.string().valid('admin', 'recruiter').default('recruiter'),
  password: Joi.string().min(8).max(128).required(),
});

async function getCompany(req, res) {
  try {
    const [companies] = await db.query(
      `SELECT id, name, slug, email, phone, website, industry, logo,
              address, is_active, created_at
       FROM companies
       WHERE id = ? AND deleted_at IS NULL
       LIMIT 1`,
      [req.user.companyId]
    );
    if (!companies.length) {
      return res.status(404).json({
        success: false,
        message: 'Company not found.',
      });
    }

    const members = await loadMembers(req.user.companyId);
    return res.json({
      success: true,
      data: { company: companies[0], members },
    });
  } catch (err) {
    console.error('getCompany error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to load company profile.',
    });
  }
}

async function updateCompany(req, res) {
  const { error, value } = companySchema.validate(req.body, {
    abortEarly: false,
  });
  if (error) {
    return validationFailed(res, error);
  }

  try {
    await db.query(
      `UPDATE companies
       SET name = ?, email = ?, phone = ?, website = ?, industry = ?,
           address = ?, updated_at = NOW()
       WHERE id = ? AND deleted_at IS NULL`,
      [
        value.name.trim(),
        value.email.toLowerCase(),
        nullable(value.phone),
        nullable(value.website),
        nullable(value.industry),
        nullable(value.address),
        req.user.companyId,
      ]
    );

    return getCompany(req, res);
  } catch (err) {
    if (err && err.code === 'ER_DUP_ENTRY') {
      return res.status(422).json({
        success: false,
        message: 'Validation failed.',
        errors: { email: ['Company email is already registered.'] },
      });
    }

    console.error('updateCompany error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to update company profile.',
    });
  }
}

async function getMembers(req, res) {
  try {
    const members = await loadMembers(req.user.companyId);
    return res.json({ success: true, data: { members } });
  } catch (err) {
    console.error('getMembers error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to load team members.',
    });
  }
}

async function createMember(req, res) {
  const { error, value } = memberSchema.validate(req.body, {
    abortEarly: false,
  });
  if (error) {
    return validationFailed(res, error);
  }

  try {
    const [result] = await db.query(
      `INSERT INTO users (company_id, name, email, password_hash, role, email_verified_at)
       VALUES (?, ?, ?, ?, ?, NOW())`,
      [
        req.user.companyId,
        value.name.trim(),
        value.email.toLowerCase(),
        hashPassword(value.password),
        value.role,
      ]
    );

    await db.query(
      `INSERT INTO activity_logs (company_id, user_id, entity_type, entity_id, action, description)
       VALUES (?, ?, 'user', ?, 'team.member_created', ?)`,
      [
        req.user.companyId,
        req.user.userId,
        result.insertId,
        `Team member added: ${value.name.trim()} (${value.role})`,
      ]
    );

    const members = await loadMembers(req.user.companyId);
    const member = members.find((item) => item.id === String(result.insertId));

    return res.status(201).json({
      success: true,
      message: 'Team member created.',
      data: { member, members },
    });
  } catch (err) {
    if (err && (err.code === 'ER_DUP_ENTRY' || err.code === '23505')) {
      return res.status(422).json({
        success: false,
        message: 'Validation failed.',
        errors: { email: ['Email is already registered.'] },
      });
    }

    console.error('createMember error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to create team member.',
    });
  }
}

async function loadMembers(companyId) {
  const [rows] = await db.query(
    `SELECT id, name, email, role
     FROM users
     WHERE company_id = ? AND deleted_at IS NULL
     ORDER BY created_at ASC`,
    [companyId]
  );

  return rows.map((row) => ({
    id: String(row.id),
    name: row.name,
    email: row.email,
    role: row.role || 'member',
    avatarUrl: null,
  }));
}

function validationFailed(res, error) {
  const errors = {};
  for (const detail of error.details) {
    errors[detail.path.join('.')] = [detail.message.replace(/"/g, '')];
  }

  return res.status(422).json({
    success: false,
    message: 'Validation failed.',
    errors,
  });
}

function nullable(value) {
  if (value === undefined || value === null) {
    return null;
  }
  const normalized = String(value).trim();
  return normalized === '' ? null : normalized;
}

module.exports = {
  getCompany,
  updateCompany,
  getMembers,
  createMember,
};
