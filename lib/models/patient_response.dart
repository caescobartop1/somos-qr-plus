class PatientResponse {
  final int id;
  final String fullName;
  final bool hasAppointment;
  final DateTime? nextAppointment;
  final String? memberPlanId;
  final String firstName;
  final String lastName;
  final DateTime? birthdate;
  final String? language;
  final String? city;
  final String? country;
  final String? address;
  final String? state;
  final String? zipCode;
  final String? phoneNumber;
  final String? phoneNumber2;
  final String? email;
  final String? gender;
  final DateTime? created;
  final DateTime? modified;
  final String? lastStatus;
  final DateTime? recertDate;
  final DateTime? lastVisitDate;
  final int gic;
  final int ra;
  final int? noShow;
  final String? mcoName;

  PatientResponse({
    required this.id,
    required this.fullName,
    required this.hasAppointment,
    this.nextAppointment,
    this.memberPlanId,
    required this.firstName,
    required this.lastName,
    this.birthdate,
    this.language,
    this.city,
    this.country,
    this.address,
    this.state,
    this.zipCode,
    this.phoneNumber,
    this.phoneNumber2,
    this.email,
    this.gender,
    this.created,
    this.modified,
    this.lastStatus,
    this.recertDate,
    this.lastVisitDate,
    required this.gic,
    required this.ra,
    this.noShow,
    this.mcoName,
  });

  /// Crear objeto desde JSON
  factory PatientResponse.fromJson(Map<String, dynamic> json) {
    return PatientResponse(
      id: json['id'] as int,
      fullName: json['full_name'] ?? '',
      hasAppointment: json['has_appointment'] ?? false,
      nextAppointment: json['next_appointment'] != null
          ? DateTime.tryParse(json['next_appointment'])
          : null,
      memberPlanId: json['member_plan_id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      birthdate: json['birthdate'] != null
          ? DateTime.tryParse(json['birthdate'])
          : null,
      language: json['language'],
      city: json['city'],
      country: json['country'],
      address: json['address'],
      state: json['state'],
      zipCode: json['zip_code'],
      phoneNumber: json['phone_number'],
      phoneNumber2: json['phone_number_2'],
      email: json['email'],
      gender: json['gender'],
      created:
          json['created'] != null ? DateTime.tryParse(json['created']) : null,
      modified:
          json['modified'] != null ? DateTime.tryParse(json['modified']) : null,
      lastStatus: json['last_status'],
      recertDate: json['recert_date'] != null
          ? DateTime.tryParse(json['recert_date'])
          : null,
      lastVisitDate: json['last_visit_date'] != null
          ? DateTime.tryParse(json['last_visit_date'])
          : null,
      gic: json['gic'] ?? 0,
      ra: json['ra'] ?? 0,
      noShow: json['no_show'],
      mcoName: json['mco_name'],
    );
  }

  /// Convertir objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'has_appointment': hasAppointment,
      'next_appointment': nextAppointment?.toIso8601String(),
      'member_plan_id': memberPlanId,
      'first_name': firstName,
      'last_name': lastName,
      'birthdate': birthdate?.toIso8601String(),
      'language': language,
      'city': city,
      'country': country,
      'address': address,
      'state': state,
      'zip_code': zipCode,
      'phone_number': phoneNumber,
      'phone_number_2': phoneNumber2,
      'email': email,
      'gender': gender,
      'created': created?.toIso8601String(),
      'modified': modified?.toIso8601String(),
      'last_status': lastStatus,
      'recert_date': recertDate?.toIso8601String(),
      'last_visit_date': lastVisitDate?.toIso8601String(),
      'gic': gic,
      'ra': ra,
      'no_show': noShow,
      'mco_name': mcoName,
    };
  }
}
