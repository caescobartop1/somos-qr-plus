class PatientGap {
  final int id;
  final String measureCode;
  final String memberName;
  final String measureDescription;
  final bool app;
  final dynamic treatedProviderId; // Puede ser int o null
  final dynamic treatedProviderName; // Puede ser String o null
  final bool complete;
  final bool ehr;
  final bool claim;

  PatientGap({
    required this.id,
    required this.measureCode,
    required this.memberName,
    required this.measureDescription,
    required this.app,
    this.treatedProviderId,
    this.treatedProviderName,
    required this.complete,
    required this.ehr,
    required this.claim,
  });

  /// Crear objeto desde JSON
  factory PatientGap.fromJson(Map<String, dynamic> json) {
    return PatientGap(
      id: json['id'] as int,
      measureCode: json['measure_code'] ?? '',
      memberName: json['member_name'] ?? '',
      measureDescription: json['measure_description'] ?? '',
      app: json['app'] ?? false,
      treatedProviderId: json['treated_provider_id'],
      treatedProviderName: json['treated_provider_name'],
      complete: json['complete'] ?? false,
      ehr: json['ehr'] ?? false,
      claim: json['claim'] ?? false,
    );
  }

  /// Convertir objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'measure_code': measureCode,
      'member_name': memberName,
      'measure_description': measureDescription,
      'app': app,
      'treated_provider_id': treatedProviderId,
      'treated_provider_name': treatedProviderName,
      'complete': complete,
      'ehr': ehr,
      'claim': claim,
    };
  }

  /// Crear una nueva instancia con campos modificados
  PatientGap copyWith({
    int? id,
    String? measureCode,
    String? memberName,
    String? measureDescription,
    bool? app,
    dynamic treatedProviderId,
    dynamic treatedProviderName,
    bool? complete,
    bool? ehr,
    bool? claim,
  }) {
    return PatientGap(
      id: id ?? this.id,
      measureCode: measureCode ?? this.measureCode,
      memberName: memberName ?? this.memberName,
      measureDescription: measureDescription ?? this.measureDescription,
      app: app ?? this.app,
      treatedProviderId: treatedProviderId ?? this.treatedProviderId,
      treatedProviderName: treatedProviderName ?? this.treatedProviderName,
      complete: complete ?? this.complete,
      ehr: ehr ?? this.ehr,
      claim: claim ?? this.claim,
    );
  }

  /// Conversión rápida de una lista dentro de "results"
  static List<PatientGap> listFromResults(Map<String, dynamic> json) {
    if (json['results'] is List) {
      return (json['results'] as List)
          .map((e) => PatientGap.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
