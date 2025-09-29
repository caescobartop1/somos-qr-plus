class StaffLogin {
  final int id;
  final String fullName;
  final String practiceName;
  final int userId;
  final String userUsername;
  final String userFirstName;
  final String userLastName;
  final String userEmail;
  final bool userIsActive;
  final bool userIsStaff;
  final DateTime? userLastLogin;
  final DateTime? userDateJoined;
  final bool userIsSuperuser;
  final bool userIsVerified;
  final String roleName;
  final bool isVerified;

  StaffLogin({
    required this.id,
    required this.fullName,
    required this.practiceName,
    required this.userId,
    required this.userUsername,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    required this.userIsActive,
    required this.userIsStaff,
    required this.userLastLogin,
    required this.userDateJoined,
    required this.userIsSuperuser,
    required this.userIsVerified,
    required this.roleName,
    required this.isVerified,
  });

  factory StaffLogin.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    final role = json['role'] ?? {};
    final practice = json['practice'] ?? {};

    DateTime? parseDate(dynamic v) =>
        v != null ? DateTime.tryParse(v.toString()) : null;

    return StaffLogin(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      practiceName: practice['name'] ?? '',
      userId: user['id'] ?? 0,
      userUsername: user['username'] ?? '',
      userFirstName: user['first_name'] ?? '',
      userLastName: user['last_name'] ?? '',
      userEmail: user['email'] ?? '',
      userIsActive: user['is_active'] ?? false,
      userIsStaff: user['is_staff'] ?? false,
      userLastLogin: parseDate(user['last_login']),
      userDateJoined: parseDate(user['date_joined']),
      userIsSuperuser: user['is_superuser'] ?? false,
      userIsVerified: user['is_verified'] ?? false,
      roleName: role['name'] ?? '',
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'practice_name': practiceName,
        'user_id': userId,
        'user_username': userUsername,
        'user_first_name': userFirstName,
        'user_last_name': userLastName,
        'user_email': userEmail,
        'user_is_active': userIsActive,
        'user_is_staff': userIsStaff,
        'user_last_login': userLastLogin?.toIso8601String(),
        'user_date_joined': userDateJoined?.toIso8601String(),
        'user_is_superuser': userIsSuperuser,
        'user_is_verified': userIsVerified,
        'role_name': roleName,
        'is_verified': isVerified,
      };
}
