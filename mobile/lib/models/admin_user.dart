class AdminUser {
  const AdminUser({
    required this.id,
    required this.email,
    required this.isActive,
    required this.isSuperuser,
    required this.isVerified,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
        id: json['id'] as String,
        email: json['email'] as String,
        isActive: json['is_active'] as bool? ?? true,
        isSuperuser: json['is_superuser'] as bool? ?? false,
        isVerified: json['is_verified'] as bool? ?? false,
      );

  final String id;
  final String email;
  final bool isActive;
  final bool isSuperuser;
  final bool isVerified;
}
