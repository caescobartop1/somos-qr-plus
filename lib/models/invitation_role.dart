class InvitationRole {
  final int id;
  final String name;
  final bool verificationRequired;
  final String code;
  final String description;
  final String roleType;
  final bool practiceRequired;
  final String created;
  final String modified;
  final int total;

  InvitationRole({
    required this.id,
    required this.name,
    required this.verificationRequired,
    required this.code,
    required this.description,
    required this.roleType,
    required this.practiceRequired,
    required this.created,
    required this.modified,
    required this.total,
  });

  factory InvitationRole.fromJson(Map<String, dynamic> json) {
    return InvitationRole(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      verificationRequired: json['verification_required'] ?? false,
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      roleType: json['role_type'] ?? '',
      practiceRequired: json['practice_required'] ?? false,
      created: json['created'] ?? '',
      modified: json['modified'] ?? '',
      total: json['total'] ?? 0,
    );
  }

  static List<InvitationRole> listFromJson(List<dynamic> data) {
    return data.map((e) => InvitationRole.fromJson(e)).toList();
  }
}
