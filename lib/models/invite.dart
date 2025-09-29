class Invite {
  final int id;
  final String requestNumber;
  final int roleId;
  final String roleName;
  final String roleCode;
  final bool roleVerificationRequired;
  final String roleDescription;
  final String roleType;
  final bool rolePracticeRequired;
  final String email;
  final String firstName;
  final String lastName;
  final bool deliveredEmail;
  final String? phoneNumber;
  final String? npi;
  final String requestType;
  final int requestingUserId;
  final String requestingUserUsername;
  final String requestingUserFirstName;
  final String requestingUserLastName;
  final String requestingUserEmail;
  final bool requestingUserActive;
  final bool requestingUserStaff;
  final bool requestingUserSuperuser;
  final bool requestingUserVerified;
  final String? requestingUserLastLogin;
  final String? requestingUserDateJoined;
  final int? userId;
  final String? status;
  final String created;
  final String modified;
  final List<String> practiceNames;
  final List<String> practiceTins;

  Invite({
    required this.id,
    required this.requestNumber,
    required this.roleId,
    required this.roleName,
    required this.roleCode,
    required this.roleVerificationRequired,
    required this.roleDescription,
    required this.roleType,
    required this.rolePracticeRequired,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.deliveredEmail,
    required this.phoneNumber,
    required this.npi,
    required this.requestType,
    required this.requestingUserId,
    required this.requestingUserUsername,
    required this.requestingUserFirstName,
    required this.requestingUserLastName,
    required this.requestingUserEmail,
    required this.requestingUserActive,
    required this.requestingUserStaff,
    required this.requestingUserSuperuser,
    required this.requestingUserVerified,
    required this.requestingUserLastLogin,
    required this.requestingUserDateJoined,
    required this.userId,
    required this.status,
    required this.created,
    required this.modified,
    required this.practiceNames,
    required this.practiceTins,
  });

  factory Invite.fromJson(Map<String, dynamic> json) {
    final role = json['role'] ?? {};
    final reqUser = json['requesting_user'] ?? {};
    final practices = (json['practices'] as List?) ?? [];

    return Invite(
      id: json['id'] ?? 0,
      requestNumber: json['request_number'] ?? '',
      roleId: json['role_id'] ?? 0,
      roleName: role['name'] ?? '',
      roleCode: role['code'] ?? '',
      roleVerificationRequired: role['verification_required'] ?? false,
      roleDescription: role['description'] ?? '',
      roleType: role['role_type'] ?? '',
      rolePracticeRequired: role['practice_required'] ?? false,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      deliveredEmail: json['delivered_email'] ?? false,
      phoneNumber: json['phone_number'],
      npi: json['npi'],
      requestType: json['request_type'] ?? '',
      requestingUserId: json['requesting_user_id'] ?? 0,
      requestingUserUsername: reqUser['username'] ?? '',
      requestingUserFirstName: reqUser['first_name'] ?? '',
      requestingUserLastName: reqUser['last_name'] ?? '',
      requestingUserEmail: reqUser['email'] ?? '',
      requestingUserActive: reqUser['is_active'] ?? false,
      requestingUserStaff: reqUser['is_staff'] ?? false,
      requestingUserSuperuser: reqUser['is_superuser'] ?? false,
      requestingUserVerified: reqUser['is_verified'] ?? false,
      requestingUserLastLogin: reqUser['last_login'],
      requestingUserDateJoined: reqUser['date_joined'],
      userId: json['user_id'],
      status: json['status'],
      created: json['created'] ?? '',
      modified: json['modified'] ?? '',
      practiceNames: List<String>.from(json['practice_names'] ?? []),
      practiceTins: practices
          .map<String>((p) => p['tin']?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList(),
    );
  }

  static List<Invite> listFromJson(List<dynamic> list) {
    return list.map((e) => Invite.fromJson(e)).toList();
  }
}
