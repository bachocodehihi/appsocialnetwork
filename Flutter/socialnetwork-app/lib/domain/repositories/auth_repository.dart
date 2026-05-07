abstract class AuthRepository {
  
  Future<void> sendOtp(String email);

  Future<void> verifyOtp(String email, String otp);

  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String dob,
    required String gender,
    String? avatar,
  });
  Future<bool> checkEmail(String email);

  Future<void> login({required String email, required String password});

  Future<void> forgotPassword({
    required String email,
    required String newPassword,
  });
}