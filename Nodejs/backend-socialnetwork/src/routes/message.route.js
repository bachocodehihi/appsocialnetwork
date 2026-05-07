// const express = require('express');
// const router = express.Router();
// const { 
//   createConversation, 
//   getConversations, 
//   getMessages, 
//   sendMessage 
// } = require('../controllers/message.controller');
// const { verifyToken } = require('../middlewares/auth.middleware');

// router.post('/', verifyToken, createConversation);
// router.get('/', verifyToken, getConversations);
// router.get('/:conversationId/messages', verifyToken, getMessages);
// router.post('/:conversationId/send', verifyToken, sendMessage);

// module.exports = router;





const express = require('express');
const router = express.Router();
const { 
    createConversation, 
    getConversations, 
    getMessages, 
    sendMessage,
    deleteMessage,
    markAsRead
} = require('../controllers/message.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

// 📋 Conversations
router.post('/', verifyToken, createConversation);           // Create/get conversation
router.get('/', verifyToken, getConversations);              // List conversations

// 💬 Messages
router.get('/:conversationId/messages', verifyToken, getMessages);  // Get message history
router.post('/:conversationId/send', verifyToken, sendMessage);     // Send message
router.delete('/message/:messageId', verifyToken, deleteMessage);   // Delete message
router.post('/:conversationId/read', verifyToken, markAsRead);      // Mark as read

module.exports = router;