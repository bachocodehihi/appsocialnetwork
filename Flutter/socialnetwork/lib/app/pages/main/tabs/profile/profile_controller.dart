import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/data/local/auth_local.dart';
class ProfileController extends ChangeNotifier {

  Map<String, dynamic>? user;

  ProfileController() {
    loadUser();
  }

  Future<void> loadUser() async {
    user = await AuthLocal.getCurrentUser();
    notifyListeners();
  }

  String get username => user?['username'] ?? '';
  String? get avatar => user?['avatar'];
  String get email => user?['email'] ?? '';


  String get dob {
    final raw = user?['dob'];
    if (raw == null || raw.isEmpty) return '';
    try {
      final date = DateTime.parse(raw);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (_) {
      return raw;
    }
  }
  
  String get gender => user?['gender'] ?? '';

    int get friendsCount => user?['stats']?['friendsCount'] ?? 0;
    int get followersCount => user?['stats']?['followersCount'] ?? 0;
    int get followingCount => user?['stats']?['followingCount'] ?? 0;
    int get postCount => user?['stats']?['postCount'] ?? 0;

  void goToFriends(BuildContext context) {
    Navigator.pushNamed(context, Routes.friends);
  }

  void goToFollowing(BuildContext context) {
    Navigator.pushNamed(context, Routes.following);
  }

  void goToFollowers(BuildContext context) {
    Navigator.pushNamed(context, Routes.followers);
  }

  void goToQRCode(BuildContext context) {
    Navigator.pushNamed(context, Routes.qrCode);
  }

}