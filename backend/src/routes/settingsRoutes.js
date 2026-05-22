const express = require('express');
const router = express.Router();

const { authenticate, requireAdmin } = require('../middleware/authMiddleware');
const {
  getAllSettings,
  updateCompanySettings,
  renamePipelineStages,
  updateNotificationSettings,
} = require('../controllers/settingsController');

router.use(authenticate);

router.get('/', getAllSettings);
router.put('/company', requireAdmin, updateCompanySettings);
router.put('/stages', requireAdmin, renamePipelineStages);
router.put('/notifications', requireAdmin, updateNotificationSettings);

module.exports = router;
