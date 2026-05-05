// // lib/data/service/call_service.dart
// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:socialnetwork/data/service/socket.dart';
// import 'package:socialnetwork/data/service/sound.dart';

// enum CallState { idle, ringing, calling, connected, ended }

// class CallInfo {
//   final String callId;
//   final String callType; // 'voice' | 'video'
//   final Map<String, dynamic> remoteUser; // { _id, username, avatar }
//   final bool isIncoming;

//   CallInfo({
//     required this.callId,
//     required this.callType,
//     required this.remoteUser,
//     required this.isIncoming,
//   });

//   CallInfo copyWith({
//     String? callId,
//     String? callType,
//     Map<String, dynamic>? remoteUser,
//     bool? isIncoming,
//   }) {
//     return CallInfo(
//       callId: callId ?? this.callId,
//       callType: callType ?? this.callType,
//       remoteUser: remoteUser ?? this.remoteUser,
//       isIncoming: isIncoming ?? this.isIncoming,
//     );
//   }
// }

// class CallService extends ChangeNotifier {
//   static final CallService _instance = CallService._internal();
//   factory CallService() => _instance;
//   CallService._internal();

//   final _socket = SocketService();
//   final _sound = SoundService();

//   // ─── State ────────────────────────────────────────────────────────────────
//   CallState _callState = CallState.idle;
//   CallInfo? _currentCall;
//   bool _isMuted = false;
//   bool _isSpeakerOn = false;
//   bool _isCameraOff = false;
//   Duration _callDuration = Duration.zero;
//   Timer? _durationTimer;
//   Timer? _autoCancelTimer;

//   // Lưu offer tạm khi nhận call_incoming
//   Map<String, dynamic>? _pendingOffer;

//   // ─── WebRTC ───────────────────────────────────────────────────────────────
//   RTCPeerConnection? _pc;
//   MediaStream? _localStream;
//   MediaStream? _remoteStream;
//   final RTCVideoRenderer localRenderer = RTCVideoRenderer();
//   final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

//   // ─── Callbacks (để show UI từ bất kỳ đâu) ────────────────────────────────
//   void Function(CallInfo)? onIncomingCall;
//   void Function()? onCallEnded;
//   void Function()? onCallConnected;
//   void Function(String message)? onCallError;
//   void Function()? onCallBusy;

//   // ─── Getters ──────────────────────────────────────────────────────────────
//   CallState get callState => _callState;
//   CallInfo? get currentCall => _currentCall;
//   bool get isMuted => _isMuted;
//   bool get isSpeakerOn => _isSpeakerOn;
//   bool get isCameraOff => _isCameraOff;
//   Duration get callDuration => _callDuration;
//   MediaStream? get localStream => _localStream;
//   MediaStream? get remoteStream => _remoteStream;
//   bool get isInCall => _callState != CallState.idle && _callState != CallState.ended;

//   // ─── INIT (gọi 1 lần sau khi login + socket connected) ───────────────────
//   Future<void> init() async {
//     await localRenderer.initialize();
//     await remoteRenderer.initialize();
//     _registerListeners();
//     debugPrint('✅ CallService initialized');
//   }

//   void _registerListeners() {
//     _socket.on('call_incoming', _onCallIncoming);
//     _socket.on('call_accepted', _onCallAccepted);
//     _socket.on('call_rejected', _onCallRejected);
//     _socket.on('call_cancelled', _onCallCancelled);
//     _socket.on('call_ended', _onCallEnded);
//     _socket.on('call_busy', _onCallBusy);
//     _socket.on('call_error', _onCallError);
//     _socket.on('signal', _onSignal);
//   }

//   // ─── OUTGOING CALL ────────────────────────────────────────────────────────
//   Future<void> startCall({
//     required String receiverId,
//     required String conversationId,
//     required String callType,
//     required Map<String, dynamic> callerInfo,
//     required Map<String, dynamic> receiverInfo,
//   }) async {
//     if (_callState != CallState.idle) {
//       debugPrint('⚠️ Already in a call');
//       return;
//     }

//     try {
//       // Setup WebRTC trước để có offer
//       await _setupPeerConnection(callType);
//       final offer = await _pc!.createOffer();
//       await _pc!.setLocalDescription(offer);

//       _currentCall = CallInfo(
//         callId: '',  // sẽ update khi nhận call_accepted
//         callType: callType,
//         remoteUser: receiverInfo,
//         isIncoming: false,
//       );
//       _callState = CallState.ringing;
//       notifyListeners();

//       _sound.playOutgoingRing();

//       // Gửi lên server kèm offer
//       _socket.emit('call_initiate', {
//         'receiverId': receiverId,
//         'conversationId': conversationId,
//         'callType': callType,
//         'offer': {'type': offer.type, 'sdp': offer.sdp},
//       });

//       // Tự hủy sau 45 giây nếu không bắt máy
//       _autoCancelTimer?.cancel();
//       _autoCancelTimer = Timer(const Duration(seconds: 45), () {
//         if (_callState == CallState.ringing) {
//           cancelCall();
//         }
//       });
//     } catch (e) {
//       debugPrint('❌ startCall error: $e');
//       _resetCall();
//     }
//   }

//   // ─── INCOMING: nhận cuộc gọi từ server ────────────────────────────────────
//   void _onCallIncoming(dynamic data) {
//     debugPrint('📞 Incoming call: $data');

//     if (_callState != CallState.idle) {
//       // Đang bận — tự từ chối
//       _socket.emit('call_reject', {'callId': data['callId'].toString()});
//       return;
//     }

//     // ✅ Lưu offer lại để dùng trong acceptCall
//     if (data['offer'] != null) {
//       _pendingOffer = Map<String, dynamic>.from(data['offer']);
//     }

//     // caller có thể là string ID hoặc object tùy backend
//     final callerRaw = data['caller'];
//     final remoteUser = callerRaw is Map
//         ? Map<String, dynamic>.from(callerRaw)
//         : {'_id': callerRaw.toString(), 'username': 'Unknown', 'avatar': ''};

//     _currentCall = CallInfo(
//       callId: data['callId'].toString(),
//       callType: data['callType'] ?? 'voice',
//       remoteUser: remoteUser,
//       isIncoming: true,
//     );
//     _callState = CallState.ringing;
//     notifyListeners();

//     _sound.playIncomingRing();
//     onIncomingCall?.call(_currentCall!);
//   }

//   // ─── ACCEPT: receiver bắt máy ─────────────────────────────────────────────
//   Future<void> acceptCall({Map<String, dynamic>? callerInfo}) async {
//     if (_currentCall == null || _callState != CallState.ringing) return;
//     _sound.stopRing();

//     // Cập nhật remoteUser nếu có thêm thông tin
//     if (callerInfo != null) {
//       _currentCall = _currentCall!.copyWith(remoteUser: callerInfo);
//     }

//     _callState = CallState.calling;
//     notifyListeners();

//     try {
//       // Setup WebRTC
//       await _setupPeerConnection(_currentCall!.callType);

//       // ✅ Set remote description từ offer đã lưu lúc call_incoming
//       if (_pendingOffer != null) {
//         await _pc!.setRemoteDescription(
//           RTCSessionDescription(_pendingOffer!['sdp'], _pendingOffer!['type']),
//         );
//         _pendingOffer = null;
//       }

//       // ✅ Tạo answer và gửi lên server
//       final answer = await _pc!.createAnswer();
//       await _pc!.setLocalDescription(answer);

//       _socket.emit('call_accept', {
//         'callId': _currentCall!.callId,
//         'answer': {'type': answer.type, 'sdp': answer.sdp},
//       });
//     } catch (e) {
//       debugPrint('❌ acceptCall error: $e');
//       _resetCall();
//     }
//   }

//   // ─── REJECT: receiver từ chối ─────────────────────────────────────────────
//   Future<void> rejectCall() async {
//     if (_currentCall == null) return;
//     _sound.stopRing();
//     _pendingOffer = null;
//     _socket.emit('call_reject', {'callId': _currentCall!.callId});
//     _resetCall();
//   }

//   // ─── CANCEL: caller hủy trước khi bắt ────────────────────────────────────
//   Future<void> cancelCall() async {
//     if (_currentCall == null) return;
//     _autoCancelTimer?.cancel();
//     _sound.stopRing();
//     _socket.emit('call_cancel', {'callId': _currentCall!.callId});
//     _resetCall();
//   }

//   // ─── END: kết thúc cuộc gọi đang active ──────────────────────────────────
//   Future<void> endCall() async {
//     if (_currentCall == null) return;
//     _socket.emit('call_end', {
//       'callId': _currentCall!.callId,
//       'endedBy': _currentCall!.remoteUser['_id'],
//     });
//     _resetCall();
//     onCallEnded?.call();
//   }

//   // ─── SOCKET HANDLERS ──────────────────────────────────────────────────────

//   // Caller nhận khi receiver bắt máy
//   void _onCallAccepted(dynamic data) {
//     debugPrint('✅ Call accepted: $data');
//     _autoCancelTimer?.cancel();
//     _sound.stopRing();

//     if (_currentCall != null) {
//       _currentCall = _currentCall!.copyWith(
//         callId: data['callId'].toString(),
//       );
//     }

//     _callState = CallState.calling;
//     notifyListeners();

//     // ✅ Caller set remote description từ answer của receiver
//     if (data['answer'] != null) {
//       _pc?.setRemoteDescription(RTCSessionDescription(
//         data['answer']['sdp'],
//         data['answer']['type'],
//       ));
//     }
//   }

//   void _onCallRejected(dynamic data) {
//     debugPrint('❌ Call rejected');
//     _autoCancelTimer?.cancel();
//     _sound.stopRing();
//     _resetCall();
//     onCallEnded?.call();
//   }

//   void _onCallCancelled(dynamic data) {
//     debugPrint('❌ Call cancelled by caller');
//     _sound.stopRing();
//     _pendingOffer = null;
//     _resetCall();
//     onCallEnded?.call();
//   }

//   void _onCallEnded(dynamic data) {
//     debugPrint('📵 Call ended');
//     _sound.stopRing();
//     _resetCall();
//     onCallEnded?.call();
//   }

//   void _onCallBusy(dynamic data) {
//     debugPrint('📵 Receiver is busy');
//     _autoCancelTimer?.cancel();
//     _sound.stopRing();
//     _resetCall();
//     onCallBusy?.call();
//   }

//   void _onCallError(dynamic data) {
//     debugPrint('❌ Call error: ${data['message']}');
//     _autoCancelTimer?.cancel();
//     _sound.stopRing();
//     _resetCall();
//     onCallError?.call(data['message']?.toString() ?? 'Lỗi không xác định');
//   }

//   // ─── SIGNAL: chỉ xử lý ICE candidate ────────────────────────────────────
//   // offer/answer đã được xử lý trực tiếp qua call_incoming và call_accepted
//   Future<void> _onSignal(dynamic data) async {
//     final signal = data['signal'];
//     if (signal == null || _pc == null) return;

//     final type = signal['type'];
//     debugPrint('📡 Signal received: $type');

//     if (type == 'candidate') {
//       try {
//         await _pc!.addCandidate(RTCIceCandidate(
//           signal['candidate'],
//           signal['sdpMid'],
//           signal['sdpMLineIndex'],
//         ));
//       } catch (e) {
//         debugPrint('❌ addCandidate error: $e');
//       }
//     }
//   }

//   // ─── WEBRTC SETUP ─────────────────────────────────────────────────────────
//   Future<void> _setupPeerConnection(String callType) async {
//     // Đóng PC cũ nếu có
//     await _pc?.close();
//     _pc = null;

//     final config = {
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//         {'urls': 'stun:stun1.l.google.com:19302'},
//         {'urls': 'stun:stun2.l.google.com:19302'},
//       ],
//       'sdpSemantics': 'unified-plan',
//     };

//     _pc = await createPeerConnection(config);

//     // Lấy local media stream
//     _localStream?.dispose();
//     _localStream = await navigator.mediaDevices.getUserMedia({
//       'audio': true,
//       'video': callType == 'video'
//           ? {'facingMode': 'user', 'width': 640, 'height': 480}
//           : false,
//     });
//     localRenderer.srcObject = _localStream;

//     // Thêm tracks vào peer connection
//     for (final track in _localStream!.getTracks()) {
//       await _pc!.addTrack(track, _localStream!);
//     }

//     // Nhận remote stream
//     _pc!.onTrack = (RTCTrackEvent event) {
//       if (event.streams.isNotEmpty) {
//         _remoteStream = event.streams[0];
//         remoteRenderer.srcObject = _remoteStream;
//         _callState = CallState.connected;
//         _startDurationTimer();
//         notifyListeners();
//         onCallConnected?.call();
//         debugPrint('✅ P2P connected — remote stream received');
//       }
//     };

//     // Gửi ICE candidates qua signal event
//     _pc!.onIceCandidate = (RTCIceCandidate candidate) {
//       if (candidate.candidate == null || _currentCall == null) return;
//       _socket.emit('signal', {
//         'targetUserId': _currentCall!.remoteUser['_id'],
//         'callId': _currentCall!.callId,
//         'signal': {
//           'type': 'candidate',
//           'candidate': candidate.candidate,
//           'sdpMid': candidate.sdpMid,
//           'sdpMLineIndex': candidate.sdpMLineIndex,
//         },
//       });
//     };

//     _pc!.onIceConnectionState = (RTCIceConnectionState state) {
//       debugPrint('🔗 ICE state: $state');
//       if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
//           state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
//         debugPrint('❌ ICE connection failed/disconnected');
//       }
//     };
//   }

//   // ─── CONTROLS ─────────────────────────────────────────────────────────────
//   void toggleMute() {
//     _isMuted = !_isMuted;
//     _localStream?.getAudioTracks().forEach((t) => t.enabled = !_isMuted);
//     notifyListeners();
//   }

//   void toggleSpeaker() {
//     _isSpeakerOn = !_isSpeakerOn;
//     Helper.setSpeakerphoneOn(_isSpeakerOn);
//     notifyListeners();
//   }

//   void toggleCamera() {
//     _isCameraOff = !_isCameraOff;
//     _localStream?.getVideoTracks().forEach((t) => t.enabled = !_isCameraOff);
//     notifyListeners();
//   }

//   Future<void> switchCamera() async {
//     final tracks = _localStream?.getVideoTracks();
//     if (tracks != null && tracks.isNotEmpty) {
//       await Helper.switchCamera(tracks.first);
//     }
//   }

//   // ─── HELPERS ──────────────────────────────────────────────────────────────
//   void _startDurationTimer() {
//     _durationTimer?.cancel();
//     _callDuration = Duration.zero;
//     _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       _callDuration += const Duration(seconds: 1);
//       notifyListeners();
//     });
//   }

//   void _resetCall() {
//     _autoCancelTimer?.cancel();
//     _durationTimer?.cancel();
//     _pc?.close();
//     _pc = null;
//     _localStream?.dispose();
//     _localStream = null;
//     _remoteStream?.dispose();
//     _remoteStream = null;
//     localRenderer.srcObject = null;
//     remoteRenderer.srcObject = null;
//     _callState = CallState.idle;
//     _currentCall = null;
//     _pendingOffer = null;
//     _isMuted = false;
//     _isSpeakerOn = false;
//     _isCameraOff = false;
//     _callDuration = Duration.zero;
//     notifyListeners();
//   }

//   String formatDuration(Duration d) {
//     final h = d.inHours;
//     final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return h > 0 ? '$h:$m:$s' : '$m:$s';
//   }

//   @override
//   void dispose() {
//     localRenderer.dispose();
//     remoteRenderer.dispose();
//     _resetCall();
//     super.dispose();
//   }
// }