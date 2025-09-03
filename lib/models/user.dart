import 'package:somos_qr_plus/models/role.dart';

class User {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool isStaff;
  final bool isSuperuser;
  final DateTime? lastLogin;
  final DateTime? dateJoined;
  final List<Role> roles;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.isStaff,
    required this.isSuperuser,
    this.lastLogin,
    this.dateJoined,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      isActive: json['is_active'],
      isStaff: json['is_staff'],
      isSuperuser: json['is_superuser'],
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
      dateJoined: json['date_joined'] != null
          ? DateTime.parse(json['date_joined'])
          : null,
      roles: (json['roles'] as List<dynamic>)
          .map((role) => Role.fromJson(role))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'is_active': isActive,
      'is_staff': isStaff,
      'is_superuser': isSuperuser,
      'last_login': lastLogin?.toIso8601String(),
      'date_joined': dateJoined?.toIso8601String(),
      'roles': roles.map((r) => r.toJson()).toList(),
    };
  }
}
