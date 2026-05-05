import 'package:socialnetwork/data/network/api/auth_api.dart';
import 'package:socialnetwork/domain/repositories/auth/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:socialnetwork/data/local/auth_local.dart';
class AuthRepositoryImp implements AuthRepository {
  final AuthApi _authApi;
  AuthRepositoryImp(this._authApi);

  String _getMessage(Response response, String fallback) {
    final data = response.data;
    if (data is Map) {
      return data['message']?.toString() ?? fallback;
    }
    return fallback;
  }

  @override
  Future<void> sendOtp(String email) async {
    try {
      final response = await _authApi.sendOtp(email);
      if (response.statusCode != 200) {
        throw Exception(_getMessage(response, 'Something went wrong!'));
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Cannot connect to server!');
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response = await _authApi.verifyOtp(email, otp);
      if (response.statusCode != 200) {
        throw Exception(_getMessage(response, 'Verification failed!'));
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Cannot connect to server!');
    }
  }

  @override
  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String dob,
    required String gender,
    String? avatar,
  }) async {
    try {
      final response = await _authApi.register(
        email: email,
        username: username,
        password: password,
        dob: dob,
        gender: gender,
        avatar: avatar,
      );
      if (response.statusCode != 201) {
        throw Exception(_getMessage(response, 'Registration failed!'));
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Cannot connect to server!');
    }
  }

  @override
  Future<bool> checkEmail(String email) async {
    try {
      final response = await _authApi.checkEmail(email);

      if (response.statusCode == 200) {
        return  true;
      }

      if (response.statusCode == 404) {
        throw Exception(_getMessage(response, 'Email does not exist'));
      }

      throw Exception(_getMessage(response, 'Something went wrong!'));
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Cannot connect to server!');
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _authApi.login(email: email, password: password);
      if (response.statusCode != 200) {
        throw Exception(_getMessage(response, 'Login failed!'));
      }
      final token = response.data['token']?.toString() ?? '';
      final user = response.data['user'] as Map<String, dynamic>;
      await AuthLocal.saveLogin(token, email, user);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Cannot connect to server!');
    }
  }
}