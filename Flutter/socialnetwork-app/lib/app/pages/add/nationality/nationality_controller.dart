import 'package:flutter/material.dart';
import 'package:socialnetwork/domain/usecases/account_usecase.dart';
import 'package:socialnetwork/app/widgets/dialog/alert.dart';
class AddNationalityController extends ChangeNotifier {
  final AccountUsecase _accountUsecase;

  AddNationalityController(this._accountUsecase);

  final nationalityController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  static const _messages = {
    'ADDRESS_ADD_SUCCESS': 'Add address successfully!',
    'SERVER_ERROR': 'Server error, please try again!',
  };

  String _getErrorMessage(String code) {
    return _messages[code] ?? code;
  }

  bool validateNationality() {
    final nationality = nationalityController.text.trim();

    if (nationality.isEmpty) {
      _errorMessage = 'Please enter address!';
      notifyListeners();
      return false;
    }

    _errorMessage = '';
    notifyListeners();
    return true;
  }

  Future<void> addNationality(BuildContext context) async {
    if (!validateNationality()) return;

    final nationality = nationalityController.text.trim();

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _accountUsecase.addNationality(nationality);
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => AppAlertDialog(
            icon: Icons.check_outlined,
            iconColor: Colors.green,
            message: _messages['ADDRESS_ADD_SUCCESS']!,
          ),
        );
        if (context.mounted) {
          Navigator.pop(context, true);
        }
      }

    } catch (e) {
      final code = e.toString().replaceAll('Exception: ', '');
      _errorMessage = _getErrorMessage(code);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nationalityController.dispose();
    super.dispose();
  }

}
