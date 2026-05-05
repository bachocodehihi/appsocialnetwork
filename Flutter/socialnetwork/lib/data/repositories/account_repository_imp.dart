import 'package:socialnetwork/data/network/api/account_api.dart';
import 'package:socialnetwork/domain/repositories/account/account_repository.dart';
class AccountRepositoryImp implements AccountRepository {
  final AccountApi _accountApi;

  AccountRepositoryImp(this._accountApi);

  @override
  Future<List<Map<String, dynamic>>> searchUsers(String query) {
    return _accountApi.searchUsers(query);
  }

}