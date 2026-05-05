import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
class HomeController extends ChangeNotifier {
  void goToSearch(BuildContext context) {
    Navigator.pushNamed(context, Routes.search);
  }

  void goToScanner(BuildContext context) {
    Navigator.pushNamed(context, Routes.scanner);
  }
}