const express = require('express');
const { authenticate } = require('../middleware/authMiddleware');
const {
  listPipelineStages,
  moveCandidate,
  renameStage,
} = require('../controllers/pipelineController');

const router = express.Router();

router.use(authenticate);

router.get('/stages', listPipelineStages);
router.put('/stages/:id', renameStage);
router.put('/candidates/:id/move', moveCandidate);

module.exports = router;
