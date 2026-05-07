import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
class NotificationView extends StatefulWidget {
  const NotificationView({super.key});
  @override
  State<NotificationView> createState() => _NotificationViewState();
}
class _NotificationViewState extends State<NotificationView> {
  final List<Map<String, String>> _notifications = const [
    {'title': 'Anna liked your post', 'time': '5m ago'},
    {'title': 'Lucas commented: Nice work!', 'time': '18m ago'},
    {'title': 'Mia started following you', 'time': '1h ago'},
    {'title': 'David sent a friend request', 'time': '2h ago'},
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
                    'Notification',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ..._notifications.map(
                (item) => Container(
                  margin: EdgeInsets.only(bottom: 10.h),
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
                    leading: CircleAvatar(
                      radius: 18.r,
                      backgroundColor: cs.primaryContainer,
                      child: Icon(
                        Icons.notifications_rounded,
                        size: 18.sp,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                    title: Text(item['title']!, style: TextStyle(color: cs.onSurface)),
                    subtitle: Text(
                      item['time']!,
                      style: TextStyle(fontSize: 12.sp, color: cs.onSurfaceVariant),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
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

