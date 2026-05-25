const express = require('express');
const { authenticate, requireAdmin } = require('../middleware/authMiddleware');
const { getMembers, createMember } = require('../controllers/companyController');

const router = express.Router();

router.use(authenticate);

router.get('/', getMembers);
router.post('/', requireAdmin, createMember);

module.exports = router;
