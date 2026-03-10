class UserEntity {
  final String uidName;
  final String? displayName;
  final String role;
  final String ownerUid;
  final Map<String, dynamic>? staff;

  UserEntity({
    required this.uidName,
    required this.role,
    required this.ownerUid,
    this.displayName,
    this.staff,
  });
}