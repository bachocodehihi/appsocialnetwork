import 'package:socialnetwork/domain/repositories/group/group_repository.dart';

class GroupUsecase {
  final GroupRepository _repository;
  GroupUsecase(this._repository);

  Future<Map<String, dynamic>> createGroup({
    required String name,
    required List<String> members,
  }) async {
    if (name.trim().isEmpty) throw Exception('Tên nhóm không được để trống');
    if (members.length < 2) throw Exception('Nhóm cần ít nhất 3 người');
    return _repository.createGroup(name: name, members: members);
  }

  Future<List<Map<String, dynamic>>> getGroups() async {
    return _repository.getGroups();
  }
}