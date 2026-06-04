class AuthService {
  Future<bool> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return email.trim().isNotEmpty && password.trim().isNotEmpty;
  }

  Future<void> sendVerificationEmail(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}
