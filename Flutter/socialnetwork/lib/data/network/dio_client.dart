import 'package:dio/dio.dart';
import 'package:socialnetwork/data/ip/ip.dart'; 
class DioClient {
  static Dio createDio() {
    final baseUrl = 'http://${IpConfig.currentIp}:5001';
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => true,
      ),
    );

    return dio;
  }
}