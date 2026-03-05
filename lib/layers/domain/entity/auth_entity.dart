class AuthEntity {
  final String uidName;
  final String role;
  final String? displayName;

  AuthEntity({
    required this.uidName,
    required this.role,
    this.displayName,
  });
}