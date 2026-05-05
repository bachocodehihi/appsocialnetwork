import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/main/tabs/home/home_controller.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {
  final controller = HomeController();
  final List<Map<String, String>> _stories = const [
    {'name': 'You', 'avatar': 'Y'},
    {'name': 'Anna', 'avatar': 'A'},
    {'name': 'Lucas', 'avatar': 'L'},
    {'name': 'Mia', 'avatar': 'M'},
    {'name': 'David', 'avatar': 'D'},
  ];

  final List<Map<String, String>> _posts = const [
    {
      'name': 'Anna Pham',
      'time': '12m ago',
      'content': 'Just finished a new design concept for our social app. What do you think?'
    },
    {
      'name': 'Lucas Tran',
      'time': '1h ago',
      'content': 'Sunday coffee + coding. Perfect combo for shipping new features!'
    },
    {
      'name': 'Mia Nguyen',
      'time': '2h ago',
      'content': 'Anyone up for a UI feedback exchange? I can review your screens too.'
    },
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
                  Row(
                    children: [
                      Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.goToSearch(context);
                        },
                        child: Icon(
                          Icons.search_outlined, 
                          size: 35,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () {
                          controller.goToScanner(context);
                        },
                        child: Icon(
                          Icons.qr_code_scanner_outlined, 
                          size: 35,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Builder(
                        builder: (context) => GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Icon(
                            Icons.menu_outlined, 
                            size: 35,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundColor: cs.primaryContainer,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'What\'s on your mind?',
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14.h,
                              horizontal: 12.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
              SizedBox(height: 16.h),
              ..._posts.map(
                (post) => Container(
                  margin: EdgeInsets.only(bottom: 14.h),
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18.r,
                            backgroundColor: cs.primaryContainer,
                            child: Text(
                              post['name']!.substring(0, 1),
                              style: TextStyle(
                                color: cs.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['name']!,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: cs.onSurface,
                                  ),
                                ),
                                Text(
                                  post['time']!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.more_horiz_rounded, color: cs.onSurfaceVariant),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        post['content']!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: cs.onSurface.withValues(alpha: 0.9),
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(Icons.favorite_border_rounded, size: 20.sp, color: cs.onSurfaceVariant),
                          SizedBox(width: 16.w),
                          Icon(Icons.chat_bubble_outline_rounded, size: 20.sp, color: cs.onSurfaceVariant),
                          SizedBox(width: 16.w),
                          Icon(Icons.share_rounded, size: 20.sp, color: cs.onSurfaceVariant),
                        ],
                      ),
                    ],
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

