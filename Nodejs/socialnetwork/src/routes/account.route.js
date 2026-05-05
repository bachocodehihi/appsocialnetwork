// const express = require('express');
// const router = express.Router();
// const { getProfile, updateProfile, searchUsers, getUserById } = require('../controllers/account.controller');
// const { verifyToken } = require('../middlewares/auth.middleware');
// const { upload } = require('../config/cloudinary');

// router.get('/profile', verifyToken, getProfile);
// router.put('/profile', verifyToken, upload.single('avatar'), updateProfile);
// router.get('/search', verifyToken, searchUsers);
// router.get('/user/:id', verifyToken, getUserById);

// module.exports = router;


// routes/account.routes.js
const express = require('express');
const router = express.Router();
const { 
    getProfile, 
    updateProfile, 
    searchUsers, 
    getUserById,
    saveFcmToken,   // ✅
    removeFcmToken  // ✅
} = require('../controllers/account.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { upload } = require('../config/cloudinary');

router.get('/profile', verifyToken, getProfile);
router.put('/profile', verifyToken, upload.single('avatar'), updateProfile);
router.get('/search', verifyToken, searchUsers);
router.get('/user/:id', verifyToken, getUserById);
router.post('/fcm-token', verifyToken, saveFcmToken);
router.post('/remove-fcm-token', verifyToken, removeFcmToken);

module.exports = router;
