class QualityMeasure {
  final String measureCode;
  final String name;

  QualityMeasure({
    required this.measureCode,
    required this.name,
  });

  factory QualityMeasure.fromJson(Map<String, dynamic> json) {
    return QualityMeasure(
      measureCode: json['measure_code'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'measure_code': measureCode,
      'name': name,
    };
  }

  @override
  String toString() => "$measureCode - $name";
}
