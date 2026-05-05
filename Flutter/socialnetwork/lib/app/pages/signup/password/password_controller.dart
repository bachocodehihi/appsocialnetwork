import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/app/pages/signup/state/signup.dart';
import 'package:provider/provider.dart';
import 'package:socialnetwork/domain/usecases/auth/auth_usecase.dart';
import 'package:socialnetwork/app/widgets/dialog/alert.dart';
class SignUpPasswordController extends ChangeNotifier {

  final AuthUsecase _authUsecase;
  SignUpPasswordController(this._authUsecase);
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

  void goToWelcome(BuildContext context) async {
    if (!validatePassword()) return;

    final provider = context.read<SignUpProvider>();
    provider.setPassword(passwordController.text.trim());

    _isLoading = true;
    notifyListeners();
    try {
      await _authUsecase.register(
        email: provider.data.email!,
        username: provider.data.name!,
        password: provider.data.password!,
        dob: provider.data.birthday!,
        gender: provider.data.gender!,
        avatar: provider.data.avatar,
      );
      if (context.mounted) {
        provider.clear();
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => AppAlertDialog(
            icon: Icons.check_circle_outline_outlined,
            iconColor: Colors.green,
            message: 'Account created successfully!',
          ),
        ).then((_) {
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.wellcome,
            (route) => false,
          );
          }
        });
      }
      } catch (e) {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        notifyListeners();
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AppAlertDialog(
              icon: Icons.close_outlined,
              iconColor: Colors.red,
              message: 'Account created failed!',
            ),
          );
        }
      } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    comfirmpasswordController.dispose();
    super.dispose();
  }

}
