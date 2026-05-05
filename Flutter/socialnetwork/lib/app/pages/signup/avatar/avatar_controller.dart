import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/app/pages/signup/state/signup.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
class SignUpAvatarController extends ChangeNotifier {

  XFile? pickedImage;
  String? avatarBase64;
  String _errorMessage = '';
  bool _isLoading = false;
  
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        pickedImage = image;
        avatarBase64 = base64Encode(bytes);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Không thể chọn ảnh. Vui lòng thử lại.';
      notifyListeners();
    }
  }

  void onContinue(BuildContext context) {
    if (avatarBase64 != null) {
      context.read<SignUpProvider>().setAvatar(avatarBase64!);
    }
    Navigator.pushNamed(context, Routes.signupPassword);
  }

}