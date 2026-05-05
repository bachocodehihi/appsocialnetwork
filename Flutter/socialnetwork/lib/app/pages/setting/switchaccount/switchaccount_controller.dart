import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/domain/usecases/auth/auth_usecase.dart';
class SwitchAccountController extends ChangeNotifier {

  final TextEditingController passwordController = TextEditingController();
  final String email;
  final AuthUsecase _authUsecase;

  SwitchAccountController(this._authUsecase, {required this.email});

  String _errorMessage = '';
  bool _isLoading = false;

  bool _obscurePassword = true;

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool validatePassword() {
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      _errorMessage = 'Please enter password!';
      notifyListeners();
      return false;
    }
    if (password.length < 8) {
      _errorMessage = 'Password must be at least 8 characters!';
      notifyListeners();
      return false;
    }

    _errorMessage = '';
    notifyListeners();
    return true;
  }

  void submit(BuildContext context) async {
    if (!validatePassword()) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _authUsecase.login(email: email, password: passwordController.text.trim());

      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, Routes.main, (route) => false);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void goToForget(BuildContext context) {
    Navigator.pushNamed(context, Routes.forgot);
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
