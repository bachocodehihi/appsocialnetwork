import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
class ForgetPasswordController extends ChangeNotifier {
  
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController comfirmpasswordController = TextEditingController();

  String _errorMessage = '';
  bool _isLoading = false;

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  bool validatePassword() {
    final password = passwordController.text.trim();

    final comfirmpassword = comfirmpasswordController.text.trim();

    if (password.isEmpty) {
      _errorMessage = 'Please enter password!';
      notifyListeners();
      return false;
    }

    if (comfirmpassword.isEmpty) {
      _errorMessage = 'Please enter comfirm password!';
      notifyListeners();
      return false;
    }

    if (password.length < 8) {
      _errorMessage = 'Password must be at least 8 characters!';
      notifyListeners();
      return false;
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).+$',
    );

    if (!passwordRegex.hasMatch(password)) {
      _errorMessage =
          'Password must include uppercase, lowercase, number and special character!';
      notifyListeners();
      return false;
    }

    if (password != comfirmpassword) {
      _errorMessage = 'Passwords do not match!';
      notifyListeners();
      return false;
    }

    _errorMessage = '';
    notifyListeners();
    return true;
  }
  void goToSignInPassword(BuildContext context) {
    Navigator.pushNamed(context, Routes.signinPassword);
  }
}
