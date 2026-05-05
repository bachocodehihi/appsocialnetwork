import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/widgets/drawer/menu/menu_controller.dart';
class MenuDrawerView extends StatefulWidget {
  const MenuDrawerView({super.key});
  @override
  State<MenuDrawerView> createState() => _MenuDrawerViewState();
}
class _MenuDrawerViewState extends State<MenuDrawerView> {
  late MenuDrawerController controller;

  @override
  void initState() {
    super.initState();
    controller = MenuDrawerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.blue
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40.r,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 10),
                Text(
                  '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.sports_esports_outlined),
            title: const Text('Game'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Setting'),
            onTap: () {
              Navigator.pop(context);
              controller.goToSetting(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_outlined, color: Colors.red),
            title: const Text('Log out', style: TextStyle(color: Colors.red)),
            onTap: () {
              controller.logout(context);
            },
          ),
        ],
      ),
    );
  }
}