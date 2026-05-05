import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'user_controller.dart';

class ChatUserView extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverAvatar;
  final bool isFriend;
 
  const ChatUserView({
    super.key,
    required this.receiverId,
    required this.receiverName,
    this.receiverAvatar = '',
    this.isFriend = false,
  });
 
  @override
  State<ChatUserView> createState() => _ChatUserViewState();
}
 
class _ChatUserViewState extends State<ChatUserView> {
  late final ChatUserController _controller;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;
  int _lastMessageCount = 0;
 
  @override
  void initState() {
    super.initState();
    _controller = ChatUserController(
      receiverId: widget.receiverId,
      receiverName: widget.receiverName,
      receiverAvatar: widget.receiverAvatar,
      isFriend: widget.isFriend,
    );
    _textController.addListener(() {
      setState(() => _hasText = _textController.text.trim().isNotEmpty);
    });
    _controller.addListener(_onMessagesChanged);
  }
 
  void _onMessagesChanged() {
    final currentCount = _controller.messages.length;
    if (currentCount > _lastMessageCount) {
      _lastMessageCount = currentCount;
      _scrollToBottom();
    } else {
      _lastMessageCount = currentCount;
    }
  }
 
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }
 
  @override
  void dispose() {
    _controller.removeListener(_onMessagesChanged);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
 
  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _controller.sendMessage(text);
    _textController.clear();
    _scrollToBottom();
  }
 
  String? _extractSenderId(dynamic senderRaw) {
    if (senderRaw is Map) {
      return senderRaw['_id']?.toString() ?? senderRaw['id']?.toString();
    }
    return senderRaw?.toString();
  }
 
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ));
    final cs = Theme.of(context).colorScheme;
 
    return Scaffold(
      backgroundColor: cs.surface,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(cs),
            const Divider(height: 1),
            Expanded(child: _buildMessagesList(cs)),
            _buildInputBar(cs),
          ],
        ),
      ),
    );
  }
 
  Widget _buildHeader(ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kIsWeb ? 0 : 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios_outlined,
                    size: 22, color: cs.onSurfaceVariant),
              ),
              SizedBox(width: 8.w),
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: cs.primaryContainer,
                    backgroundImage: widget.receiverAvatar.isNotEmpty
                        ? NetworkImage(widget.receiverAvatar)
                        : null,
                    child: widget.receiverAvatar.isEmpty
                        ? Icon(Icons.person_outline,
                            size: 20, color: cs.onPrimaryContainer)
                        : null,
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.receiverName,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: cs.onSurface),
                      ),
                      if (widget.isFriend)
                        ListenableBuilder(
                          listenable: _controller,
                          builder: (context, _) {
                            final isOnline = _controller.isReceiverOnline;
                            return Text(
                              isOnline ? 'Online' : 'Offline',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isOnline ? Colors.green : cs.onSurface),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.phone_outlined, color: cs.onSurfaceVariant),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.videocam_outlined,
                      color: cs.onSurfaceVariant),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.more_vert_outlined,
                      color: cs.onSurfaceVariant),
                  onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
 
  Widget _buildMessagesList(ColorScheme cs) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.isLoading && _controller.messages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.error != null) {
          return Center(
              child: Text('${_controller.error}',
                  style: TextStyle(color: cs.error)));
        }
        if (_controller.messages.isEmpty) {
          return Center(
              child: Text('No messages yet',
                  style: TextStyle(color: cs.onSurfaceVariant)));
        }
 
        return ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(
              horizontal: kIsWeb ? 0 : 16.w, vertical: 12.h),
          itemCount: _controller.messages.length,
          shrinkWrap: false,
          cacheExtent: 500,
          itemBuilder: (context, i) {
            final msg = _controller.messages[i];
            final msgSenderId = _extractSenderId(msg['sender']);
            final isMe = msgSenderId == _controller.currentUserId;
 
            final prevMsgSenderId = i == 0
                ? null
                : _extractSenderId(_controller.messages[i - 1]['sender']);
            final showAvatar = i == 0 || prevMsgSenderId != msgSenderId;
 
            final msgId = msg['_id']?.toString() ??
                msg['id']?.toString() ??
                'msg_${i}_${msg['content']?.hashCode ?? 0}';
 
            return RepaintBoundary(
              child: Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  key: ValueKey('msg_$msgId'),
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isMe) ...[
                      showAvatar
                          ? CircleAvatar(
                              radius: 14.r,
                              backgroundColor: cs.primaryContainer,
                              child: Icon(Icons.person_outline,
                                  size: 16, color: cs.onPrimaryContainer))
                          : SizedBox(width: 28.w),
                      SizedBox(width: 8.w),
                    ],
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 0.65.sw),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? cs.primary
                                  : cs.surfaceContainerHighest,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18.r),
                                topRight: Radius.circular(18.r),
                                bottomLeft:
                                    Radius.circular(isMe ? 18.r : 4.r),
                                bottomRight:
                                    Radius.circular(isMe ? 4.r : 18.r),
                              ),
                            ),
                            child: Text(
                              msg['content'] ?? '',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isMe ? cs.onPrimary : cs.onSurface,
                                  height: 1.4),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            _formatTime(msg['createdAt']),
                            style: TextStyle(
                                fontSize: 10.sp,
                                color: cs.onSurfaceVariant
                                    .withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    ),
                    if (isMe) SizedBox(width: 4.w),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
 
  Widget _buildInputBar(ColorScheme cs) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
            top: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.emoji_emotions_outlined,
                  color: cs.onSurfaceVariant),
              onPressed: () {}),
          Expanded(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: _textController,
                enabled: !_controller.isSending,
                minLines: 1,
                maxLines: 4,
                style:
                    TextStyle(fontSize: 14.sp, color: cs.onSurface),
                decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.6)),
                  isDense: true,
                  border: InputBorder.none,
                ),
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 350), () {
                    _scrollToBottom();
                  });
                },
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          _controller.isSending
              ? const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : GestureDetector(
                  onTap: _hasText ? _sendMessage : null,
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: _hasText
                          ? cs.primary
                          : cs.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send_outlined,
                      size: 20,
                      color: _hasText ? cs.onPrimary : cs.onSurfaceVariant,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
 
  String _formatTime(dynamic t) {
    if (t == null) return '';
    final dt = t is String
        ? DateTime.tryParse(t)
        : t is int
            ? DateTime.fromMillisecondsSinceEpoch(t)
            : null;
    return dt != null
        ? '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
        : '';
  }
}