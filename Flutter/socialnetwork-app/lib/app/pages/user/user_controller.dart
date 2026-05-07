import 'package:flutter/material.dart';
import 'package:socialnetwork/data/network/api/contact_api.dart';
import 'package:socialnetwork/data/network/dio_client.dart';
import 'package:socialnetwork/data/repositories/contact_repository_imp.dart';
import 'package:socialnetwork/domain/usecases/contact_usecase.dart';
import 'package:socialnetwork/data/enums/friend_status.dart';
class UserController extends ChangeNotifier {
  Map<String, dynamic> _user;
  late final ContactUsecase _contactUsecase;

  FriendStatus _status = FriendStatus.none;
  String? _requestId;
  bool _loading = false;

  UserController({
    required Map<String, dynamic> user,
    ContactUsecase? contactUsecase,
  }) : _user = user {
    _contactUsecase = contactUsecase ??
        ContactUsecase(
          ContactRepositoryImp(
            ContactApi(DioClient.createDio()),
          ),
        );

    loadRelationship();
  }

  String get userId => _user['_id'] ?? _user['id'] ?? '';
  String get username => _user['username'] ?? 'Unknown';
  String get avatarUrl => _user['avatar'] ?? '';
    String get email => _user['email'] as String? ?? '';
  String get avatar => _user['avatar'] as String? ?? '';
  String get birthday => _user['birthday'] as String? ?? _user['dob'] as String? ?? '';
  String get gender => _user['gender'] as String? ?? '';
  String get address => _user['address'] as String? ?? '';
  String get phone => _user['phone'] as String? ?? _user['phone_number'] as String? ?? '';
  String get job => _user['job'] as String? ?? _user['occupation'] as String? ?? '';

  int get friendsCount => _user['friendsCount'] as int? ?? 0;
  int get followersCount => _user['followersCount'] as int? ?? 0;
  int get followingCount => _user['followingCount'] as int? ?? 0;
  int get postCount => _user['postCount'] as int? ?? 0;

  FriendStatus get status => _status;
  String? get requestId => _requestId;
  bool get loading => _loading;

  Future<void> loadRelationship() async {
    try {
      final res = await _contactUsecase.getRelationship(userId);

      switch (res['status']) {
        case 'requested':
          _requestId = res['requestId'];
          _status = FriendStatus.requested;
          break;
        case 'received':
          _status = FriendStatus.received;
          _requestId = res['requestId'];
          break;
        case 'friend':
          _status = FriendStatus.friend;
          break;
        default:
          _status = FriendStatus.none;
      }

      notifyListeners();
    } catch (_) {}
  }

  Future<void> sendFriendRequest() async {
    if (_loading) return;

    _loading = true;
    notifyListeners();

    try {
      final res = await _contactUsecase.sendRequest(userId);

      if (res['type'] == 'auto_accepted') {
        _status = FriendStatus.friend;
      } else {
        _status = FriendStatus.requested;
        _requestId = res['requestId'];
      }
    } catch (_) {}

    _loading = false;
    notifyListeners();
  }

  Future<void> cancelFriendRequest() async {
    if (_loading || _requestId == null) return;

    _loading = true;
    notifyListeners();

    await _contactUsecase.cancelRequest(_requestId!);

    _status = FriendStatus.none;
    _requestId = null;

    _loading = false;
    notifyListeners();
  }

  Future<void> acceptRequest() async {
    if (_loading || _requestId == null) return;

    _loading = true;
    notifyListeners();

    await _contactUsecase.acceptRequest(_requestId!);

    _status = FriendStatus.friend;

    _loading = false;
    notifyListeners();
  }

  Future<void> rejectRequest() async {
    if (_loading || _requestId == null) return;

    _loading = true;
    notifyListeners();

    await _contactUsecase.rejectRequest(_requestId!);

    _status = FriendStatus.none;
    _requestId = null;

    _loading = false;
    notifyListeners();
  }

  Future<void> unfriend() async {
    if (_loading) return;

    _loading = true;
    notifyListeners();

    try {
      await _contactUsecase.removeFriend(userId);

      _status = FriendStatus.none;
      _requestId = null;
    } catch (_) {}

    _loading = false;
    notifyListeners();
  }
}