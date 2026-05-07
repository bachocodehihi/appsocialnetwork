
// const { Server } = require("socket.io");
// const { Message, Conversation } = require('./models/message.model');
// const Call = require('./models/call.model');
// const Account = require('./models/account.model');
// const jwt = require('jsonwebtoken');    

// let io;
// const onlineUsers = new Map();
// const activeCalls = new Map();
 
// const initSocket = (server) => {
//     io = new Server(server, {
//         cors: { origin: "*", methods: ["GET", "POST"] }
//     });
    
//     io.use((socket, next) => {
//         try {
//             const token = socket.handshake.auth.token || socket.handshake.query.token;
//             if (!token) return next(new Error("Authentication error"));
//             const decoded = jwt.verify(token, process.env.JWT_SECRET);
//             socket.userId = decoded.id || decoded._id;
//             next();
//         } catch (err) {
//             next(new Error("Authentication error"));
//         }
//     });
 
//     io.on('connection', (socket) => {
//         const userId = socket.userId;
//         console.log(`🟢 User connected: ${userId} - Socket: ${socket.id}`);
 
//         onlineUsers.set(userId, socket.id);
//         Account.findByIdAndUpdate(userId, { lastSeen: new Date() }).exec();
//         _notifyFriends(userId, 'online');
 
//         socket.on('call_initiate', async (data) => {
//             try {
//                 const { receiverId, conversationId, callType, offer } = data;
                
//                 if (activeCalls.has(userId)) {
//                     socket.emit('call_error', { message: 'Bạn đang trong cuộc gọi khác' });
//                     return;
//                 }
                
//                 const receiverSocketId = onlineUsers.get(receiverId);
//                 if (!receiverSocketId) {
//                     socket.emit('call_error', { message: 'Người dùng không online' });
//                     return;
//                 }
                
//                 if (activeCalls.has(receiverId)) {
//                     socket.emit('call_busy', { receiverId });
                    
//                     await Call.create({
//                         conversationId,
//                         caller: userId,
//                         receiver: receiverId,
//                         callType,
//                         status: 'missed',
//                         duration: 0
//                     });
//                     return;
//                 }
                
//                 const call = await Call.create({
//                     conversationId,
//                     caller: userId,
//                     receiver: receiverId,
//                     callType,
//                     status: 'ringing',
//                     offer
//                 });
                
//                 activeCalls.set(userId, { callId: call._id, conversationId, otherUserId: receiverId });
//                 activeCalls.set(receiverId, { callId: call._id, conversationId, otherUserId: userId });
                
//                 io.to(receiverSocketId).emit('call_incoming', {
//                     callId: call._id,
//                     caller: userId,
//                     conversationId,
//                     callType,
//                     offer
//                 });
                
//             } catch (err) {
//                 console.error('Call initiate error:', err);
//                 socket.emit('call_error', { message: 'Lỗi khởi tạo cuộc gọi' });
//             }
//         });
        
//         socket.on('call_accept', async (data) => {
//             try {
//                 const { callId, answer } = data;
//                 const call = await Call.findById(callId);
//                 if (!call) return;
                
//                 call.status = 'accepted';
//                 call.answer = answer;
//                 call.startedAt = new Date();
//                 await call.save();
                
//                 const callerSocketId = onlineUsers.get(call.caller.toString());
//                 if (callerSocketId) {
//                     io.to(callerSocketId).emit('call_accepted', { callId, answer });
//                 }
                
//             } catch (err) {
//                 console.error('Call accept error:', err);
//             }
//         });
        
//         socket.on('call_reject', async (data) => {
//             try {
//                 const { callId } = data;
//                 const call = await Call.findById(callId);
//                 if (!call) return;
                
//                 call.status = 'rejected';
//                 call.endedAt = new Date();
//                 await call.save();
                
//                 _cleanupCall(callId);
                
//                 const callerSocketId = onlineUsers.get(call.caller.toString());
//                 if (callerSocketId) {
//                     io.to(callerSocketId).emit('call_rejected', { callId });
//                 }
                
//             } catch (err) {
//                 console.error('Call reject error:', err);
//             }
//         });
        
//         socket.on('call_cancel', async (data) => {
//             try {
//                 const { callId } = data;
//                 const call = await Call.findById(callId);
//                 if (!call) return;
                
//                 call.status = call.status === 'accepted' ? 'ended' : 'cancelled';
//                 call.endedAt = new Date();
//                 await call.save();
                
//                 _cleanupCall(callId);
                
//                 const receiverSocketId = onlineUsers.get(call.receiver.toString());
//                 if (receiverSocketId && call.status !== 'rejected') {
//                     io.to(receiverSocketId).emit('call_cancelled', { callId });
//                 }
                
//             } catch (err) {
//                 console.error('Call cancel error:', err);
//             }
//         });
        
//         socket.on('call_end', async (data) => {
//             try {
//                 const { callId, endedBy } = data;
//                 const call = await Call.findById(callId);
//                 if (!call) return;
                
//                 if (call.startedAt) {
//                     call.duration = Math.floor((new Date() - call.startedAt) / 1000);
//                 }
//                 call.status = 'ended';
//                 call.endedBy = endedBy;
//                 call.endedAt = new Date();
//                 await call.save();
                
//                 _cleanupCall(callId);
                
//                 const otherUserId = call.caller.toString() === userId ? call.receiver : call.caller;
//                 const otherSocketId = onlineUsers.get(otherUserId.toString());
//                 if (otherSocketId) {
//                     io.to(otherSocketId).emit('call_ended', { callId, endedBy, duration: call.duration });
//                 }
                
//             } catch (err) {
//                 console.error('Call end error:', err);
//             }
//         });
        
//         socket.on('signal', (data) => {
//             const { targetUserId, signal } = data;
//             const targetSocketId = onlineUsers.get(targetUserId);
//             if (targetSocketId) {
//                 io.to(targetSocketId).emit('signal', { 
//                     from: userId, 
//                     signal,
//                     callId: data.callId 
//                 });
//             }
//         });
        
//         socket.on('check_friend_status', async (friendId) => {
//             try {
//                 const user = await Account.findById(userId).populate('friends', '_id').lean();
//                 if (!user) return;
//                 const isFriend = user.friends.some(f => f._id.toString() === friendId);
//                 if (!isFriend) return;
//                 const isOnline = onlineUsers.has(friendId);
//                 socket.emit('friend_status_changed', {
//                     userId: friendId,
//                     status: isOnline ? 'online' : 'offline'
//                 });
//             } catch (err) {
//                 console.error('Error checking friend status:', err);
//             }
//         });
 
//         socket.on('join_room', (conversationId) => {
//             socket.join(conversationId);
//         });
 
//         socket.on('send_message', async (data) => {
//             try {
//                 const { conversationId, content, type } = data;
//                 const newMessage = new Message({
//                     conversationId,
//                     sender: userId,
//                     content,
//                     type: type || 'text'
//                 });
//                 const saved = await newMessage.save();
//                 await Conversation.findByIdAndUpdate(conversationId, { lastMessage: saved._id });
 
//                 const populated = await saved.populate('sender', 'username avatar email');
//                 io.to(conversationId).emit('receive_message', populated.toObject());
//             } catch (err) {
//                 console.error("Error sending message:", err);
//             }
//         });
 
//         socket.on('typing', (data) => {
//             socket.to(data.conversationId).emit('typing', { sender: userId });
//         });

//         socket.on('stop_typing', (data) => {
//             socket.to(data.conversationId).emit('stop_typing', { sender: userId });
//         });
 
//         socket.on('disconnect', async () => {
//             console.log(`🔴 User disconnected: ${userId}`);
//             onlineUsers.delete(userId);
            
//             if (activeCalls.has(userId)) {
//                 const callInfo = activeCalls.get(userId);
//                 const call = await Call.findById(callInfo.callId);
//                 if (call && call.status === 'accepted') {
//                     call.status = 'ended';
//                     call.endedAt = new Date();
//                     if (call.startedAt) {
//                         call.duration = Math.floor((new Date() - call.startedAt) / 1000);
//                     }
//                     await call.save();
                    
//                     const otherSocketId = onlineUsers.get(callInfo.otherUserId);
//                     if (otherSocketId) {
//                         io.to(otherSocketId).emit('call_ended', { 
//                             callId: call._id, 
//                             endedBy: userId, 
//                             duration: call.duration,
//                             reason: 'disconnected'
//                         });
//                     }
//                 }
//                 _cleanupCall(callInfo.callId);
//             }
            
//             await Account.findByIdAndUpdate(userId, { lastSeen: new Date() }).exec();
//             _notifyFriends(userId, 'offline');
//         });
//     });
// };

// function _cleanupCall(callId) {
//     for (const [uid, callInfo] of activeCalls.entries()) {
//         if (callInfo.callId.toString() === callId.toString()) {
//             activeCalls.delete(uid);
//         }
//     }
// }
 
// async function _notifyFriends(userId, status) {
//     try {
//         const user = await Account.findById(userId).populate('friends', '_id').lean();
//         if (!user) return;
//         const friendIds = user.friends.map(f => f._id.toString());
//         friendIds.forEach(friendId => {
//             const friendSocketId = onlineUsers.get(friendId);
//             if (friendSocketId) {
//                 io.to(friendSocketId).emit('friend_status_changed', {
//                     userId: userId,
//                     status: status
//                 });
//             }
//         });
//     } catch (err) {
//         console.error('Error notifying friends:', err);
//     }
// }
 
// const isUserOnline = (userId) => onlineUsers.has(userId);

// const getOnlineUsers = () => onlineUsers;

// const getIO = () => {
//     if (!io) throw new Error("Socket.io not initialized!");
//     return io;
// };
 
// module.exports = { initSocket, getIO, isUserOnline, getOnlineUsers };
// socket.js
const { Server } = require("socket.io");
const { Message, Conversation } = require('./models/message.model');
const Call = require('./models/call.model');
const Account = require('./models/account.model');
const jwt = require('jsonwebtoken');
const fcm = require('./services/fcm.service'); // ✅ FCM

let io;
const onlineUsers = new Map();
const activeCalls = new Map();

const initSocket = (server) => {
    io = new Server(server, {
        cors: { origin: "*", methods: ["GET", "POST"] }
    });

    io.use((socket, next) => {
        try {
            const token = socket.handshake.auth.token || socket.handshake.query.token;
            if (!token) return next(new Error("Authentication error"));
            const decoded = jwt.verify(token, process.env.JWT_SECRET);
            socket.userId = decoded.id || decoded._id;
            next();
        } catch (err) {
            next(new Error("Authentication error"));
        }
    });

    io.on('connection', (socket) => {
        const userId = socket.userId;
        console.log(`🟢 User connected: ${userId} - Socket: ${socket.id}`);

        onlineUsers.set(userId, socket.id);
        Account.findByIdAndUpdate(userId, { lastSeen: new Date() }).exec();
        _notifyFriends(userId, 'online');

        // ─── CALL EVENTS ─────────────────────────────────────────────────────

        socket.on('call_initiate', async (data) => {
            try {
                const { receiverId, conversationId, callType, offer } = data;

                if (activeCalls.has(userId)) {
                    socket.emit('call_error', { message: 'Bạn đang trong cuộc gọi khác' });
                    return;
                }

                if (activeCalls.has(receiverId)) {
                    socket.emit('call_busy', { receiverId });
                    await Call.create({ conversationId, caller: userId, receiver: receiverId, callType, status: 'missed', duration: 0 });
                    return;
                }

                const call = await Call.create({
                    conversationId, caller: userId, receiver: receiverId,
                    callType, status: 'ringing', offer
                });

                activeCalls.set(userId, { callId: call._id, conversationId, otherUserId: receiverId });
                activeCalls.set(receiverId, { callId: call._id, conversationId, otherUserId: userId });

                // Lấy thông tin caller
                const callerInfo = await Account.findById(userId).select('username avatar').lean();

                const callPayload = {
                    callId: call._id,
                    caller: {
                        _id: userId,
                        username: callerInfo?.username || 'Unknown',
                        avatar: callerInfo?.avatar || '',
                    },
                    conversationId,
                    callType,
                    offer,
                };

                const receiverSocketId = onlineUsers.get(receiverId);
                if (receiverSocketId) {
                    // ✅ Online → gửi qua socket
                    io.to(receiverSocketId).emit('call_incoming', callPayload);
                } else {
                    // ✅ Offline/kill app → gửi FCM
                    const receiver = await Account.findById(receiverId).select('fcmToken').lean();
                    if (receiver?.fcmToken) {
                        await fcm.sendCallNotification({
                            fcmToken: receiver.fcmToken,
                            callerName: callerInfo?.username || 'Unknown',
                            callerAvatar: callerInfo?.avatar || '',
                            callType,
                            callId: call._id,
                            conversationId,
                        });
                    }
                }

            } catch (err) {
                console.error('Call initiate error:', err);
                socket.emit('call_error', { message: 'Lỗi khởi tạo cuộc gọi' });
            }
        });

        socket.on('call_accept', async (data) => {
            try {
                const { callId, answer } = data;
                const call = await Call.findById(callId);
                if (!call) return;

                call.status = 'accepted';
                call.answer = answer;
                call.startedAt = new Date();
                await call.save();

                const callerSocketId = onlineUsers.get(call.caller.toString());
                if (callerSocketId) {
                    io.to(callerSocketId).emit('call_accepted', { callId, answer });
                }
            } catch (err) {
                console.error('Call accept error:', err);
            }
        });

        socket.on('call_reject', async (data) => {
            try {
                const { callId } = data;
                const call = await Call.findById(callId);
                if (!call) return;

                call.status = 'rejected';
                call.endedAt = new Date();
                await call.save();
                _cleanupCall(callId);

                const callerSocketId = onlineUsers.get(call.caller.toString());
                if (callerSocketId) {
                    io.to(callerSocketId).emit('call_rejected', { callId });
                }
            } catch (err) {
                console.error('Call reject error:', err);
            }
        });

        socket.on('call_cancel', async (data) => {
            try {
                const { callId } = data;
                const call = await Call.findById(callId);
                if (!call) return;

                call.status = call.status === 'accepted' ? 'ended' : 'cancelled';
                call.endedAt = new Date();
                await call.save();
                _cleanupCall(callId);

                const receiverSocketId = onlineUsers.get(call.receiver.toString());
                if (receiverSocketId) {
                    io.to(receiverSocketId).emit('call_cancelled', { callId });
                }
            } catch (err) {
                console.error('Call cancel error:', err);
            }
        });

        socket.on('call_end', async (data) => {
            try {
                const { callId, endedBy } = data;
                const call = await Call.findById(callId);
                if (!call) return;

                if (call.startedAt) {
                    call.duration = Math.floor((new Date() - call.startedAt) / 1000);
                }
                call.status = 'ended';
                call.endedBy = endedBy;
                call.endedAt = new Date();
                await call.save();
                _cleanupCall(callId);

                const otherUserId = call.caller.toString() === userId
                    ? call.receiver.toString()
                    : call.caller.toString();
                const otherSocketId = onlineUsers.get(otherUserId);
                if (otherSocketId) {
                    io.to(otherSocketId).emit('call_ended', { callId, endedBy, duration: call.duration });
                }
            } catch (err) {
                console.error('Call end error:', err);
            }
        });

        socket.on('signal', (data) => {
            const { targetUserId, signal, callId } = data;
            const targetSocketId = onlineUsers.get(targetUserId);
            if (targetSocketId) {
                io.to(targetSocketId).emit('signal', { from: userId, signal, callId });
            }
        });

        // ─── MESSAGE EVENTS ───────────────────────────────────────────────────

        socket.on('check_friend_status', async (friendId) => {
            try {
                const user = await Account.findById(userId).populate('friends', '_id').lean();
                if (!user) return;
                const isFriend = user.friends.some(f => f._id.toString() === friendId);
                if (!isFriend) return;
                const isOnline = onlineUsers.has(friendId);
                socket.emit('friend_status_changed', {
                    userId: friendId,
                    status: isOnline ? 'online' : 'offline'
                });
            } catch (err) {
                console.error('Error checking friend status:', err);
            }
        });

        socket.on('join_room', (conversationId) => {
            socket.join(conversationId);
        });

        socket.on('send_message', async (data) => {
            try {
                const { conversationId, content, type } = data;

                const newMessage = new Message({
                    conversationId,
                    sender: userId,
                    content,
                    type: type || 'text'
                });
                const saved = await newMessage.save();
                await Conversation.findByIdAndUpdate(conversationId, { lastMessage: saved._id });

                const populated = await saved.populate('sender', 'username avatar email');
                io.to(conversationId).emit('receive_message', populated.toObject());

                // ✅ Gửi FCM cho members đang OFFLINE
                const conversation = await Conversation.findById(conversationId)
                    .populate('members', '_id fcmToken')
                    .lean();

                if (conversation?.members) {
                    for (const member of conversation.members) {
                        const memberId = member._id.toString();
                        // Bỏ qua sender và ai đang online
                        if (memberId === userId) continue;
                        if (onlineUsers.has(memberId)) continue;
                        if (!member.fcmToken) continue;

                        await fcm.sendMessageNotification({
                            fcmToken: member.fcmToken,
                            senderName: populated.sender.username,
                            senderAvatar: populated.sender.avatar || '',
                            message: content,
                            conversationId: conversationId.toString(),
                        });
                    }
                }

            } catch (err) {
                console.error("Error sending message:", err);
            }
        });

        socket.on('typing', (data) => {
            socket.to(data.conversationId).emit('typing', { sender: userId });
        });

        socket.on('stop_typing', (data) => {
            socket.to(data.conversationId).emit('stop_typing', { sender: userId });
        });

        // ─── DISCONNECT ───────────────────────────────────────────────────────

        socket.on('disconnect', async () => {
            console.log(`🔴 User disconnected: ${userId}`);
            onlineUsers.delete(userId);

            if (activeCalls.has(userId)) {
                const callInfo = activeCalls.get(userId);
                try {
                    const call = await Call.findById(callInfo.callId);
                    if (call && (call.status === 'accepted' || call.status === 'ringing')) {
                        if (call.startedAt) {
                            call.duration = Math.floor((new Date() - call.startedAt) / 1000);
                        }
                        call.status = 'ended';
                        call.endedBy = userId;
                        call.endedAt = new Date();
                        await call.save();

                        const otherSocketId = onlineUsers.get(callInfo.otherUserId);
                        if (otherSocketId) {
                            io.to(otherSocketId).emit('call_ended', {
                                callId: call._id,
                                endedBy: userId,
                                duration: call.duration,
                                reason: 'disconnected'
                            });
                        }
                    }
                } catch (err) {
                    console.error('Disconnect call cleanup error:', err);
                }
                _cleanupCall(callInfo.callId);
            }

            await Account.findByIdAndUpdate(userId, { lastSeen: new Date() }).exec();
            _notifyFriends(userId, 'offline');
        });
    });
};

function _cleanupCall(callId) {
    for (const [uid, callInfo] of activeCalls.entries()) {
        if (callInfo.callId.toString() === callId.toString()) {
            activeCalls.delete(uid);
        }
    }
}

async function _notifyFriends(userId, status) {
    try {
        const user = await Account.findById(userId).populate('friends', '_id').lean();
        if (!user) return;
        user.friends.forEach(friend => {
            const friendSocketId = onlineUsers.get(friend._id.toString());
            if (friendSocketId) {
                io.to(friendSocketId).emit('friend_status_changed', { userId, status });
            }
        });
    } catch (err) {
        console.error('Error notifying friends:', err);
    }
}

const isUserOnline = (userId) => onlineUsers.has(userId);
const getOnlineUsers = () => onlineUsers;
const getIO = () => {
    if (!io) throw new Error("Socket.io not initialized!");
    return io;
};

module.exports = { initSocket, getIO, isUserOnline, getOnlineUsers };