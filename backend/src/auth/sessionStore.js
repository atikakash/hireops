const crypto = require('crypto');

const accessSessions = new Map();
const refreshSessions = new Map();
const passwordResetOtps = new Map();
const emailVerificationOtps = new Map();

function issueSession(user) {
  const session = {
    userId: user.id,
    companyId: user.company_id,
    role: user.role,
    email: user.email,
    name: user.name,
    avatarUrl: user.avatar_url || null,
  };

  const accessToken = createToken('access', user.id);
  const refreshToken = createToken('refresh', user.id);

  const accessRecord = { ...session, accessToken, refreshToken };
  const refreshRecord = { ...session, accessToken, refreshToken };

  accessSessions.set(accessToken, accessRecord);
  refreshSessions.set(refreshToken, refreshRecord);

  return { accessToken, refreshToken };
}

function getAccessSession(token) {
  return accessSessions.get(token) || null;
}

function rotateRefreshToken(refreshToken) {
  const existing = refreshSessions.get(refreshToken);
  if (!existing) {
    return null;
  }

  revokeSessionByRefresh(refreshToken);
  return issueSession({
    id: existing.userId,
    company_id: existing.companyId,
    role: existing.role,
    email: existing.email,
    name: existing.name,
    avatar_url: existing.avatarUrl,
  });
}

function revokeAccessToken(token) {
  const session = accessSessions.get(token);
  if (!session) {
    return;
  }

  accessSessions.delete(token);
  refreshSessions.delete(session.refreshToken);
}

function revokeSessionByRefresh(refreshToken) {
  const session = refreshSessions.get(refreshToken);
  if (!session) {
    return;
  }

  refreshSessions.delete(refreshToken);
  accessSessions.delete(session.accessToken);
}

function savePasswordResetOtp(email, otp) {
  saveOtp(passwordResetOtps, email, otp);
}

function consumePasswordResetOtp(email, otp) {
  return consumeOtp(passwordResetOtps, email, otp);
}

function saveEmailVerificationOtp(email, otp) {
  saveOtp(emailVerificationOtps, email, otp);
}

function consumeEmailVerificationOtp(email, otp) {
  return consumeOtp(emailVerificationOtps, email, otp);
}

function saveOtp(store, email, otp) {
  store.set(email.toLowerCase(), {
    otp,
    expiresAt: Date.now() + 10 * 60 * 1000,
  });
}

function consumeOtp(store, email, otp) {
  const key = email.toLowerCase();
  const record = store.get(key);
  if (!record) {
    return false;
  }

  store.delete(key);
  return record.otp === otp && record.expiresAt > Date.now();
}

function createToken(prefix, userId) {
  return `${prefix}-${userId}-${crypto.randomBytes(24).toString('hex')}`;
}

module.exports = {
  issueSession,
  getAccessSession,
  rotateRefreshToken,
  revokeAccessToken,
  revokeSessionByRefresh,
  savePasswordResetOtp,
  consumePasswordResetOtp,
  saveEmailVerificationOtp,
  consumeEmailVerificationOtp,
};
