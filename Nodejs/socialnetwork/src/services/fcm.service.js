
// const admin = require('firebase-admin');
// const path = require('path');

// if (!admin.apps.length) {
//     admin.initializeApp({
//         credential: admin.credential.cert(
//             path.join(__dirname, '../firebase-service-account.json')
//         ),
//     });
// }

// const _removeInvalidToken = async (fcmToken) => {
//     try {
//         const Account = require('../models/account.model');
//         await Account.findOneAndUpdate({ fcmToken }, { fcmToken: null });
//         console.log('🗑️ Removed invalid FCM token');
//     } catch (e) {
//         console.error('Error removing FCM token:', e.message);
//     }
// };

// const sendMessageNotification = async ({ fcmToken, senderName, senderAvatar, message, conversationId }) => {
//     if (!fcmToken) return;
//     try {
//         await admin.messaging().send({
//             token: fcmToken,
//             notification: {
//                 title: senderName,
//                 body: message.length > 100 ? message.substring(0, 100) + '...' : message,
//             },
//             android: {
//                 priority: 'high',
//                 notification: {
//                     channelId: 'chat_channel',
//                     sound: 'default',
//                     imageUrl: senderAvatar || undefined,
//                     tag: 'msg_' + conversationId,
//                     color: '#2196F3',
//                 },
//             },
//             apns: {
//                 headers: { 'apns-priority': '10' },
//                 payload: { aps: { sound: 'default', badge: 1, 'mutable-content': 1 } },
//             },
//             data: {
//                 type: 'message',
//                 conversationId: conversationId.toString(),
//                 senderName,
//                 senderAvatar: senderAvatar || '',
//             },
//         });
//         console.log('📱 FCM message sent → ' + senderName);
//     } catch (err) {
//         if (err.code === 'messaging/registration-token-not-registered' || err.code === 'messaging/invalid-registration-token') {
//             await _removeInvalidToken(fcmToken);
//         } else {
//             console.error('❌ FCM sendMessage error:', err.message);
//         }
//     }
// };

// const sendCallNotification = async ({ fcmToken, callerName, callerAvatar, callType, callId, conversationId }) => {
//     if (!fcmToken) return;
//     try {
//         await admin.messaging().send({
//             token: fcmToken,
//             notification: {
//                 title: callerName,
//                 body: callType === 'video' ? '📹 Cuộc gọi video đến' : '📞 Cuộc gọi thoại đến',
//             },
//             android: {
//                 priority: 'high',
//                 notification: {
//                     channelId: 'call_channel',
//                     sound: 'default',
//                     imageUrl: callerAvatar || undefined,
//                     tag: 'call_' + callId,
//                     color: '#4CAF50',
//                 },
//             },
//             apns: {
//                 headers: { 'apns-priority': '10' },
//                 payload: { aps: { sound: 'default', badge: 1, 'content-available': 1 } },
//             },
//             data: {
//                 type: 'call',
//                 callId: callId.toString(),
//                 callType,
//                 callerName,
//                 callerAvatar: callerAvatar || '',
//                 conversationId: conversationId.toString(),
//             },
//         });
//         console.log('📱 FCM call sent → ' + callerName);
//     } catch (err) {
//         if (err.code === 'messaging/registration-token-not-registered' || err.code === 'messaging/invalid-registration-token') {
//             await _removeInvalidToken(fcmToken);
//         } else {
//             console.error('❌ FCM sendCall error:', err.message);
//         }
//     }
// };

// const sendFriendRequestNotification = async ({ fcmToken, senderName, senderAvatar, senderId }) => {
//     if (!fcmToken) return;
//     try {
//         await admin.messaging().send({
//             token: fcmToken,
//             notification: {
//                 title: 'Lời mời kết bạn',
//                 body: senderName + ' đã gửi lời mời kết bạn',
//             },
//             android: {
//                 priority: 'high',
//                 notification: {
//                     channelId: 'general_channel',
//                     sound: 'default',
//                     imageUrl: senderAvatar || undefined,
//                     color: '#FF9800',
//                 },
//             },
//             apns: {
//                 headers: { 'apns-priority': '10' },
//                 payload: { aps: { sound: 'default', badge: 1 } },
//             },
//             data: {
//                 type: 'friend_request',
//                 senderId: senderId.toString(),
//                 senderName,
//                 senderAvatar: senderAvatar || '',
//             },
//         });
//         console.log('📱 FCM friend request sent → ' + senderName);
//     } catch (err) {
//         if (err.code === 'messaging/registration-token-not-registered' || err.code === 'messaging/invalid-registration-token') {
//             await _removeInvalidToken(fcmToken);
//         } else {
//             console.error('❌ FCM sendFriendRequest error:', err.message);
//         }
//     }
// };

// module.exports = { sendMessageNotification, sendCallNotification, sendFriendRequestNotification };



// services/fcm.service.js
const admin = require('firebase-admin');
const path = require('path');

if (!admin.apps.length) {
    admin.initializeApp({
        credential: admin.credential.cert(
            path.join(__dirname, '../firebase-service-account.json')
        ),
    });
}

const _removeInvalidToken = async (fcmToken) => {
    try {
        const Account = require('../models/account.model');
        await Account.findOneAndUpdate({ fcmToken }, { fcmToken: null });
        console.log('🗑️ Removed invalid FCM token');
    } catch (e) {
        console.error('Error removing FCM token:', e.message);
    }
};

// ✅ Chỉ dùng data field, không dùng notification field
// → tránh Android tự show thêm 1 cái nữa
const sendMessageNotification = async ({ fcmToken, senderName, senderAvatar, message, conversationId }) => {
    if (!fcmToken) return;
    try {
        await admin.messaging().send({
            token: fcmToken,
            android: {
                priority: 'high',
            },
            apns: {
                headers: { 'apns-priority': '10' },
                payload: {
                    aps: {
                        sound: 'default',
                        badge: 1,
                        'mutable-content': 1,
                        'content-available': 1,
                    },
                },
            },
            // ✅ Toàn bộ thông tin để Flutter tự show local notification
            data: {
                type: 'message',
                conversationId: conversationId.toString(),
                senderName,
                senderAvatar: senderAvatar || '',
                title: senderName,
                body: message.length > 100 ? message.substring(0, 100) + '...' : message,
            },
        });
        console.log('📱 FCM message sent → ' + senderName);
    } catch (err) {
        if (
            err.code === 'messaging/registration-token-not-registered' ||
            err.code === 'messaging/invalid-registration-token'
        ) {
            await _removeInvalidToken(fcmToken);
        } else {
            console.error('❌ FCM sendMessage error:', err.message);
        }
    }
};

const sendCallNotification = async ({ fcmToken, callerName, callerAvatar, callType, callId, conversationId }) => {
    if (!fcmToken) return;
    try {
        await admin.messaging().send({
            token: fcmToken,
            android: {
                priority: 'high',
            },
            apns: {
                headers: { 'apns-priority': '10' },
                payload: {
                    aps: {
                        sound: 'default',
                        badge: 1,
                        'content-available': 1,
                    },
                },
            },
            data: {
                type: 'call',
                callId: callId.toString(),
                callType,
                callerName,
                callerAvatar: callerAvatar || '',
                conversationId: conversationId.toString(),
                title: callerName,
                body: callType === 'video' ? '📹 Cuộc gọi video đến' : '📞 Cuộc gọi thoại đến',
            },
        });
        console.log('📱 FCM call sent → ' + callerName);
    } catch (err) {
        if (
            err.code === 'messaging/registration-token-not-registered' ||
            err.code === 'messaging/invalid-registration-token'
        ) {
            await _removeInvalidToken(fcmToken);
        } else {
            console.error('❌ FCM sendCall error:', err.message);
        }
    }
};

const sendFriendRequestNotification = async ({ fcmToken, senderName, senderAvatar, senderId }) => {
    if (!fcmToken) return;
    try {
        await admin.messaging().send({
            token: fcmToken,
            android: {
                priority: 'high',
            },
            apns: {
                headers: { 'apns-priority': '10' },
                payload: {
                    aps: { sound: 'default', badge: 1 },
                },
            },
            data: {
                type: 'friend_request',
                senderId: senderId.toString(),
                senderName,
                senderAvatar: senderAvatar || '',
                title: 'Lời mời kết bạn',
                body: senderName + ' đã gửi lời mời kết bạn',
            },
        });
        console.log('📱 FCM friend request sent → ' + senderName);
    } catch (err) {
        if (
            err.code === 'messaging/registration-token-not-registered' ||
            err.code === 'messaging/invalid-registration-token'
        ) {
            await _removeInvalidToken(fcmToken);
        } else {
            console.error('❌ FCM sendFriendRequest error:', err.message);
        }
    }
};

module.exports = { sendMessageNotification, sendCallNotification, sendFriendRequestNotification };