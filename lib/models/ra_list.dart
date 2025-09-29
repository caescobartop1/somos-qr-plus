class RaList {
  final String billingTin;
  final int ownerId;
  final String memberName;
  final String dob;
  final DateTime? dateTime;
  final String? icd10Code;
  final String? icd10CodeDescription;
  final String hccStatus;
  final String email;
  final String phoneNumber;
  final String mcoName;
  final String? hccCategory;
  final String? hccDescription;

  RaList({
    required this.billingTin,
    required this.ownerId,
    required this.memberName,
    required this.dob,
    this.dateTime,
    this.icd10Code,
    this.icd10CodeDescription,
    required this.hccStatus,
    required this.email,
    required this.phoneNumber,
    required this.mcoName,
    this.hccCategory,
    this.hccDescription,
  });

  /// Crear objeto desde JSON
  factory RaList.fromJson(Map<String, dynamic> json) {
    return RaList(
      billingTin: json['billing_tin']?.toString() ?? '',
      ownerId: (json['owner_id'] is num)
          ? (json['owner_id'] as num).toInt()
          : int.tryParse(json['owner_id']?.toString() ?? '') ?? 0,
      memberName: json['member_name']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      dateTime:
          json['date_time'] != null && json['date_time'].toString().isNotEmpty
              ? DateTime.tryParse(json['date_time'].toString())
              : null,
      icd10Code: json['icd10_code']?.toString(),
      icd10CodeDescription: json['icd10_code_description']?.toString(),
      hccStatus: json['hcc_status']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      mcoName: json['mco_name']?.toString() ?? '',
      hccCategory: json['hcc_category']?.toString(),
      hccDescription: json['hcc_description']?.toString(),
    );
  }

  /// Convertir objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'billing_tin': billingTin,
      'owner_id': ownerId,
      'member_name': memberName,
      'dob': dob,
      'date_time': dateTime?.toIso8601String(),
      'icd10_code': icd10Code,
      'icd10_code_description': icd10CodeDescription,
      'hcc_status': hccStatus,
      'email': email,
      'phone_number': phoneNumber,
      'mco_name': mcoName,
      'hcc_category': hccCategory,
      'hcc_description': hccDescription,
    };
  }

  /// Crear una copia modificada
  RaList copyWith({
    String? billingTin,
    int? ownerId,
    String? memberName,
    String? dob,
    DateTime? dateTime,
    String? icd10Code,
    String? icd10CodeDescription,
    String? hccStatus,
    String? email,
    String? phoneNumber,
    String? mcoName,
    String? hccCategory,
    String? hccDescription,
  }) {
    return RaList(
      billingTin: billingTin ?? this.billingTin,
      ownerId: ownerId ?? this.ownerId,
      memberName: memberName ?? this.memberName,
      dob: dob ?? this.dob,
      dateTime: dateTime ?? this.dateTime,
      icd10Code: icd10Code ?? this.icd10Code,
      icd10CodeDescription: icd10CodeDescription ?? this.icd10CodeDescription,
      hccStatus: hccStatus ?? this.hccStatus,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      mcoName: mcoName ?? this.mcoName,
      hccCategory: hccCategory ?? this.hccCategory,
      hccDescription: hccDescription ?? this.hccDescription,
    );
  }

  /// Conversión rápida de lista
  static List<RaList> listFromJson(dynamic json) {
    if (json is List) {
      return json
          .map((e) => RaList.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (json is Map && json['results'] is List) {
      return (json['results'] as List)
          .map((e) => RaList.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
