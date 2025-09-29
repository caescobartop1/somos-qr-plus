class NpiResponse {
  final int id;
  final String npi;
  final int ownerId;
  final String name;
  final String firstName;
  final String lastName;
  final String tin;

  NpiResponse({
    required this.id,
    required this.npi,
    required this.ownerId,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.tin,
  });

  factory NpiResponse.fromJson(Map<String, dynamic> json) {
    return NpiResponse(
      id: json['id'] ?? 0,
      npi: json['npi'] ?? '',
      ownerId: json['owner_id'] ?? 0,
      name: json['name'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      tin: json['tin'] ?? '',
    );
  }

  static List<NpiResponse> listFromJson(List<dynamic> list) {
    return list.map((e) => NpiResponse.fromJson(e)).toList();
  }
}
