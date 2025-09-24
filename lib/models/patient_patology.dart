class PatientPatology {
  final int id;
  final String? code;
  final String? description;
  final String? memberName;
  final bool inactive;
  final bool present;
  final dynamic treatedProviderId; // puede ser int, String o null
  final bool app;
  final bool ehr;
  final bool claim;
  final String? hccCategory;
  final String? hccDescription;

  PatientPatology({
    required this.id,
    this.code,
    this.description,
    this.memberName,
    required this.inactive,
    required this.present,
    this.treatedProviderId,
    required this.app,
    required this.ehr,
    required this.claim,
    this.hccCategory,
    this.hccDescription,
  });

  /// Crear objeto desde JSON
  factory PatientPatology.fromJson(Map<String, dynamic> json) {
    return PatientPatology(
      id: json['id'] as int,
      code: json['code'],
      description: json['description'],
      memberName: json['member_name'],
      inactive: json['inactive'] ?? false,
      present: json['present'] ?? false,
      treatedProviderId: json['treated_provider_id'],
      app: json['app'] ?? false,
      ehr: json['ehr'] ?? false,
      claim: json['claim'] ?? false,
      hccCategory: json['hcc_category'],
      hccDescription: json['hcc_description'],
    );
  }

  /// Convertir objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'member_name': memberName,
      'inactive': inactive,
      'present': present,
      'treated_provider_id': treatedProviderId,
      'app': app,
      'ehr': ehr,
      'claim': claim,
      'hcc_category': hccCategory,
      'hcc_description': hccDescription,
    };
  }

  /// Crear una nueva instancia con campos modificados
  PatientPatology copyWith({
    int? id,
    String? code,
    String? description,
    String? memberName,
    bool? inactive,
    bool? present,
    dynamic treatedProviderId,
    bool? app,
    bool? ehr,
    bool? claim,
    String? hccCategory,
    String? hccDescription,
  }) {
    return PatientPatology(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      memberName: memberName ?? this.memberName,
      inactive: inactive ?? this.inactive,
      present: present ?? this.present,
      treatedProviderId: treatedProviderId ?? this.treatedProviderId,
      app: app ?? this.app,
      ehr: ehr ?? this.ehr,
      claim: claim ?? this.claim,
      hccCategory: hccCategory ?? this.hccCategory,
      hccDescription: hccDescription ?? this.hccDescription,
    );
  }

  /// Parseo rápido de una lista dentro de "results"
  static List<PatientPatology> listFromResults(Map<String, dynamic> json) {
    if (json['results'] is List) {
      return (json['results'] as List)
          .map((e) => PatientPatology.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
