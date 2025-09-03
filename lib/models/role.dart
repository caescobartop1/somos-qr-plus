class Role {
  final int id;
  final String name;
  final bool verificationRequired;
  final String code;
  final String description;
  final String roleType;
  final bool practiceRequired;
  final DateTime? created;
  final DateTime? modified;
  final int total;

  Role({
    required this.id,
    required this.name,
    required this.verificationRequired,
    required this.code,
    required this.description,
    required this.roleType,
    required this.practiceRequired,
    this.created,
    this.modified,
    required this.total,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      verificationRequired: json['verification_required'],
      code: json['code'],
      description: json['description'],
      roleType: json['role_type'],
      practiceRequired: json['practice_required'],
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      modified:
          json['modified'] != null ? DateTime.parse(json['modified']) : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'verification_required': verificationRequired,
      'code': code,
      'description': description,
      'role_type': roleType,
      'practice_required': practiceRequired,
      'created': created?.toIso8601String(),
      'modified': modified?.toIso8601String(),
      'total': total,
    };
  }
}
