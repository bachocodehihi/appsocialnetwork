import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/setting/setting_controller.dart';

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
                        size: 25,
                        color: cs.onSurfaceVariant,
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
                _buildSettingItem(
                  icon: Icons.dark_mode_outlined,
                  text: 'Dark mode',
                  onTap: () {
                    controller.goToDarkmode(context);
                  },
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.language_outlined,
                  text: 'Language',
                  onTap: () {
                    controller.goToLanguage(context);
                  },
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.format_size_outlined,
                  text: 'Font',
                  onTap: () {},
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
                _buildSettingItem(
                  icon: Icons.person_outlined,
                  text: 'Account',
                  onTap: () {
                    controller.goToAccount(context);
                  },
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.access_time_outlined,
                  text: 'Activity',
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
                _buildSettingItem(
                  icon: Icons.notifications_outlined,
                  text: 'Notification',
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
                _buildSettingItem(
                  icon: Icons.swap_horiz_outlined,
                  text: 'Switch account',
                  onTap: () => controller.switchAccount(context),
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.logout_outlined,
                  text: 'Log out',
                  onTap: () => controller.logout(context)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 14.h,
        ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: cs.onSurface
                ),
                SizedBox(width: 10.w),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right_rounded, 
              color: cs.onSurface
            ),
          ],
        ),
      ),
    );
  }

}
