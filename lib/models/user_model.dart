enum UserRole { student, teacher }

class AppUser {
  const AppUser({
    required this.email,
    required this.role,
    this.isVerified = false,
  });

  final String email;
  final UserRole role;
  final bool isVerified;
}
