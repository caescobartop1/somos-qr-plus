class GicList {
  final String billingTin;
  final int ownerId;
  final String memberName;
  final String dob;
  final DateTime? dateTime;
  final String measureCode;
  final String measureDescription;
  final String status;
  final String email;
  final String phoneNumber;
  final String mcoName;
  final String fullNameDisplay;
  final String lineOfBusiness;
  final String reportingPeriod;
  final String npi;
  final String pcpName;
  final String gender;
  final String memberId;
  final dynamic nonUserFlag;

  GicList({
    required this.billingTin,
    required this.ownerId,
    required this.memberName,
    required this.dob,
    this.dateTime,
    required this.measureCode,
    required this.measureDescription,
    required this.status,
    required this.email,
    required this.phoneNumber,
    required this.mcoName,
    required this.fullNameDisplay,
    required this.lineOfBusiness,
    required this.reportingPeriod,
    required this.npi,
    required this.pcpName,
    required this.gender,
    required this.memberId,
    this.nonUserFlag,
  });

  factory GicList.fromJson(Map<String, dynamic> json) {
    return GicList(
      billingTin: json['billing_tin']?.toString() ?? '',
      ownerId: json['owner_id'] is int
          ? json['owner_id']
          : int.tryParse(json['owner_id']?.toString() ?? '') ?? 0,
      memberName: json['member_name']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      dateTime: json['date_time'] != null
          ? DateTime.tryParse(json['date_time'].toString())
          : null,
      measureCode: json['measure_code']?.toString() ?? '',
      measureDescription: json['measure_description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      mcoName: json['mco_name']?.toString() ?? '',
      fullNameDisplay: json['full_name_display']?.toString() ?? '',
      lineOfBusiness: json['line_of_business']?.toString() ?? '',
      reportingPeriod: json['reporting_period']?.toString() ?? '',
      npi: json['npi']?.toString() ?? '',
      pcpName: json['pcp_name']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      memberId: json['member_id']?.toString() ?? '',
      nonUserFlag: json['non_user_flag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'billing_tin': billingTin,
      'owner_id': ownerId,
      'member_name': memberName,
      'dob': dob,
      'date_time': dateTime?.toIso8601String(),
      'measure_code': measureCode,
      'measure_description': measureDescription,
      'status': status,
      'email': email,
      'phone_number': phoneNumber,
      'mco_name': mcoName,
      'full_name_display': fullNameDisplay,
      'line_of_business': lineOfBusiness,
      'reporting_period': reportingPeriod,
      'npi': npi,
      'pcp_name': pcpName,
      'gender': gender,
      'member_id': memberId,
      'non_user_flag': nonUserFlag,
    };
  }

  static List<GicList> listFromJson(dynamic data) {
    if (data is List) {
      return data
          .map((e) => GicList.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (data is Map<String, dynamic> && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => GicList.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
