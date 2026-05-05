import 'package:socialnetwork/domain/repositories/account/account_repository.dart';

class AccountUsecase {
  final AccountRepository _repository;
  AccountUsecase(this._repository);
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await _repository.searchUsers(query.trim());
  }
}