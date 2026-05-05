import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/domain/usecases/auth/auth_usecase.dart';
import 'package:socialnetwork/app/pages/signup/state/signup.dart';
import 'package:provider/provider.dart';
class ForgetController extends ChangeNotifier {

  final AuthUsecase _authUsecase;
  ForgetController(this._authUsecase);

  final emailController = TextEditingController();

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

  void goToVerifySignUp(BuildContext context) async {
    if (!validateEmail()) return;

    final email = emailController.text.trim();

    _isLoading = true;
    notifyListeners();
    
    try {
      await _authUsecase.sendOtp(email);
      if (context.mounted) {
        context.read<SignUpProvider>().setEmail(email);
        Navigator.pushNamed(
          context,
          Routes.verifySignUp,
          arguments: {'email': email},
        );
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
