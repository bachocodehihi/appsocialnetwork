import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/wellcome/wellcome_controller.dart';
class WellcomeView extends StatefulWidget {
  const WellcomeView({super.key});
  @override
  State<WellcomeView> createState() => _WellcomeViewState();
}
class _WellcomeViewState extends State<WellcomeView> {
  final controller = WellcomeController();
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Column(
                children: [
                  Text(
                    'Hello!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Welcome to Social Network App',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(double.infinity, 48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(Colors.grey[300]),
                      ),
                      onPressed: () {
                        controller.goToSignInEmail(context);
                      },
                      child: Text(
                        'Sign in', 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 16.sp, 
                          fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        minimumSize: Size(double.infinity, 48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(Colors.grey[300]),
                      ),
                      onPressed: () {
                        controller.goToSignUpEmail(context);
                      },
                      child: Text(
                        'Create new account', 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 16.sp, 
                          fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}