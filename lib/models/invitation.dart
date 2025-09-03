import 'package:somos_qr_plus/models/practice.dart';

class Invitation {
  final int id;
  final String requestNumber;
  final int roleId;
  final String email;
  final String firstName;
  final String lastName;
  final bool deliveredEmail;
  final String phoneNumber;
  final String npi; // viene como string (puede ser "")
  final String requestType;
  final int requestingUserId;
  final int? userId; // puede ser null
  final String status;
  final DateTime created;
  final DateTime modified;
  final List<String> practiceNames;
  final List<Practice> practices;

  Invitation({
    required this.id,
    required this.requestNumber,
    required this.roleId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.deliveredEmail,
    required this.phoneNumber,
    required this.npi,
    required this.requestType,
    required this.requestingUserId,
    this.userId,
    required this.status,
    required this.created,
    required this.modified,
    required this.practiceNames,
    required this.practices,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['id'] as int,
      requestNumber: json['request_number'] as String,
      roleId: json['role_id'] as int,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      deliveredEmail: json['delivered_email'] as bool,
      phoneNumber: json['phone_number'] as String,
      npi: (json['npi'] ?? '') as String,
      requestType: json['request_type'] as String,
      requestingUserId: json['requesting_user_id'] as int,
      userId: json['user_id'] as int?, // puede ser null
      status: json['status'] as String,
      created: DateTime.parse(json['created'] as String),
      modified: DateTime.parse(json['modified'] as String),
      practiceNames: (json['practice_names'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      practices: (json['practices'] as List<dynamic>)
          .map((e) => Practice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_number': requestNumber,
      'role_id': roleId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'delivered_email': deliveredEmail,
      'phone_number': phoneNumber,
      'npi': npi,
      'request_type': requestType,
      'requesting_user_id': requestingUserId,
      'user_id': userId,
      'status': status,
      'created': created.toIso8601String(),
      'modified': modified.toIso8601String(),
      'practice_names': practiceNames,
      'practices': practices.map((p) => p.toJson()).toList(),
    };
  }
}
