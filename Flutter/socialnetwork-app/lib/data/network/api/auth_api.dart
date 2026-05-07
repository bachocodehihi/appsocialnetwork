import 'package:dio/dio.dart';
class AuthApi {
  final Dio _dio;
  AuthApi(this._dio);

  Future<Response> sendOtp(String email) async {
    return await _dio.post('/api/auth/send-otp', data: {'email': email});
  }
  
  Future<Response> verifyOtp(String email, String otp) async {
    return await _dio.post(
      '/api/auth/verify-otp',
      data: {
        'email': email,
        'otp': otp,
      },
    );
  }

  Future<Response> register({
    required String email,
    required String username,
    required String password,
    required String dob,
    required String gender,
    String? avatar,
  }) async {
    return await _dio.post('/api/auth/register', data: {
      'email': email,
      'username': username,
      'password': password,
      'dob': dob,
      'gender': gender,
      if (avatar != null) 'avatar': avatar,
    });
  }

  Future<Response> checkEmail(String email) async {
    return await _dio.post('/api/auth/check-email', data: {'email': email});
  }

  Future<Response> login({required String email, required String password}) async {
    return await _dio.post('/api/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> forgotPassword({required String email, required String newPassword}) async {
    return await _dio.post('/api/auth/forgot-password', data: {
      'email': email,
      'newPassword': newPassword,
    });
  }
}