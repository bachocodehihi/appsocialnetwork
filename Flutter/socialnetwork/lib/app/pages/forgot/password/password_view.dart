import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});
  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}
class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  final String _errorMessage = '';
  final bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

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
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_outlined, 
                      size: 25,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Enter new password',
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
                'Enter your new password',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40.h),
              TextFormField(
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'New password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: WidgetStateTextStyle.resolveWith(
                    (states) {
                      if (states.contains(WidgetState.focused)) {
                        return const TextStyle(color: Colors.blue);
                      }
                      return const TextStyle(color: Colors.grey);
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword =! _obscureNewPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              TextFormField(
                obscureText: _obscureConfirmNewPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm new password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: WidgetStateTextStyle.resolveWith(
                    (states) {
                      if (states.contains(WidgetState.focused)) {
                        return const TextStyle(color: Colors.blue);
                      }
                      return const TextStyle(color: Colors.grey);
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmNewPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmNewPassword =! _obscureConfirmNewPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_outlined, 
                          color: Colors.red, 
                          size: 18
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(
                              color: Colors.red, 
                              fontSize: 13.sp
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ).copyWith(
                    overlayColor: WidgetStateProperty.all(Colors.grey[300]),
                  ),
                  onPressed: () {
                  },
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
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
