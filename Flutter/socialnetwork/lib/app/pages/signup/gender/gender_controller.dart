import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/app/pages/signup/state/signup.dart';
import 'package:provider/provider.dart';
class SignUpGenderController extends ChangeNotifier {
  final TextEditingController genderController = TextEditingController();

  String _errorMessage = '';
  bool _isLoading = false;

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  bool validateGender() {
    final genderText = genderController.text.trim();

    if (genderText.isEmpty) {
      _errorMessage = 'Please select gender!';
      notifyListeners();
      return false;
    }
    
    _errorMessage = '';
    notifyListeners();
    return true;
  }

  void goToSignUpAvatar(BuildContext context) async {
    if (!validateGender()) return;
    
    context.read<SignUpProvider>().setGender(genderController.text.trim());
    Navigator.pushNamed(context, Routes.signupAvatar);
  }

  @override
  void dispose() {
    genderController.dispose();
    super.dispose();
  }
}
