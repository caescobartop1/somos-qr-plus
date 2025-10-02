class MyInvitePractice {
  final String name;
  final String tin;

  MyInvitePractice({
    required this.name,
    required this.tin,
  });

  factory MyInvitePractice.fromJson(Map<String, dynamic> json) {
    return MyInvitePractice(
      name: json['name'] ?? '',
      tin: json['tin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'tin': tin,
      };

  static List<MyInvitePractice> listFromJson(List<dynamic>? list) {
    if (list == null) return [];
    return list.map((e) => MyInvitePractice.fromJson(e)).toList();
  }
}
