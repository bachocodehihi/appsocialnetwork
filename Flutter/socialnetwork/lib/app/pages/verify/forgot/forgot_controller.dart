import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
class VerifyForgetController extends ChangeNotifier {
  void goToForgetPassword(BuildContext context) {
    Navigator.pushNamed(context, Routes.forgetPassword);
  }
}
