class Patient {
  final String fullName;
  final String dob;
  final String mco;
  final int gic;
  final int ra;
  final int id;

  Patient(this.id, this.fullName, this.dob, this.mco, this.gic, this.ra);

  // ✅ Constructor auxiliar para crear desde JSON
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      (json['id'] is int)
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      json['full_name'] ?? '',
      json['birthdate'] ?? '',
      json['mco_name'] ?? '',
      (json['gic'] is int)
          ? json['gic']
          : int.tryParse(json['gic']?.toString() ?? '') ?? 0,
      (json['ra'] is int)
          ? json['ra']
          : int.tryParse(json['ra']?.toString() ?? '') ?? 0,
    );
  }
}
