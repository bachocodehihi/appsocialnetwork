import 'package:flutter/material.dart';
import 'package:socialnetwork/domain/usecases/contact/contact_usecase.dart';
class ContactFriendController extends ChangeNotifier {
  final ContactUsecase _usecase;
  List<Map<String, dynamic>> _friends = [];
  bool _isLoading = false;
  String? _error;

  ContactFriendController(this._usecase);

  List<Map<String, dynamic>> get friends => _friends;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFriends() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _usecase.getFriends();
      _friends = data.map((item) => {
        'name': item['username'] ?? item['name'] ?? 'Unknown',
        'status': 'Online',
        'avatar': item['avatar'],
        'id': item['_id'] ?? item['id'],
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}