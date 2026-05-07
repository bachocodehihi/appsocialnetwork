import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/main/tabs/home/home_page.dart';
import 'package:socialnetwork/app/pages/main/tabs/message/message_page.dart';
import 'package:socialnetwork/app/pages/main/tabs/contact/contact_page.dart';
import 'package:socialnetwork/app/pages/main/tabs/notification/notification_page.dart';
import 'package:socialnetwork/app/pages/main/tabs/profile/profile_page.dart';
import 'package:socialnetwork/app/pages/main/main_controller.dart';
import 'package:socialnetwork/app/widgets/drawer/menu/menu_view.dart';
class MainView extends StatelessWidget {
  final int initialIndex;
  const MainView({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainController(initialIndex: initialIndex),
      child: const _MainViewState(),
    );
  }
  
}
class _MainViewState extends StatelessWidget {
  const _MainViewState();
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final pages = [
      const HomePage(),
      const MessagePage(),
      const ContactPage(),
      const NotificationPage(),
      const ProfilePage(),
    ];
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: cs.surface,
      drawer: const MenuDrawerView(),
      body: Consumer<MainController>(
        builder: (context, controller, _) => IndexedStack(
          index: controller.currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.12),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Consumer<MainController>(
          builder: (context, controller, _) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home_outlined, "Home", 0),
              _buildNavItem(context, Icons.message_outlined, "Message", 1),
              _buildNavItem(context, Icons.people_outline_outlined, "Contact", 2),
              _buildNavItem(context, Icons.notifications_outlined, "Notification", 3),
              _buildNavItem(context, Icons.person_outlined, "Profile", 4),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final controller = context.read<MainController>();
    final isActive = context.watch<MainController>().currentIndex == index;
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isActive ? Colors.blue : Colors.grey,
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.grey,
                fontSize: 12.sp,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
              ),
              child: Text(label),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: isActive ? 20 : 0,
              color: cs.primary,
            ),
          ],
        ),
      ),
    );
  }
  
}