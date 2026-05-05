const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middlewares/auth.middleware');
const { 
    createGroup, 
    getGroups, 
    getGroupById,
    joinByQR, 
    addMember, 
    removeMember,
    updateGroup,
    deleteGroup 
} = require('../controllers/group.controller');

// 📋 Group CRUD
router.get('/', verifyToken, getGroups);                    // List user's groups
router.get('/:groupId', verifyToken, getGroupById);         // Get group details
router.post('/', verifyToken, createGroup);                 // Create new group
router.put('/:groupId', verifyToken, updateGroup);          // Update group info
router.delete('/:groupId', verifyToken, deleteGroup);       // Delete group

router.post('/join-qr', verifyToken, joinByQR);                          // Join via invite code
router.post('/:groupId/members', verifyToken, addMember);                // Add members
router.delete('/:groupId/members/:memberId', verifyToken, removeMember); // Remove member

module.exports = router;
