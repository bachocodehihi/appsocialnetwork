abstract class AccountRepository {
  Future<List<Map<String, dynamic>>> searchUsers(String query);
}