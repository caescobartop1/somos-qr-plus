import 'my_invites_practice.dart';

class MyInvite {
  final int id;
  final String requestNumber;
  final int roleId;
  final String roleName;
  final String roleCode;
  final String roleType;
  final bool roleVerificationRequired;
  final String roleDescription;
  final bool rolePracticeRequired;
  final String email;
  final String firstName;
  final String lastName;
  final bool deliveredEmail;
  final String phoneNumber;
  final String? npi;
  final String requestType;
  final int requestingUserId;
  final String requestingUserName;
  final String requestingUserFirstName;
  final String requestingUserLastName;
  final String requestingUserEmail;
  final bool requestingUserIsActive;
  final bool requestingUserIsSuperuser;
  final bool requestingUserIsVerified;
  final int userId;
  final String userName;
  final String userFirstName;
  final String userLastName;
  final String userEmail;
  final bool userIsActive;
  final bool userIsSuperuser;
  final bool userIsVerified;
  final String status;
  final DateTime? created;
  final DateTime? modified;
  final List<String> practiceNames;
  final List<MyInvitePractice> practices;

  MyInvite({
    required this.id,
    required this.requestNumber,
    required this.roleId,
    required this.roleName,
    required this.roleCode,
    required this.roleType,
    required this.roleVerificationRequired,
    required this.roleDescription,
    required this.rolePracticeRequired,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.deliveredEmail,
    required this.phoneNumber,
    this.npi,
    required this.requestType,
    required this.requestingUserId,
    required this.requestingUserName,
    required this.requestingUserFirstName,
    required this.requestingUserLastName,
    required this.requestingUserEmail,
    required this.requestingUserIsActive,
    required this.requestingUserIsSuperuser,
    required this.requestingUserIsVerified,
    required this.userId,
    required this.userName,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    required this.userIsActive,
    required this.userIsSuperuser,
    required this.userIsVerified,
    required this.status,
    required this.created,
    required this.modified,
    required this.practiceNames,
    required this.practices,
  });

  factory MyInvite.fromJson(Map<String, dynamic> json) {
    final role = json['role'] ?? {};
    final requestingUser = json['requesting_user'] ?? {};
    final user = json['user'] ?? {};

    DateTime? parseDate(dynamic v) =>
        v != null ? DateTime.tryParse(v.toString()) : null;

    return MyInvite(
      id: json['id'] ?? 0,
      requestNumber: json['request_number'] ?? '',
      roleId: json['role_id'] ?? 0,
      roleName: role['name'] ?? '',
      roleCode: role['code'] ?? '',
      roleType: role['role_type'] ?? '',
      roleVerificationRequired: role['verification_required'] ?? false,
      roleDescription: role['description'] ?? '',
      rolePracticeRequired: role['practice_required'] ?? false,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      deliveredEmail: json['delivered_email'] ?? false,
      phoneNumber: json['phone_number'] ?? '',
      npi: json['npi'],
      requestType: json['request_type'] ?? '',
      requestingUserId: json['requesting_user_id'] ?? 0,
      requestingUserName: requestingUser['username'] ?? '',
      requestingUserFirstName: requestingUser['first_name'] ?? '',
      requestingUserLastName: requestingUser['last_name'] ?? '',
      requestingUserEmail: requestingUser['email'] ?? '',
      requestingUserIsActive: requestingUser['is_active'] ?? false,
      requestingUserIsSuperuser: requestingUser['is_superuser'] ?? false,
      requestingUserIsVerified: requestingUser['is_verified'] ?? false,
      userId: json['user_id'] ?? 0,
      userName: user['username'] ?? '',
      userFirstName: user['first_name'] ?? '',
      userLastName: user['last_name'] ?? '',
      userEmail: user['email'] ?? '',
      userIsActive: user['is_active'] ?? false,
      userIsSuperuser: user['is_superuser'] ?? false,
      userIsVerified: user['is_verified'] ?? false,
      status: json['status'] ?? '',
      created: parseDate(json['created']),
      modified: parseDate(json['modified']),
      practiceNames: (json['practice_names'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      practices: MyInvitePractice.listFromJson(json['practices']),
    );
  }

  static List<MyInvite> listFromJson(List<dynamic> data) {
    return data.map((e) => MyInvite.fromJson(e)).toList();
  }
}
