class UserManagement {
  final int id;
  final String fullName;
  final String practice; // Llega como string en el JSON
  final int user; // ID del usuario relacionado
  final int role; // ID del rol
  final bool isVerified;
  final DateTime? created;
  final DateTime? modified;
  final String phoneNumber;

  UserManagement({
    required this.id,
    required this.fullName,
    required this.practice,
    required this.user,
    required this.role,
    required this.isVerified,
    required this.created,
    required this.modified,
    required this.phoneNumber,
  });

  factory UserManagement.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) =>
        v != null ? DateTime.tryParse(v.toString()) : null;

    return UserManagement(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      practice: json['practice']?.toString() ?? '',
      user: json['user'] ?? 0,
      role: json['role'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      created: parseDate(json['created']),
      modified: parseDate(json['modified']),
      phoneNumber: json['phone_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'practice': practice,
        'user': user,
        'role': role,
        'is_verified': isVerified,
        'created': created?.toIso8601String(),
        'modified': modified?.toIso8601String(),
        'phone_number': phoneNumber,
      };

  static List<UserManagement> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((e) => UserManagement.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
