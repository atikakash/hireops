const express = require('express');
const { authenticate } = require('../middleware/authMiddleware');
const { getActivityLog } = require('../controllers/activityController');

const router = express.Router();

router.use(authenticate);

router.get('/', getActivityLog);

module.exports = router;
