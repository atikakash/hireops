const db = require('../config/database');

const DEMO_PDF_URL =
  'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

async function uploadCv(req, res) {
  try {
    const file = req.file;
    const fileName = file?.originalname || 'uploaded-cv.pdf';
    const mimeType = file?.mimetype || 'application/pdf';
    const sizeBytes = file?.size || 0;

    const [result] = await db.query(
      `INSERT INTO cvs
        (company_id, candidate_id, original_name, stored_name, file_path, mime_type, size_bytes)
       VALUES (?, NULL, ?, ?, ?, ?, ?)`,
      [
        req.user.companyId,
        fileName,
        `${Date.now()}-${fileName}`,
        DEMO_PDF_URL,
        mimeType,
        sizeBytes,
      ]
    );

    await db.query(
      `INSERT INTO activity_logs (company_id, user_id, entity_type, entity_id, action, description)
       VALUES (?, ?, 'cv', ?, 'cv.uploaded', ?)`,
      [req.user.companyId, req.user.userId, result.insertId, `Uploaded CV: ${fileName}`]
    );

    return res.status(201).json({
      success: true,
      data: {
        cv: {
          id: String(result.insertId),
          fileName,
          fileUrl: DEMO_PDF_URL,
          fileSizeBytes: sizeBytes,
          mimeType,
          candidateId: null,
          uploadedAt: new Date().toISOString(),
        },
      },
    });
  } catch (err) {
    console.error('uploadCv error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to upload CV.',
    });
  }
}

async function getDownloadUrl(req, res) {
  try {
    const [rows] = await db.query(
      `SELECT file_path
       FROM cvs
       WHERE id = ? AND company_id = ? AND deleted_at IS NULL
       LIMIT 1`,
      [req.params.id, req.user.companyId]
    );

    return res.json({
      success: true,
      data: { url: rows[0]?.file_path || DEMO_PDF_URL },
    });
  } catch (err) {
    console.error('getDownloadUrl error:', err);
    return res.status(500).json({
      success: false,
      message: 'Failed to get CV download URL.',
    });
  }
}

module.exports = {
  uploadCv,
  getDownloadUrl,
};
