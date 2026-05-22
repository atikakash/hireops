const express = require('express');
const router  = express.Router();
const { authenticate } = require('../middleware/authMiddleware');
const {
  listJobs, createJob, getJob, updateJob, deleteJob,
  getPipeline, assignCandidate, moveCandidateStage,
  removeFromPipeline, listStages,
} = require('../controllers/jobController');

router.use(authenticate);

// Task 13: Job CRUD
router.get('/',    listJobs);
router.post('/',   createJob);
router.get('/:id', getJob);
router.put('/:id', updateJob);
router.delete('/:id', deleteJob);

// Task 14-16: Pipeline board
router.get('/:id/pipeline',                             getPipeline);
router.post('/:id/candidates',                          assignCandidate);
router.patch('/:id/candidates/:candidateId/stage',      moveCandidateStage);
router.delete('/:id/candidates/:candidateId',           removeFromPipeline);

// Pipeline stages
router.get('/pipeline/stages', listStages);

module.exports = router;
