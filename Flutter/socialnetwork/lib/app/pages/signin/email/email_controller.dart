import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/domain/usecases/auth/auth_usecase.dart';
class SignInEmailController extends ChangeNotifier {

  final TextEditingController emailController = TextEditingController();

  final AuthUsecase _authUsecase;

  SignInEmailController(this._authUsecase);

  bool _isLoading = false;
  String _errorMessage = '';

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  
  bool validateEmail() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _errorMessage = 'Please enter email!';
      notifyListeners();
      return false;
    }

    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _errorMessage = 'Invalid email!';
      notifyListeners();
      return false;
    }

    _errorMessage = '';
    notifyListeners();
    return true;
  }

  void submit(BuildContext context) async {
    if (!validateEmail()) return;

    final email = emailController.text.trim();

    _isLoading = true;
    notifyListeners();

    try {
      await _authUsecase.checkEmail(email);

      if (!context.mounted) return;

      Navigator.pushNamed(
        context,
        Routes.signinPassword,
        arguments: {'email': email},
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
