import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
class MessageView extends StatefulWidget {
  const MessageView({super.key});
  @override
  State<MessageView> createState() => _MessageViewState();
}
class _MessageViewState extends State<MessageView> {
  final List<Map<String, String>> _conversations = const [
    {'name': 'Anna', 'message': 'Are you free tonight?', 'time': '09:24'},
    {'name': 'Lucas', 'message': 'I sent the new mockup.', 'time': '08:10'},
    {'name': 'Mia', 'message': 'See you at the meetup!', 'time': 'Yesterday'},
    {'name': 'David', 'message': 'Can you review this?', 'time': 'Yesterday'},
  ];

  final List<Map<String, String>> _stories = const [
    {'name': 'You', 'avatar': 'Y'},
    {'name': 'Anna', 'avatar': 'A'},
    {'name': 'Lucas', 'avatar': 'L'},
    {'name': 'Mia', 'avatar': 'M'},
    {'name': 'David', 'avatar': 'D'},
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    );
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kIsWeb ? 0 : 24.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Message',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search messages',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: cs.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 90.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _stories.length,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final item = _stories[index];
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundColor: cs.primaryContainer,
                          child: Text(
                            item['avatar']!,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: cs.onPrimaryContainer,
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          item['name']!,
                          style: TextStyle(fontSize: 12.sp, color: cs.onSurface),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
              ..._conversations.map(
                (chat) => Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                    leading: CircleAvatar(
                      backgroundColor: cs.primaryContainer,
                      child: Text(
                        chat['name']!.substring(0, 1),
                        style: TextStyle(color: cs.onPrimaryContainer),
                      ),
                    ),
                    title: Text(
                      chat['name']!,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      chat['message']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                    trailing: Text(
                      chat['time']!,
                      style: TextStyle(fontSize: 12.sp, color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}      

