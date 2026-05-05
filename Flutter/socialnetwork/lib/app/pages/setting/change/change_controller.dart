import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
class ChangeController extends ChangeNotifier {
  void goToActivity(BuildContext context) {
    Navigator.pushNamed(context, Routes.activity);
  }
}