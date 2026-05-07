import 'package:dio/dio.dart';
import 'package:socialnetwork/data/local/auth_local.dart';
class GroupApi {
  final Dio _dio;
  GroupApi(this._dio);

  Future<Response> createGroup({
    required String name,
    required List<String> members,
  }) async {
    final token = await AuthLocal.getToken();
    return _dio.post(
      '/api/groups',
      data: {'name': name, 'members': members},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<Response> getGroups() async {
    final token = await AuthLocal.getToken();
    return _dio.get(
      '/api/groups',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}