import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/data/local/auth_local.dart';
class MenuDrawerController extends ChangeNotifier {

  Map<String, dynamic>? user;

  MenuDrawerController() {
    loadUser();
  }

  Future<void> loadUser() async {
    user = await AuthLocal.getCurrentUser();
    notifyListeners();
  }
  
  String get username => user?['username'] ?? '';
  String get avatar => user?['avatar'] ?? '';

  void logout(BuildContext context) async {
    await AuthLocal.logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.wellcome,
      (route) => false,
    );
  }

  void goToSetting(BuildContext context) {
    Navigator.pushNamed(context, Routes.setting);
  }

  @override
  void dispose() {
    user = null;
    super.dispose();
  }

}

  