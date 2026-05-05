import 'package:socialnetwork/domain/repositories/auth/auth_repository.dart';

class AuthUsecase {
  final AuthRepository _repository;
  AuthUsecase(this._repository);

  Future<void> sendOtp(String email) => _repository.sendOtp(email);

  Future<void> verifyOtp(String email, String otp) =>
      _repository.verifyOtp(email, otp);

  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String dob,
    required String gender,
    String? avatar,
  }) => _repository.register(
    email: email,
    username: username,
    password: password,
    dob: dob,
    gender: gender,
    avatar: avatar,
  );

  Future<bool> checkEmail(String email) => _repository.checkEmail(email);

  Future<void> login({required String email, required String password}) =>
    _repository.login(email: email, password: password);
}