import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/setting/change/change_controller.dart';
class ChangeView extends StatefulWidget {
  const ChangeView({super.key});

  @override
  State<ChangeView> createState() => _ChangeViewState();
}

class _ChangeViewState extends State<ChangeView> {
  final controller = ChangeController();
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
                      'Change information',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _buildSettingItem(
                  icon: Icons.person_outlined,
                  text: 'Username',
                  onTap: () {},
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.email_outlined,
                  text: 'Email',
                  onTap: () {},
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.wc_outlined,
                  text: 'Gender',
                  onTap: () {},
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.cake_outlined,
                  text: 'Birthday',
                  onTap: () {},
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.dark_mode_outlined,
                  text: 'Avatar',
                  onTap: () {},
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.password_outlined,
                  text: 'Password',
                  onTap: () {},
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.location_on_outlined,
                  text: 'Address',
                  onTap: () {},
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.phone_outlined,
                  text: 'Phone',
                  onTap: () {},
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.work_outline_outlined,
                  text: 'Job',
                  onTap: () {},
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
                    fontSize: 14.sp,
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
