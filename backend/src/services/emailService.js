const nodemailer = require('nodemailer');
require('dotenv').config();

// ── Transporter ───────────────────────────────────────────────────────────────
const transporter = nodemailer.createTransport({
  host:   process.env.MAIL_HOST || 'smtp-relay.brevo.com',
  port:   parseInt(process.env.MAIL_PORT || '587', 10),
  secure: process.env.MAIL_SECURE === 'true',
  connectionTimeout: Number(process.env.MAIL_TIMEOUT_MS || 5000),
  greetingTimeout: Number(process.env.MAIL_TIMEOUT_MS || 5000),
  socketTimeout: Number(process.env.MAIL_TIMEOUT_MS || 5000),
  auth: {
    user: process.env.MAIL_USER,
    pass: process.env.MAIL_PASS,
  },
});

async function verifyEmailTransport() {
  const config = {
    host: process.env.MAIL_HOST || 'smtp-relay.brevo.com',
    port: parseInt(process.env.MAIL_PORT || '587', 10),
    secure: process.env.MAIL_SECURE === 'true',
    hasUser: Boolean(process.env.MAIL_USER),
    hasPassword: Boolean(process.env.MAIL_PASS),
    from: process.env.MAIL_FROM || null,
  };

  if (!config.hasUser || !config.hasPassword) {
    return {
      ok: false,
      config,
      code: 'MAIL_AUTH_MISSING',
      message: 'MAIL_USER and MAIL_PASS must be set in Render.',
    };
  }

  try {
    await transporter.verify();
    return { ok: true, config };
  } catch (err) {
    return {
      ok: false,
      config,
      code: err.code || err.responseCode || null,
      message: err.message || 'SMTP verification failed.',
    };
  }
}

// ── Base HTML template wrapper ─────────────────────────────────────────────────
function baseTemplate(title, bodyHtml) {
  return `
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${title}</title>
  </head>
  <body style="margin:0;padding:0;background:#F8F9FA;font-family:'Segoe UI',Arial,sans-serif;">
    <table width="100%" cellpadding="0" cellspacing="0" style="background:#F8F9FA;padding:32px 0;">
      <tr><td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,0.08);">

          <!-- Header -->
          <tr>
            <td style="background:#1A73E8;padding:28px 32px;">
              <h1 style="margin:0;color:#fff;font-size:22px;font-weight:700;letter-spacing:-0.5px;">
                📋 HireOps
              </h1>
              <p style="margin:4px 0 0;color:rgba(255,255,255,0.75);font-size:13px;">
                CV & Hiring Management
              </p>
            </td>
          </tr>

          <!-- Body -->
          <tr>
            <td style="padding:32px;">
              ${bodyHtml}
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="background:#F8F9FA;padding:20px 32px;border-top:1px solid #EEEEEE;">
              <p style="margin:0;color:#9E9E9E;font-size:12px;text-align:center;">
                © ${new Date().getFullYear()} HireOps · You're receiving this because you're part of a HireOps team.
              </p>
            </td>
          </tr>

        </table>
      </td></tr>
    </table>
  </body>
  </html>`;
}

// ── Email Templates ───────────────────────────────────────────────────────────

/**
 * Task 20: Email on new CV upload
 */
function cvUploadedTemplate({ companyName, candidateName, fileName, uploadedBy }) {
  const body = `
    <h2 style="margin:0 0 8px;color:#1A1A1A;font-size:20px;">New CV Received 📄</h2>
    <p style="margin:0 0 24px;color:#666;font-size:14px;">
      A new candidate CV has been uploaded to <strong>${companyName}</strong>.
    </p>

    <table width="100%" cellpadding="0" cellspacing="0"
      style="background:#F0F6FF;border-radius:12px;padding:20px;margin-bottom:24px;">
      <tr>
        <td>
          <p style="margin:0 0 8px;color:#1A73E8;font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.5px;">
            Candidate Details
          </p>
          <p style="margin:0 0 4px;color:#1A1A1A;font-size:16px;font-weight:700;">${candidateName}</p>
          <p style="margin:0 0 4px;color:#666;font-size:13px;">📎 File: ${fileName}</p>
          <p style="margin:0;color:#666;font-size:13px;">👤 Uploaded by: ${uploadedBy}</p>
        </td>
      </tr>
    </table>

    <p style="margin:0 0 24px;color:#666;font-size:14px;">
      Log in to HireOps to review the CV and move the candidate through your hiring pipeline.
    </p>

    <a href="#" style="display:inline-block;background:#1A73E8;color:#fff;text-decoration:none;
      padding:12px 28px;border-radius:8px;font-size:14px;font-weight:600;">
      View Candidate →
    </a>`;
  return baseTemplate('New CV Uploaded', body);
}

/**
 * Task 21: Email on pipeline stage change
 */
function stageMovedTemplate({ companyName, candidateName, jobTitle, fromStage, toStage, movedBy, stageColor }) {
  const body = `
    <h2 style="margin:0 0 8px;color:#1A1A1A;font-size:20px;">Candidate Stage Updated 🔀</h2>
    <p style="margin:0 0 24px;color:#666;font-size:14px;">
      A candidate has been moved to a new stage in <strong>${companyName}</strong>.
    </p>

    <table width="100%" cellpadding="0" cellspacing="0"
      style="background:#F8F9FA;border-radius:12px;padding:20px;margin-bottom:20px;">
      <tr>
        <td>
          <p style="margin:0 0 4px;color:#1A1A1A;font-size:16px;font-weight:700;">${candidateName}</p>
          <p style="margin:0 0 12px;color:#666;font-size:13px;">💼 Job: ${jobTitle}</p>
          <table cellpadding="0" cellspacing="0">
            <tr>
              <td style="background:#EEE;color:#555;padding:6px 14px;border-radius:6px;font-size:13px;font-weight:500;">
                ${fromStage || 'N/A'}
              </td>
              <td style="padding:0 12px;color:#888;font-size:18px;">→</td>
              <td style="background:${stageColor || '#1A73E8'};color:#fff;padding:6px 14px;border-radius:6px;font-size:13px;font-weight:600;">
                ${toStage}
              </td>
            </tr>
          </table>
          <p style="margin:12px 0 0;color:#666;font-size:13px;">👤 Moved by: ${movedBy}</p>
        </td>
      </tr>
    </table>

    <a href="#" style="display:inline-block;background:#1A73E8;color:#fff;text-decoration:none;
      padding:12px 28px;border-radius:8px;font-size:14px;font-weight:600;">
      View Pipeline →
    </a>`;
  return baseTemplate('Candidate Stage Updated', body);
}

function emailVerificationTemplate({ name, otp }) {
  const body = `
    <h2 style="margin:0 0 8px;color:#1A1A1A;font-size:20px;">Verify your email</h2>
    <p style="margin:0 0 24px;color:#666;font-size:14px;">
      Hi <strong>${name}</strong>, use this 6-digit code to activate your HireOps account.
    </p>

    <div style="background:#F0F6FF;border-radius:12px;padding:20px;text-align:center;margin-bottom:24px;">
      <p style="margin:0 0 8px;color:#1A73E8;font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.5px;">
        Verification code
      </p>
      <p style="margin:0;color:#1A1A1A;font-size:32px;font-weight:700;letter-spacing:6px;">
        ${otp}
      </p>
    </div>

    <p style="margin:0;color:#666;font-size:14px;">
      This code expires in 10 minutes. If you did not create a HireOps account, you can ignore this email.
    </p>`;

  return baseTemplate('Verify your HireOps email', body);
}

// ── Send helpers ──────────────────────────────────────────────────────────────

/**
 * Send an email. Never throws — logs errors silently.
 */
async function sendMail({ to, subject, html }) {
  if (!process.env.MAIL_USER || !process.env.MAIL_PASS) {
    console.warn(`Email skipped for ${to}: MAIL_USER/MAIL_PASS not configured`);
    return false;
  }

  try {
    const info = await transporter.sendMail({
      from:    `"HireOps" <${process.env.MAIL_FROM || 'noreply@hireops.app'}>`,
      to, subject, html,
    });
    console.log(`📧 Email sent to ${to}: ${info.messageId}`);
    return true;
  } catch (err) {
    console.error(`📧 Email failed to ${to}:`, err.message);
    return false;
  }
}

function passwordResetTemplate({ name, otp }) {
  const body = `
    <h2 style="margin:0 0 8px;color:#1A1A1A;font-size:20px;">Reset your password</h2>
    <p style="margin:0 0 24px;color:#666;font-size:14px;">
      Hi <strong>${name}</strong>, use this 6-digit code to reset your HireOps password.
    </p>

    <div style="background:#FFF7E6;border-radius:12px;padding:20px;text-align:center;margin-bottom:24px;">
      <p style="margin:0 0 8px;color:#C47A00;font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.5px;">
        Password reset code
      </p>
      <p style="margin:0;color:#1A1A1A;font-size:32px;font-weight:700;letter-spacing:6px;">
        ${otp}
      </p>
    </div>

    <p style="margin:0;color:#666;font-size:14px;">
      This code expires in 10 minutes. If you did not request a password reset, you can ignore this email.
    </p>`;

  return baseTemplate('Reset your HireOps password', body);
}

async function sendEmailVerificationOtp({ to, name, otp }) {
  return sendMail({
    to,
    subject: 'Verify your HireOps email',
    html: emailVerificationTemplate({ name, otp }),
  });
}

async function sendPasswordResetOtp({ to, name, otp }) {
  return sendMail({
    to,
    subject: 'Reset your HireOps password',
    html: passwordResetTemplate({ name, otp }),
  });
}

/**
 * Task 20: Notify all admin users when a CV is uploaded.
 */
async function notifyCVUploaded({ db, companyId, candidateName, fileName, uploadedByName }) {
  if (!(await notificationEnabled(db, companyId, 'notify_cv_upload'))) {
    return;
  }

  // Fetch company name + all admin emails
  const [company] = await db.query(
    'SELECT name FROM companies WHERE id = ? LIMIT 1', [companyId]
  );
  const [admins] = await db.query(
    `SELECT email FROM users
     WHERE company_id = ? AND role = 'admin' AND is_active = 1 AND deleted_at IS NULL`,
    [companyId]
  );

  if (!company.length || !admins.length) return;

  const html = cvUploadedTemplate({
    companyName:  company[0].name,
    candidateName,
    fileName,
    uploadedBy:   uploadedByName,
  });

  for (const admin of admins) {
    await sendMail({
      to:      admin.email,
      subject: `New CV: ${candidateName} — ${company[0].name}`,
      html,
    });
  }
}

/**
 * Task 21: Notify all admin users when a candidate changes stage.
 */
async function notifyStageMoved({ db, companyId, candidateName, jobTitle, fromStage, toStage, stageColor, movedByName }) {
  if (!(await notificationEnabled(db, companyId, 'notify_stage_change'))) {
    return;
  }

  const [company] = await db.query(
    'SELECT name FROM companies WHERE id = ? LIMIT 1', [companyId]
  );
  const [admins] = await db.query(
    `SELECT email FROM users
     WHERE company_id = ? AND role = 'admin' AND is_active = 1 AND deleted_at IS NULL`,
    [companyId]
  );

  if (!company.length || !admins.length) return;

  const html = stageMovedTemplate({
    companyName:  company[0].name,
    candidateName,
    jobTitle,
    fromStage,
    toStage,
    stageColor,
    movedBy:      movedByName,
  });

  for (const admin of admins) {
    await sendMail({
      to:      admin.email,
      subject: `${candidateName} moved to ${toStage} — ${company[0].name}`,
      html,
    });
  }
}

async function notificationEnabled(db, companyId, column) {
  const [rows] = await db.query(
    `SELECT ${column}, email_notifications
     FROM notification_settings
     WHERE company_id = ?
     LIMIT 1`,
    [companyId]
  );

  if (!rows.length) {
    return true;
  }

  return rows[0].email_notifications !== 0 && rows[0][column] !== 0;
}

module.exports = {
  sendMail,
  sendEmailVerificationOtp,
  sendPasswordResetOtp,
  verifyEmailTransport,
  notifyCVUploaded,
  notifyStageMoved,
};
