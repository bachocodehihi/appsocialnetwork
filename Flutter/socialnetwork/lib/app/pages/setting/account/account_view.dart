import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/setting/account/account_controller.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  
  late AccountController controller;

  @override
  void initState() {
    super.initState();
    controller = AccountController();
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
                      'Account',
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
                  icon: Icons.assignment_ind_outlined,
                  text: 'Change information',
                  onTap: () {
                    controller.goToChange(context);
                  },
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.password_outlined,
                  text: 'Password',
                  onTap: () {
                  },
                ),
                SizedBox(height: 15.h),
                _buildSettingItem(
                  icon: Icons.delete_outlined,
                  text: 'Delete account',
                  onTap: () {

                  },
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
