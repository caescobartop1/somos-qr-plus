class MfaMethod {
  final int id;
  final String code; // TOUCHID, FACEID, OTP, AUTHENTICATOR
  final bool isActive;
  final String description;
  final String? imageUrl; // opcional

  MfaMethod({
    required this.id,
    required this.code,
    required this.isActive,
    required this.description,
    this.imageUrl,
  });

  factory MfaMethod.fromJson(Map<String, dynamic> json) {
    return MfaMethod(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      isActive: (json['is_active'] ?? false) == true,
      description: json['description'] ?? '',
      imageUrl: json['image'],
    );
  }

  /// Convierte una lista JSON (List<dynamic>) en List<MfaMethod>
  static List<MfaMethod> listFromJson(List<dynamic> data) {
    return data
        .map((e) => MfaMethod.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Helper para responses paginados: { count, next, previous, results: [...] }
  static List<MfaMethod> fromPaginated(Map<String, dynamic> json) {
    final results = (json['results'] as List?) ?? const [];
    return MfaMethod.listFromJson(results);
  }
}
