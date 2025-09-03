class Practice {
  final String name;
  final String tin;

  Practice({
    required this.name,
    required this.tin,
  });

  factory Practice.fromJson(Map<String, dynamic> json) {
    return Practice(
      name: json['name'] as String,
      tin: json['tin'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tin': tin,
    };
  }
}