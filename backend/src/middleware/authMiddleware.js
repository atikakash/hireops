const { getAccessSession } = require('../auth/sessionStore');

function parseDevUser(req) {
  if (req.user) {
    return req.user;
  }

  const rawMockUser = req.headers['x-mock-user'];
  if (typeof rawMockUser === 'string' && rawMockUser.trim() !== '') {
    try {
      return JSON.parse(rawMockUser);
    } catch (_err) {
      return null;
    }
  }

  const companyId = Number(req.headers['x-company-id']);
  const userId = Number(req.headers['x-user-id']);
  const role = req.headers['x-user-role'];

  if (!companyId || !userId) {
    return null;
  }

  return {
    companyId,
    userId,
    role: typeof role === 'string' && role ? role : 'admin',
  };
}

function authenticate(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  const session = token ? getAccessSession(token) : null;

  if (session) {
    req.token = token;
    req.user = {
      userId: session.userId,
      companyId: session.companyId,
      role: session.role,
      email: session.email,
      name: session.name,
    };
    return next();
  }

  const user = parseDevUser(req);
  if (!user) {
    return res.status(401).json({
      success: false,
      message: 'Authentication required.',
    });
  }

  req.user = user;
  next();
}

function requireAdmin(req, res, next) {
  if (!req.user || req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'Admin access required.',
    });
  }

  next();
}

module.exports = {
  authenticate,
  requireAdmin,
};
