abstract class GroupRepository {
  Future<Map<String, dynamic>> createGroup({
    required String name,
    required List<String> members,
  });

  Future<List<Map<String, dynamic>>> getGroups();
}