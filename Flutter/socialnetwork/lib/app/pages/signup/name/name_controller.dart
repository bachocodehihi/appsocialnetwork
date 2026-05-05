import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/app/pages/signup/state/signup.dart';
import 'package:provider/provider.dart';
class SignUpNameController extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();

  String _errorMessage = '';
  bool _isLoading = false;

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  bool validateUsername() {
    final username = usernameController.text.trim();

    if (username.isEmpty) {
      _errorMessage = 'Please enter username!';
      notifyListeners();
      return false;
    }

    if (username.length < 2 || username.length > 40) {
      _errorMessage = 'Username must be 2 - 40 characters!';
      notifyListeners();
      return false;
    }

    if (_containsBadWord(username)) {
      _errorMessage = 'Username is not appropriate!';
      notifyListeners();
      return false;
    }

    _errorMessage = '';
    notifyListeners();
    return true;
  }

  bool _containsBadWord(String input) {
    final text = _normalize(input);

    final bannedWords = ['fuck', 'motherfucker', 'dume', 'concac', 'cailon'];

    for (var word in bannedWords) {
      if (text.contains(word)) return true;
    }

    final patterns = [
      RegExp(r'f+u*c*k+'),
      RegExp(r'd+u*m+e+'),
      RegExp(r'c+a+c+'),
      RegExp(r'l+o+n+'),
    ];

    for (var pattern in patterns) {
      if (pattern.hasMatch(text)) return true;
    }

    return false;
  }

  String _normalize(String input) {
    String text = input.toLowerCase();
    text = _removeVietnameseTones(text);
    text = text.replaceAll(RegExp(r'[^a-z0-9]'), '');
    return text;
  }

  String _removeVietnameseTones(String str) {
    str = str.toLowerCase();
    str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    str = str.replaceAll(RegExp(r'đ'), 'd');
    return str;
  }

  void onContinue(BuildContext context) {
    if (!validateUsername()) return;
    context.read<SignUpProvider>().setName(usernameController.text.trim());
    Navigator.pushNamed(context, Routes.signupBirthday);
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}