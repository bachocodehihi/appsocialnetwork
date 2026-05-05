import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
class AccountController extends ChangeNotifier {
  void goToChange(BuildContext context) {
    Navigator.pushNamed(context, Routes.change);
  }

}