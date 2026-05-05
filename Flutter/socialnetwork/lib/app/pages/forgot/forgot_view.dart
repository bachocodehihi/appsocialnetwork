import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/forgot/forgot_controller.dart';
import 'package:socialnetwork/domain/usecases/auth/auth_usecase.dart';
import 'package:socialnetwork/data/repositories/auth_repository_imp.dart';
import 'package:socialnetwork/data/network/api/auth_api.dart';
import 'package:socialnetwork/data/network/dio_client.dart';
import 'package:socialnetwork/app/widgets/banner/error.dart';
class ForgetView extends StatefulWidget {
  const ForgetView({super.key});
  @override
  State<ForgetView> createState() => _ForgetViewState();
}
class _ForgetViewState extends State<ForgetView> {

  late ForgetController controller;

  @override
  void initState() {
    super.initState();
    controller = ForgetController(
      AuthUsecase(
        AuthRepositoryImp(
          AuthApi(DioClient.createDio()),
        ),
      ),
    );
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                    'Forget password',
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
                'Enter your email',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 40.h),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
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
                ),
              ),
              SizedBox(height: 40.h),
              if (controller.errorMessage.isNotEmpty)
                BannerError(message: controller.errorMessage),
              SizedBox(height: 10.h),
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
                  child: controller.isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(
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
