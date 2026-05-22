require('dotenv').config();
const fs = require('fs');
const path = require('path');
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');

const { auditLog, securityHeaders } = require('./middleware/securityMiddleware');
const db = require('./config/database');

const app = express();
const port = process.env.PORT || 3000;
const mockMode = process.env.MOCK_MODE !== 'false';

app.set('trust proxy', 1);

app.use(securityHeaders);
app.use(helmet());
app.use(cors({ origin: '*' }));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

function createRateLimiter(options) {
  if (mockMode) {
    return (_req, _res, next) => next();
  }

  return rateLimit(options);
}

const globalLimiter = createRateLimiter({
  windowMs: 15 * 60 * 1000,
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    message: 'Too many requests. Please try again later.',
  },
});

const authLimiter = createRateLimiter({
  windowMs: 15 * 60 * 1000,
  max: 10,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    message: 'Too many login attempts. Please try again later.',
  },
});

app.use(globalLimiter);
app.use(auditLog);

app.get('/', (_req, res) => {
  res.json({
    success: true,
    message: 'HireOps API running',
    version: '1.0.1',
    mode: mockMode ? 'mock' : 'database',
  });
});

app.get('/api/health/db', async (_req, res) => {
  try {
    await db.query('SELECT 1 AS ok');
    res.json({
      success: true,
      database: 'ok',
      client: db.isPostgres ? 'postgres' : 'mysql',
    });
  } catch (err) {
    console.error('database health error:', err);
    res.status(500).json({
      success: false,
      database: 'error',
      client: db.isPostgres ? 'postgres' : 'mysql',
      code: err.code || null,
      message: err.message || 'Database connection failed.',
    });
  }
});

function mountIfPresent(routePath, relativeModulePath, middleware = []) {
  const absoluteModulePath = path.join(__dirname, relativeModulePath);
  if (!fs.existsSync(absoluteModulePath)) {
    console.warn(`[server] skipping ${routePath} because ${relativeModulePath} is missing`);
    return;
  }

  const router = require(absoluteModulePath);
  app.use(routePath, ...middleware, router);
}

if (mockMode) {
  app.use('/api', require('./mock/mockApi'));
  console.log('[server] running in mock mode without database');
} else {
  mountIfPresent('/api/auth', 'routes/authRoutes.js', [authLimiter]);
  mountIfPresent('/api/company', 'routes/companyRoutes.js');
  mountIfPresent('/api/users', 'routes/userRoutes.js');
  mountIfPresent('/api/candidates', 'routes/candidateRoutes.js');
  mountIfPresent('/api/jobs', 'routes/jobRoutes.js');
  mountIfPresent('/api/pipeline', 'routes/pipelineRoutes.js');
  mountIfPresent('/api/cv', 'routes/cvRoutes.js');
  mountIfPresent('/api/activity-log', 'routes/activityRoutes.js');
  mountIfPresent('/api/activity', 'routes/activityRoutes.js');
  mountIfPresent('/api/notifications', 'routes/notificationRoutes.js');
  mountIfPresent('/api/dashboard', 'routes/dashboardRoutes.js');
  mountIfPresent('/api/settings', 'routes/settingsRoutes.js');
  mountIfPresent('/api/audit', 'routes/auditRoutes.js');
}

app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `Route not found: ${req.method} ${req.originalUrl}`,
  });
});

app.use((err, _req, res, _next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({
    success: false,
    message: 'Internal server error.',
  });
});

app.listen(port, () => {
  console.log(`HireOps API running at http://localhost:${port}`);
});
