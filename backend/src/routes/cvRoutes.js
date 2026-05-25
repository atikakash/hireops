const express = require('express');
const multer = require('multer');
const { authenticate } = require('../middleware/authMiddleware');
const { validateUploadedFile } = require('../middleware/securityMiddleware');
const { uploadCv, getDownloadUrl } = require('../controllers/cvController');

const router = express.Router();
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 },
});

router.use(authenticate);

router.post('/upload', upload.single('file'), validateUploadedFile, uploadCv);
router.get('/:id/download', getDownloadUrl);

module.exports = router;
