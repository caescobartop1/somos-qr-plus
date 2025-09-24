class ProviderSchedule {
  final int id;
  final String npi;
  final String practiceId;
  final String providerFirstName;
  final String providerLastName;
  final String practiceName;
  final String tin;
  final int userId;

  ProviderSchedule({
    required this.id,
    required this.npi,
    required this.practiceId,
    required this.providerFirstName,
    required this.providerLastName,
    required this.practiceName,
    required this.tin,
    required this.userId,
  });

  factory ProviderSchedule.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return ProviderSchedule(
      id: _toInt(json['id']),
      npi: json['npi']?.toString() ?? '',
      practiceId: json['practice_id']?.toString() ?? '',
      providerFirstName: json['provider_first_name']?.toString() ?? '',
      providerLastName: json['provider_last_name']?.toString() ?? '',
      practiceName: json['practice_name']?.toString() ?? '',
      tin: json['tin']?.toString() ?? '',
      userId: _toInt(json['user_id']),
    );
  }

  String get fullName => '$providerFirstName $providerLastName';
}
