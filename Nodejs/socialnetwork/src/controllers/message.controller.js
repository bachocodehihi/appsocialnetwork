// const { Conversation, Message } = require('../models/message.model');
// const Account = require('../models/account.model');

// const createConversation = async (req, res) => {
//     try {
//         const { receiverId, isGroup, name, members, avatar } = req.body;

//         if (isGroup) {
//             const groupMembers = members ? [...members, req.userId] : [req.userId];
//             const newConv = new Conversation({
//                 isGroup: true, name, avatar, members: groupMembers, admin: req.userId
//             });
//             await newConv.save();
//             return res.status(201).json(newConv);
//         } else {
//             const existingConv = await Conversation.findOne({
//                 isGroup: false,
//                 members: { $all: [req.userId, receiverId] }
//             });
//             if (existingConv) return res.status(200).json(existingConv);

//             const newConv = new Conversation({ isGroup: false, members: [req.userId, receiverId] });
//             await newConv.save();
//             return res.status(201).json(newConv);
//         }
//     } catch (error) {
//         res.status(500).json({ error: error.message });
//     }
// };

// const sendMessage = async (req, res) => {
//     try {
//         const { conversationId } = req.params;
//         const { content } = req.body;
//         if (!content?.trim()) return res.status(400).json({ message: 'Content required' });

//         const newMsg = new Message({ conversationId, sender: req.userId, content: content.trim() });
//         await newMsg.save();
//         await Conversation.findByIdAndUpdate(conversationId, { lastMessage: newMsg._id });
//         const populated = await newMsg.populate('sender', 'username avatar');
        
//         res.status(201).json(populated);
//     } catch (error) {
//         res.status(500).json({ error: error.message });
//     }
// };

// const getConversations = async (req, res) => {
//     try {
//         const conversations = await Conversation.find({ members: req.userId })
//             .populate('members', 'username avatar email')
//             .populate('lastMessage');
//         res.status(200).json(conversations);
//     } catch (error) {
//         res.status(500).json({ error: error.message });
//     }
// };

// const getMessages = async (req, res) => {
//     try {
//         const { conversationId } = req.params;
//         const messages = await Message.find({ conversationId })
//             .populate('sender', 'username avatar email');
//         res.status(200).json(messages);
//     } catch (error) {
//         res.status(500).json({ error: error.message });
//     }
// };

// module.exports = { createConversation, getConversations, getMessages, sendMessage };












const { Conversation, Message } = require('../models/message.model');
const Group = require('../models/group.model');
const Account = require('../models/account.model');

const createConversation = async (req, res) => {
    try {
        const { receiverId, isGroup, name, members, avatar, groupId } = req.body;
        const adminId = req.userId;

        if (isGroup) {
            if (groupId) {
                const existingConv = await Conversation.findOne({
                    isGroup: true,
                    'meta.groupId': groupId
                }).populate('members', 'username avatar email');
                
                if (existingConv) {
                    return res.status(200).json(existingConv);
                }

                const group = await Group.findById(groupId);
                if (!group) {
                    return res.status(404).json({ message: 'Group not found' });
                }

                if (!group.members.some(m => m.toString() === adminId)) {
                    return res.status(403).json({ 
                        message: 'Bạn không phải thành viên nhóm này' 
                    });
                }

                const newConv = new Conversation({
                    isGroup: true,
                    name: group.name,
                    avatar: group.avatar || avatar,
                    members: group.members,
                    admin: group.admin,
                    meta: { groupId: groupId }
                });
                
                await newConv.save();
                await newConv.populate('members', 'username avatar email');
                
                return res.status(201).json({
                    message: 'Tạo cuộc trò chuyện thành công',
                    conversation: newConv
                });
            }
            
            const groupMembers = members 
                ? [...new Set([...members.map(m => m.toString()), adminId])] 
                : [adminId];
            
            if (groupMembers.length < 2) {
                return res.status(400).json({ 
                    message: 'Cuộc trò chuyện nhóm cần ít nhất 2 thành viên' 
                });
            }

            const existingConv = await Conversation.findOne({
                isGroup: true,
                name: name,
                members: { $all: groupMembers, $size: groupMembers.length }
            }).populate('members', 'username avatar email');
            
            if (existingConv) {
                return res.status(200).json(existingConv);
            }

            const newConv = new Conversation({
                isGroup: true, 
                name, 
                avatar, 
                members: groupMembers, 
                admin: adminId
            });
            
            await newConv.save();
            await newConv.populate('members', 'username avatar email');
            
            return res.status(201).json({
                message: 'Tạo cuộc trò chuyện thành công',
                conversation: newConv
            });
            
        } else {
            if (!receiverId) {
                return res.status(400).json({ message: 'receiverId is required' });
            }

            const existingConv = await Conversation.findOne({
                isGroup: false,
                members: { $all: [adminId, receiverId], $size: 2 }
            }).populate('members', 'username avatar email');
            
            if (existingConv) {
                return res.status(200).json(existingConv);
            }

            const newConv = new Conversation({ 
                isGroup: false, 
                members: [adminId, receiverId] 
            });
            await newConv.save();
            await newConv.populate('members', 'username avatar email');
            
            return res.status(201).json({
                message: 'Tạo cuộc trò chuyện thành công',
                conversation: newConv
            });
        }
    } catch (error) {
        console.error('Create conversation error:', error);
        res.status(500).json({ 
            message: 'Lỗi server', 
            error: error.message 
        });
    }
};

const sendMessage = async (req, res) => {
    try {
        const { conversationId } = req.params;
        const { content, type, attachments } = req.body;
        
        if (!content?.trim() && (!attachments || attachments.length === 0)) {
            return res.status(400).json({ message: 'Content or attachments required' });
        }

        // 🔐 Verify user is member of this conversation
        const conv = await Conversation.findById(conversationId);
        if (!conv) {
            return res.status(404).json({ message: 'Conversation not found' });
        }
        
        if (!conv.members.some(m => m.toString() === req.userId)) {
            return res.status(403).json({ message: 'Not authorized for this conversation' });
        }

        // Create and save message
        const newMsg = new Message({ 
            conversationId, 
            sender: req.userId, 
            content: content?.trim() || '',
            type: type || 'text',
            attachments: attachments || []
        });
        
        await newMsg.save();
        await Conversation.findByIdAndUpdate(conversationId, { 
            lastMessage: newMsg._id,
            updatedAt: new Date()
        });
        
        // Populate sender info
        const populated = await newMsg.populate('sender', 'username avatar email');
        
        // 📡 Emit via socket for realtime delivery
        try {
            const io = require('../socket').getIO();
            io.to(conversationId).emit('receive_message', populated.toObject());
        } catch (socketErr) {
            console.warn('Socket emit warning:', socketErr.message);
        }
        
        res.status(201).json(populated.toObject());
    } catch (error) {
        console.error('Send message error:', error);
        res.status(500).json({ error: error.message });
    }
};

// 📋 Get all conversations for current user
const getConversations = async (req, res) => {
    try {
        const conversations = await Conversation.find({ members: req.userId })
            .populate('members', 'username avatar email lastSeen')
            .populate({
                path: 'lastMessage',
                populate: { path: 'sender', select: 'username avatar' }
            })
            .sort({ updatedAt: -1 })
            .lean();
            
        // Add online status for members
        const onlineUsers = require('../socket').getOnlineUsers();
        const enriched = conversations.map(conv => ({
            ...conv,
            members: conv.members?.map(member => ({
                ...member,
                isOnline: onlineUsers.has(member._id?.toString())
            }))
        }));
            
        res.status(200).json(enriched);
    } catch (error) {
        console.error('Get conversations error:', error);
        res.status(500).json({ error: error.message });
    }
};

// 💬 Get messages for a conversation
const getMessages = async (req, res) => {
    try {
        const { conversationId } = req.params;
        const { limit = 50, before } = req.query;
        
        // 🔐 Verify access
        const conv = await Conversation.findById(conversationId);
        if (!conv) {
            return res.status(404).json({ message: 'Conversation not found' });
        }
        
        if (!conv.members.some(m => m.toString() === req.userId)) {
            return res.status(403).json({ message: 'Not authorized' });
        }

        // Build query for pagination
        const query = { conversationId };
        if (before) {
            query.createdAt = { $lt: new Date(before) };
        }

        const messages = await Message.find(query)
            .populate('sender', 'username avatar email')
            .populate('repliedTo', 'content sender')
            .sort({ createdAt: -1 })
            .limit(parseInt(limit))
            .lean();

        // Mark messages as read
        await Message.updateMany(
            { 
                conversationId, 
                sender: { $ne: req.userId },
                readBy: { $ne: req.userId } 
            },
            { $addToSet: { readBy: req.userId } }
        );
        
        // Return in ascending order (oldest first)
        res.status(200).json(messages.reverse());
    } catch (error) {
        console.error('Get messages error:', error);
        res.status(500).json({ error: error.message });
    }
};

// 🗑️ Delete message (soft delete or hard delete based on policy)
const deleteMessage = async (req, res) => {
    try {
        const { messageId } = req.params;
        const { forEveryone } = req.body;
        
        const msg = await Message.findById(messageId);
        if (!msg) {
            return res.status(404).json({ message: 'Message not found' });
        }

        // Only sender or conversation admin can delete
        const conv = await Conversation.findById(msg.conversationId);
        const isSender = msg.sender.toString() === req.userId;
        const isAdmin = conv?.admin?.toString() === req.userId;
        
        if (!isSender && !isAdmin) {
            return res.status(403).json({ message: 'Not authorized' });
        }

        if (forEveryone && isAdmin) {
            await Message.findByIdAndDelete(messageId);
            // Emit delete event
            try {
                const io = require('../socket').getIO();
                io.to(msg.conversationId.toString()).emit('message_deleted', {
                    messageId,
                    conversationId: msg.conversationId,
                    deletedBy: req.userId
                });
            } catch (e) { /* ignore socket errors */ }
        } else {
            // Delete for self only
            await Message.findByIdAndUpdate(messageId, {
                $pull: { readBy: req.userId }
            });
        }
        
        res.status(200).json({ message: 'Deleted successfully' });
    } catch (error) {
        console.error('Delete message error:', error);
        res.status(500).json({ error: error.message });
    }
};

// ✅ Mark messages as read
const markAsRead = async (req, res) => {
    try {
        const { conversationId } = req.params;
        
        const conv = await Conversation.findById(conversationId);
        if (!conv || !conv.members.some(m => m.toString() === req.userId)) {
            return res.status(403).json({ message: 'Not authorized' });
        }

        await Message.updateMany(
            { 
                conversationId, 
                sender: { $ne: req.userId },
                readBy: { $ne: req.userId } 
            },
            { $addToSet: { readBy: req.userId } }
        );
        
        // Emit read receipt via socket
        try {
            const io = require('../socket').getIO();
            io.to(conversationId).emit('messages_read', {
                conversationId,
                userId: req.userId,
                timestamp: new Date()
            });
        } catch (e) { /* ignore */ }
        
        res.status(200).json({ message: 'Marked as read' });
    } catch (error) {
        console.error('Mark as read error:', error);
        res.status(500).json({ error: error.message });
    }
};

module.exports = { 
    createConversation, 
    getConversations, 
    getMessages, 
    sendMessage,
    deleteMessage,
    markAsRead
};