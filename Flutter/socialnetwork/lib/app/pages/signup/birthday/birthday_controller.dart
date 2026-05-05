import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/app/pages/signup/state/signup.dart';
import 'package:provider/provider.dart';
class SignUpBirthdayController extends ChangeNotifier {
  final TextEditingController birthdayController = TextEditingController();

  String _errorMessage = '';
  bool _isLoading = false;

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  bool validateBirthday() {
    final birthdayText = birthdayController.text.trim();

    if (birthdayText.isEmpty) {
      _errorMessage = 'Please select birthday!';
      notifyListeners();
      return false;
    }

    try {
      final birthday = DateTime.parse(birthdayText);
      final today = DateTime.now();

      int age = today.year - birthday.year;
      if (today.month < birthday.month ||
          (today.month == birthday.month && today.day < birthday.day)) {
        age--;
      }

      if (age < 14) {
        _errorMessage = 'You must be at least 14 years old!';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Invalid date format!';
      notifyListeners();
      return false;
    }

    _errorMessage = '';
    notifyListeners();
    return true;
  }

  void goToSignUpGender(BuildContext context) {
    if (!validateBirthday()) return;
    context.read<SignUpProvider>().setBirthday(birthdayController.text.trim());
    Navigator.pushNamed(context, Routes.signupGender);
  }

  @override
  void dispose() {
    birthdayController.dispose();
    super.dispose();
  }
}