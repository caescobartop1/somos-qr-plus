class MWOVList {
  final String billingTin;
  final int ownerId;
  final String? lastClaimDate;
  final String memberName;
  final String? lastVisitDate;
  final String? email;
  final String phoneNumber;
  final String address;
  final String dob;
  final String mcoName;

  MWOVList({
    required this.billingTin,
    required this.ownerId,
    this.lastClaimDate,
    required this.memberName,
    this.lastVisitDate,
    this.email,
    required this.phoneNumber,
    required this.address,
    required this.dob,
    required this.mcoName,
  });

  /// Crear objeto desde JSON
  factory MWOVList.fromJson(Map<String, dynamic> json) {
    return MWOVList(
      billingTin: json['billing_tin']?.toString() ?? '',
      ownerId: (json['owner_id'] is num)
          ? (json['owner_id'] as num).toInt()
          : int.tryParse(json['owner_id']?.toString() ?? '') ?? 0,
      lastClaimDate: json['last_claim_date']?.toString(),
      memberName: json['member_name']?.toString() ?? '',
      lastVisitDate: json['last_visit_date']?.toString(),
      email: json['email']?.toString(),
      phoneNumber: json['phone_number']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      mcoName: json['mco_name']?.toString() ?? '',
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'billing_tin': billingTin,
      'owner_id': ownerId,
      'last_claim_date': lastClaimDate,
      'member_name': memberName,
      'last_visit_date': lastVisitDate,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'dob': dob,
      'mco_name': mcoName,
    };
  }

  /// Crear una copia modificada
  MWOVList copyWith({
    String? billingTin,
    int? ownerId,
    String? lastClaimDate,
    String? memberName,
    String? lastVisitDate,
    String? email,
    String? phoneNumber,
    String? address,
    String? dob,
    String? mcoName,
  }) {
    return MWOVList(
      billingTin: billingTin ?? this.billingTin,
      ownerId: ownerId ?? this.ownerId,
      lastClaimDate: lastClaimDate ?? this.lastClaimDate,
      memberName: memberName ?? this.memberName,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      dob: dob ?? this.dob,
      mcoName: mcoName ?? this.mcoName,
    );
  }

  /// Conversión rápida de una lista dentro de "results"
  static List<MWOVList> listFromJson(dynamic json) {
    if (json is List) {
      return json
          .map((e) => MWOVList.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (json is Map && json['results'] is List) {
      return (json['results'] as List)
          .map((e) => MWOVList.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
