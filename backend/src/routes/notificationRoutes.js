const express = require('express');
const router  = express.Router();
const { authenticate, requireAdmin } = require('../middleware/authMiddleware');
const {
  listNotifications,
  getSettings,
  updateSettings,
  markRead,
  markAllRead,
} = require('../controllers/notificationController');

router.use(authenticate);

router.get('/', listNotifications);
router.put('/read-all', markAllRead);
router.put('/:id/read', markRead);

// Task 20-21: Notification settings
router.get('/settings',  getSettings);                    // any authenticated user
router.put('/settings',  requireAdmin, updateSettings);   // admin only

module.exports = router;
