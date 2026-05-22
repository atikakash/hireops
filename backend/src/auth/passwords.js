const crypto = require('crypto');

function hashPassword(password) {
  const salt = crypto.randomBytes(16).toString('hex');
  const derived = crypto.scryptSync(password, salt, 64).toString('hex');
  return `${salt}:${derived}`;
}

function verifyPassword(password, passwordHash) {
  if (!passwordHash || typeof passwordHash !== 'string') {
    return false;
  }

  const [salt, storedHash] = passwordHash.split(':');
  if (!salt || !storedHash) {
    return false;
  }

  const derived = crypto.scryptSync(password, salt, 64);
  const stored = Buffer.from(storedHash, 'hex');

  if (derived.length !== stored.length) {
    return false;
  }

  return crypto.timingSafeEqual(derived, stored);
}

module.exports = {
  hashPassword,
  verifyPassword,
};
