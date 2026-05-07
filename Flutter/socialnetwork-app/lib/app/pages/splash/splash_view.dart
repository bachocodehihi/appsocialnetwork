import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialnetwork/app/pages/splash/splash_controller.dart';
import 'package:socialnetwork/app/routes/routes.dart';
class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}
class _SplashViewState extends State<SplashView> {
  final controller = SplashController();
  @override
  void initState() {
    super.initState();
    controller.init((isLoggedIn) {
      if (!mounted) return;
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, Routes.main);
      } else {
        Navigator.pushReplacementNamed(context, Routes.wellcome);
      }
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: ValueListenableBuilder<bool>(
              valueListenable: controller.showLogo,
              builder: (context, showLogo, _) {
                return AnimatedOpacity(
                  opacity: showLogo ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo/logo.png', width: 100),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}