const express = require('express');
const router = express.Router();
const { sendOtp, checkEmail, register, verifyOtp, login } = require('../controllers/auth.controller');
const { upload } = require('../config/cloudinary');

router.post('/check-email', checkEmail);
router.post('/send-otp', sendOtp);
router.post('/verify-otp', verifyOtp);
router.post('/register', upload.single('avatar'), register);
router.post('/login', login);

module.exports = router;
