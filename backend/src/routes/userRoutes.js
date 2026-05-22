const express = require('express');
const { authenticate } = require('../middleware/authMiddleware');
const { getMembers } = require('../controllers/companyController');

const router = express.Router();

router.use(authenticate);

router.get('/', getMembers);

module.exports = router;
