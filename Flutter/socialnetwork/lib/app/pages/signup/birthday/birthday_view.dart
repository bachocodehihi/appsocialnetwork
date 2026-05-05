import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/signup/birthday/birthday_controller.dart';
import 'package:socialnetwork/app/widgets/dialog/birthday.dart';
import 'package:socialnetwork/app/widgets/banner/error.dart';

class SignUpBirthdayView extends StatefulWidget {
  const SignUpBirthdayView({super.key});

  @override
  State<SignUpBirthdayView> createState() => _SignUpBirthdayViewState();
}

class _SignUpBirthdayViewState extends State<SignUpBirthdayView> {
  late SignUpBirthdayController controller;
  final TextEditingController _displayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = SignUpBirthdayController();

    controller.birthdayController.addListener(() {
      _displayController.text =
          _formatDate(controller.birthdayController.text);
    });

    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _displayController.dispose();
    controller.dispose();
    super.dispose();
  }

  String _formatDate(String text) {
    if (text.isEmpty) return '';
    try {
      final date = DateTime.parse(text);
      return '${date.day.toString().padLeft(2, '0')} - '
          '${date.month.toString().padLeft(2, '0')} - '
          '${date.year}';
    } catch (_) {
      return text;
    }
  }

  void _openBirthdayDialog() {
    final currentText = controller.birthdayController.text;
    DateTime initialDate;

    try {
      initialDate = currentText.isEmpty ? DateTime.now() : DateTime.parse(currentText);
    } catch (_) {
      initialDate = DateTime.now();
    }

    showDialog(
      context: context,
      builder: (_) => BirthdayDialog(
        initialDate: initialDate,
        onConfirm: (date) {
          controller.birthdayController.text =
              '${date.year}-'
              '${date.month.toString().padLeft(2, '0')}-'
              '${date.day.toString().padLeft(2, '0')}';
        },
      ),
    );
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
                // Header
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
                      'Select birthday',
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
                  'Select your birthday',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 40.h),

                TextFormField(
                  controller: _displayController,
                  readOnly: true,
                  onTap: _openBirthdayDialog,
                  decoration: InputDecoration(
                    labelText: 'Birthday',
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
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
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
                  ),
                ),
                SizedBox(height: 40.h),

                if (controller.errorMessage.isNotEmpty)
                  BannerError(message: controller.errorMessage),

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
                    onPressed: controller.isLoading
                      ? null
                      : () => controller.goToSignUpGender(context),
                    child: controller.isLoading
                      ? const CircularProgressIndicator(
                        color: Colors.white
                      ) : Text(
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
      ),
    );
  }
}