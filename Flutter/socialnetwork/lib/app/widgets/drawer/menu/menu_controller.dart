import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/data/local/auth_local.dart';
class MenuDrawerController extends ChangeNotifier {

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

}

  