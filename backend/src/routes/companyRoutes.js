const express = require('express');
const { authenticate, requireAdmin } = require('../middleware/authMiddleware');
const {
  getCompany,
  updateCompany,
  getMembers,
  createMember,
} = require('../controllers/companyController');

const router = express.Router();

router.use(authenticate);

router.get('/', getCompany);
router.put('/', requireAdmin, updateCompany);
router.get('/members', getMembers);
router.post('/members', requireAdmin, createMember);

module.exports = router;
