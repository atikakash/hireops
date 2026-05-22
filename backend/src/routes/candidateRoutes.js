const express = require('express');
const { authenticate } = require('../middleware/authMiddleware');
const {
  listCandidates,
  getCandidate,
  createCandidate,
  updateCandidate,
  deleteCandidate,
  addTag,
  removeTag,
  addNote,
  deleteNote,
  getCandidateActivity,
} = require('../controllers/candidateController');

const router = express.Router();

router.use(authenticate);

router.get('/', listCandidates);
router.post('/', createCandidate);
router.get('/:id', getCandidate);
router.put('/:id', updateCandidate);
router.delete('/:id', deleteCandidate);
router.post('/:id/tags', addTag);
router.delete('/:id/tags', removeTag);
router.post('/:id/notes', addNote);
router.delete('/:id/notes/:noteId', deleteNote);
router.get('/:id/activity', getCandidateActivity);

module.exports = router;
