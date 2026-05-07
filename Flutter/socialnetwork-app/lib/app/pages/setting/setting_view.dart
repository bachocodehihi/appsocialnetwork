import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/setting/setting_controller.dart';
import 'package:socialnetwork/app/widgets/item/setting.dart';
class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  
  late SettingController controller;

  @override
  void initState() {
    super.initState();
    controller = SettingController();
  }

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
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
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
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 20.sp,
                        color: cs.onSurface,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Setting',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                Text(
                  'Interface',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                  ),
                ),

                SizedBox(height: 20.h),

                SettingItem(
                  title: 'Dark mode',
                  icon: Icons.dark_mode_outlined,
                  color: cs.onSurface,
                  onTap: () {
                    controller.goToDarkmode(context);
                  },
                ),

                SizedBox(height: 15.h),

                SettingItem(
                  title: 'Language',
                  icon: Icons.language_outlined,
                  color: cs.onSurface,
                  onTap: () {
                    controller.goToLanguage(context);
                  },
                ),

                SizedBox(height: 15.h),

                SettingItem(
                  title: 'Font',
                  icon: Icons.format_size_outlined,
                  color: cs.onSurface,
                  onTap: () {
                    controller.goToFont(context);
                  },
                ),

                SizedBox(height: 20.h),

                Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                  ),
                ),

                SizedBox(height: 20.h),

                SettingItem(
                  title: 'Account',
                  icon: Icons.person_outlined,
                  color: cs.onSurface,
                  onTap: () {
                    controller.goToAccount(context);
                  },
                ),

                SizedBox(height: 15.h),

                SettingItem(
                  title: 'Activity',
                  icon: Icons.access_time_outlined,
                  color: cs.onSurface,
                  onTap: () {
                    controller.goToActivity(context);
                  },
                ),

                SizedBox(height: 20.h),

                Text(
                  'Notification',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                  ),
                ),

                SizedBox(height: 20.h),

                SettingItem(
                  title: 'Notification',
                  icon: Icons.notifications_outlined,
                  color: cs.onSurface,
                  onTap: () {},
                ),

                SizedBox(height: 20.h),

                Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                  ),
                ),
                
                SizedBox(height: 20.h),

                SettingItem(
                  title: 'Switch account',
                  icon: Icons.swap_horiz_outlined,
                  color: cs.onSurface,
                  onTap: () {
                    controller.switchAccount(context);
                  },
                ),

                SizedBox(height: 15.h),

                SettingItem(
                  title: 'Log out',
                  icon: Icons.logout_outlined,
                  color: Colors.red,
                  onTap: () {
                    controller.logout(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
