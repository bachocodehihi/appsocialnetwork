import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';

class AddController extends ChangeNotifier {

  void goToAddAddress(BuildContext context) {
    Navigator.pushNamed(context, Routes.addAddress);
  }

  void goToAddJob(BuildContext context) {
    Navigator.pushNamed(context, Routes.addJob);
  }

  void goToAddPhone(BuildContext context) {
    Navigator.pushNamed(context, Routes.addPhone);
  }

}