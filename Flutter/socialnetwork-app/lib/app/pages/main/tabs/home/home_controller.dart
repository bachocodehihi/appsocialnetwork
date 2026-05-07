import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/data/local/auth_local.dart';
class HomeController extends ChangeNotifier {

  Map<String, dynamic>? user;

  HomeController() {
    loadUser();
  }

  Future<void> loadUser() async {
    user = await AuthLocal.getCurrentUser();
    notifyListeners();
  }

  String get avatar => user?['avatar'] ?? '';

  void goToSearch(BuildContext context) {
    Navigator.pushNamed(context, Routes.search);
  }

  void goToScanner(BuildContext context) {
    Navigator.pushNamed(context, Routes.scanner);
  }


}