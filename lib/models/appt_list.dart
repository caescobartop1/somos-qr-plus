class ApptList {
  final String billingTin;
  final int ownerId;
  final String dateTime;
  final String memberName;
  final String dob;
  final String? messedDate;
  final String? lastVisitDate;
  final String status;
  final String? email;
  final String phoneNumber;
  final String address;
  final String mcoName;

  ApptList({
    required this.billingTin,
    required this.ownerId,
    required this.dateTime,
    required this.memberName,
    required this.dob,
    this.messedDate,
    this.lastVisitDate,
    required this.status,
    this.email,
    required this.phoneNumber,
    required this.address,
    required this.mcoName,
  });

  /// Crear objeto desde JSON
  factory ApptList.fromJson(Map<String, dynamic> json) {
    return ApptList(
      billingTin: json['billing_tin']?.toString() ?? '',
      ownerId: json['owner_id'] is int
          ? json['owner_id']
          : int.tryParse(json['owner_id']?.toString() ?? '0') ?? 0,
      dateTime: json['date_time']?.toString() ?? '',
      memberName: json['member_name']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      messedDate: json['messed_date']?.toString(),
      lastVisitDate: json['last_visit_date']?.toString(),
      status: json['status']?.toString() ?? '',
      email: json['email']?.toString(),
      phoneNumber: json['phone_number']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      mcoName: json['mco_name']?.toString() ?? '',
    );
  }

  /// Convertir objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'billing_tin': billingTin,
      'owner_id': ownerId,
      'date_time': dateTime,
      'member_name': memberName,
      'dob': dob,
      'messed_date': messedDate,
      'last_visit_date': lastVisitDate,
      'status': status,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'mco_name': mcoName,
    };
  }

  /// Conversión rápida de una lista dentro de "results"
  static List<ApptList> listFromJson(dynamic json) {
    if (json is Map<String, dynamic> && json['results'] is List) {
      return (json['results'] as List)
          .map((e) => ApptList.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (json is List) {
      return json
          .map((e) => ApptList.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
