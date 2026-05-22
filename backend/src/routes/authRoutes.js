const express = require('express');

const { authenticate } = require('../middleware/authMiddleware');
const {
  login,
  register,
  forgotPassword,
  resetPassword,
  refreshToken,
  logout,
} = require('../controllers/authController');

const router = express.Router();

router.post('/login', login);
router.post('/register', register);
router.post('/forgot-password', forgotPassword);
router.post('/reset-password', resetPassword);
router.post('/refresh', refreshToken);
router.post('/logout', authenticate, logout);

module.exports = router;
