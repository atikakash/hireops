const express = require('express');
const multer = require('multer');
const { authenticate } = require('../middleware/authMiddleware');
const { uploadCv, getDownloadUrl } = require('../controllers/cvController');

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

router.use(authenticate);

router.post('/upload', upload.single('file'), uploadCv);
router.get('/:id/download', getDownloadUrl);

module.exports = router;
