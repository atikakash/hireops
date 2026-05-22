const express = require('express');
const router  = express.Router();
const { authenticate }  = require('../middleware/authMiddleware');
const {
  getDashboard,
  getDashboardStats,
  getRecentActivity,
} = require('../controllers/dashboardController');

router.use(authenticate);

router.get('/stats', getDashboardStats);
router.get('/recent-activity', getRecentActivity);

// Task 22-25: Single endpoint returns everything for the dashboard
router.get('/', getDashboard);

module.exports = router;
