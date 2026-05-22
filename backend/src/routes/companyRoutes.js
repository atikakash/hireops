const express = require('express');
const { authenticate } = require('../middleware/authMiddleware');
const {
  getCompany,
  updateCompany,
  getMembers,
} = require('../controllers/companyController');

const router = express.Router();

router.use(authenticate);

router.get('/', getCompany);
router.put('/', updateCompany);
router.get('/members', getMembers);

module.exports = router;
