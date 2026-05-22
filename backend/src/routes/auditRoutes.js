const express = require('express');
const router  = express.Router();
const { authenticate, requireAdmin } = require('../middleware/authMiddleware');
const { getAuditLog }                = require('../controllers/auditController');

// Task 32: Audit log - admin only
router.use(authenticate, requireAdmin);
router.get('/', getAuditLog);

module.exports = router;
