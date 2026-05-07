import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/data/local/auth_local.dart';
import 'package:socialnetwork/domain/usecases/account_usecase.dart';
import 'package:socialnetwork/data/repositories/account_repository_imp.dart';
import 'package:socialnetwork/data/network/api/account_api.dart';
import 'package:socialnetwork/data/network/dio_client.dart';
class ProfileController extends ChangeNotifier {

  Map<String, dynamic>? user;

  late final AccountUsecase _accountUsecase;

  // ProfileController() {
  //   loadUser();
  // }

  ProfileController() {
    _accountUsecase = AccountUsecase(
      AccountRepositoryImp(
        AccountApi(DioClient.createDio()),
      ),
    );
    loadUser();
  }

  // Future<void> loadUser() async {
  //   user = await AuthLocal.getCurrentUser();
  //   notifyListeners();
  // }

  Future<void> loadUser() async {
    user = await AuthLocal.getCurrentUser();
    notifyListeners();

    try {
      final freshUser = await _accountUsecase.getProfile();
      user = freshUser;
      await AuthLocal.saveUser(freshUser);
      notifyListeners();
    } catch (_) {}
  }

  int get friendsCount => user?['stats']?['friendsCount'] ?? 0;
  int get followersCount => user?['stats']?['followersCount'] ?? 0;
  int get followingCount => user?['stats']?['followingCount'] ?? 0;
  int get postCount => user?['stats']?['postCount'] ?? 0;

  String get username => user?['username'] ?? '';
  String get avatar => user?['avatar'];
  String get email => user?['email'] ?? '';


  String get dob {
    final raw = user?['dob'];
    if (raw == null || raw.isEmpty) return '';
    try {
      final date = DateTime.parse(raw);
      return '${date.day.toString().padLeft(2, '0')} - ${date.month.toString().padLeft(2, '0')} - ${date.year}';
    } catch (_) {
      return raw;
    }
  }
  
  String get gender => user?['gender'] ?? '';

  String get address => user?['address'] ?? '';
  String get phone => user?['phone'] ?? '';
  String get job => user?['job'] ?? '';
  String get nationality => user?['nationality'] ?? '';

  void goToFriends(BuildContext context) {
    Navigator.pushNamed(context, Routes.friend);
  }

  void goToFollowing(BuildContext context) {
    Navigator.pushNamed(context, Routes.following);
  }

  void goToFollowers(BuildContext context) {
    Navigator.pushNamed(context, Routes.follower);
  }

  void goToQRCode(BuildContext context) {
    Navigator.pushNamed(context, Routes.code);
  }

  void goToAdd(BuildContext context) {
    Navigator.pushNamed(context, Routes.add);
  }

}