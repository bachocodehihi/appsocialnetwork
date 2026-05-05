import 'package:flutter/material.dart';
import 'package:socialnetwork/app/providers/app_provider.dart';
import 'package:provider/provider.dart';

class DarkmodeController {
  void toggleDarkMode(BuildContext context, bool value) {
    context.read<AppProvider>().setDarkMode(value);
  }
}