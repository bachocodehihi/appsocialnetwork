const express = require('express');
const router = express.Router();
const { createPost, likePost, commentPost } = require('../controllers/content.controller');
const { verifyToken } = require('../middlewares/auth.middleware');
const { upload } = require('../config/cloudinary');

router.post('/', verifyToken, upload.array('images', 10), createPost);
router.put('/:id/like', verifyToken, likePost);
router.post('/:id/comment', verifyToken, commentPost);

module.exports = router;
