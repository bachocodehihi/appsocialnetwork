import 'package:dio/dio.dart';
import 'package:socialnetwork/data/local/auth_local.dart';
class AccountApi {
  final Dio _dio;
  AccountApi(this._dio);

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      final token = await AuthLocal.getToken();
      
      final response = await _dio.get(
        '/api/account/search',
        queryParameters: {'q': query},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {

        final data = response.data;
        
        if (data == null) {
          return [];
        }
        
        if (data is List) {
          return data.map((item) {
            if (item is Map<String, dynamic>) {
              return item;
            } else if (item is Map) {
              return Map<String, dynamic>.from(item);
            }
            return <String, dynamic>{};
          }).toList();
        } else if (data is Map<String, dynamic>) {

          if (data.containsKey('users') && data['users'] is List) {
            final users = data['users'] as List;
            return users.map((item) => Map<String, dynamic>.from(item)).toList();
          }

          if (data.containsKey('data') && data['data'] is List) {
            final dataList = data['data'] as List;
            return dataList.map((item) => Map<String, dynamic>.from(item)).toList();
          }
          return [];
        }
        
        return [];
      } else {
        final message = response.data is Map 
            ? (response.data['message'] ?? 'Search failed') 
            : 'Search failed';
        throw Exception(message);
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error occurred');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

}