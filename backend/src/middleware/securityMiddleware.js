const db   = require('../config/database');
const path = require('path');

// ── Task 29: RBAC middleware (role-based route guards) ────────────────────────

/**
 * Blocks recruiter role from mutating sensitive resources.
 * Used on routes where recruiter should be read-only.
 */
const requireAdminOrSelf = (req, res, next) => {
  const targetId = parseInt(req.params.id);
  if (req.user.role === 'admin' || req.user.userId === targetId) {
    return next();
  }
  return res.status(403).json({
    success: false,
    message: 'Forbidden. You do not have permission for this action.',
  });
};

/**
 * Dynamically restrict recruiter write operations.
 * Recruiters can: read candidates, read jobs, upload CVs, move pipeline stages.
 * Recruiters cannot: manage users, change company settings, delete jobs/candidates.
 */
const recruiterReadOnly = (req, res, next) => {
  if (req.user.role === 'recruiter' && ['PUT', 'DELETE', 'PATCH'].includes(req.method)) {
    return res.status(403).json({
      success: false,
      message: 'Recruiters have read-only access to this resource.',
    });
  }
  next();
};

// ── Task 31: Multi-tenant isolation middleware ────────────────────────────────

/**
 * Verifies the requested resource belongs to the authenticated user's company.
 * Attach this to any route that accesses a resource by ID.
 *
 * Usage: router.get('/:id', authenticate, tenantIsolation('candidates'), handler)
 */
const tenantIsolation = (table, idParam = 'id') => async (req, res, next) => {
  const resourceId = parseInt(req.params[idParam]);
  if (!resourceId) return next(); // no param, skip check

  try {
    const [rows] = await db.query(
      `SELECT company_id FROM ${table} WHERE id = ? LIMIT 1`,
      [resourceId]
    );

    if (!rows.length) {
      return res.status(404).json({ success: false, message: 'Resource not found.' });
    }

    if (rows[0].company_id !== req.user.companyId) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. This resource belongs to a different organization.',
      });
    }

    next();
  } catch (err) {
    console.error('tenantIsolation error:', err);
    return res.status(500).json({ success: false, message: 'Authorization check failed.' });
  }
};

// ── Task 30: File upload security validator ───────────────────────────────────
const ALLOWED_MIME_TYPES = new Set([
  'application/pdf',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
]);
const ALLOWED_EXTENSIONS = new Set(['.pdf', '.doc', '.docx']);
const MAX_FILE_SIZE_BYTES = 5 * 1024 * 1024; // 5MB

/**
 * Post-multer file validation.
 * Re-validates MIME type, extension, and size.
 * Provides a second layer of protection beyond multer's fileFilter.
 */
const validateUploadedFile = (req, res, next) => {
  if (!req.file) return next();

  const ext     = path.extname(req.file.originalname).toLowerCase();
  const mime    = req.file.mimetype;
  const size    = req.file.size;

  const errors = [];

  if (!ALLOWED_MIME_TYPES.has(mime)) {
    errors.push(`Invalid file type: ${mime}. Only PDF, DOC, DOCX allowed.`);
  }
  if (!ALLOWED_EXTENSIONS.has(ext)) {
    errors.push(`Invalid extension: ${ext}. Only .pdf, .doc, .docx allowed.`);
  }
  if (size > MAX_FILE_SIZE_BYTES) {
    errors.push(`File too large: ${(size / 1024 / 1024).toFixed(2)}MB. Max 5MB.`);
  }

  if (errors.length > 0) {
    // Clean up uploaded file
    const fs = require('fs');
    if (req.file.path && fs.existsSync(req.file.path)) {
      fs.unlinkSync(req.file.path);
    }
    return res.status(400).json({ success: false, message: errors[0] });
  }

  next();
};

// ── Task 32: Audit log middleware ─────────────────────────────────────────────

/**
 * Automatically logs every mutating API request to audit_logs.
 * Attach as a global middleware or per-route as needed.
 */
const auditLog = async (req, res, next) => {
  // Only log mutations
  if (!['POST', 'PUT', 'PATCH', 'DELETE'].includes(req.method)) return next();
  if (!req.user) return next(); // skip unauthenticated requests

  // Capture response to log status
  const originalJson = res.json.bind(res);
  res.json = function (body) {
    // Fire-and-forget audit write
    _writeAuditLog({
      companyId:  req.user.companyId,
      userId:     req.user.userId,
      method:     req.method,
      path:       req.originalUrl,
      statusCode: res.statusCode,
      ipAddress:  req.ip || req.connection?.remoteAddress,
      userAgent:  req.headers['user-agent'],
      body:       _sanitizeBody(req.body),
    }).catch(err => console.error('Audit log write error:', err));

    return originalJson(body);
  };

  next();
};

async function _writeAuditLog({ companyId, userId, method, path, statusCode, ipAddress, userAgent, body }) {
  try {
    const action = `${method.toLowerCase()}.${path.split('?')[0]}`;
    const entityType = path.split('/').filter(Boolean)[1] || 'system';
    const description = `${method} ${path} returned ${statusCode}`;

    await db.query(
      `INSERT INTO audit_logs
        (company_id, user_id, action, entity_type, description, method, endpoint, status_code, ip_address, user_agent, request_body)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [companyId, userId, action, entityType, description, method, path, statusCode,
       ipAddress, userAgent?.substring(0, 255) || null,
       body ? JSON.stringify(body).substring(0, 1000) : null]
    );
  } catch (_) { /* never break the request */ }
}

function _sanitizeBody(body) {
  if (!body || typeof body !== 'object') return null;
  const safe = { ...body };
  ['password', 'password_confirmation', 'token', 'otp'].forEach(k => {
    if (safe[k]) safe[k] = '[REDACTED]';
  });
  return safe;
}

// ── Security headers middleware ───────────────────────────────────────────────
const securityHeaders = (req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  next();
};

module.exports = {
  requireAdminOrSelf,
  recruiterReadOnly,
  tenantIsolation,
  validateUploadedFile,
  auditLog,
  securityHeaders,
};
