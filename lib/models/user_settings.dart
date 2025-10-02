class UserSettings {
  final int id;
  final int mfaId;
  final bool darkMode;
  final DateTime created;
  final DateTime? modified;

  UserSettings({
    required this.id,
    required this.mfaId,
    required this.darkMode,
    required this.created,
    this.modified,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      id: json['id'] ?? 0,
      mfaId: json['mfa_id'] ?? 0,
      darkMode: json['dark_mode'] ?? false,
      created: DateTime.tryParse(json['created'] ?? '') ?? DateTime.now(),
      modified:
          json['modified'] != null ? DateTime.tryParse(json['modified']) : null,
    );
  }
  UserSettings copyWith({
    int? id,
    int? mfaId,
    bool? darkMode,
    DateTime? created,
    DateTime? modified,
  }) {
    return UserSettings(
      id: id ?? this.id,
      mfaId: mfaId ?? this.mfaId,
      darkMode: darkMode ?? this.darkMode,
      created: created ?? this.created,
      // si no te mandan modified, usamos ahora
      modified: modified ?? DateTime.now(),
    );
  }
}
