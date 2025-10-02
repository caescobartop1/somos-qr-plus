class QualityScore {
  final String mco;
  final String billingTin;
  final String locationName;
  final int displayKey;
  final String lineOfBusiness;
  final String product;
  final String measureCode;
  final String measureName;
  final double numerator;
  final double denominator;
  final double open;
  final int app;
  final int claim;
  final int ehr;
  final double complianceRate;
  final double bm50th3star;
  final double bm75th4star;
  final double bm90th5star;
  final double weight;
  final double hitsToNextTarget;
  final double? achieved;

  QualityScore({
    required this.mco,
    required this.billingTin,
    required this.locationName,
    required this.displayKey,
    required this.lineOfBusiness,
    required this.product,
    required this.measureCode,
    required this.measureName,
    required this.numerator,
    required this.denominator,
    required this.open,
    required this.app,
    required this.claim,
    required this.ehr,
    required this.complianceRate,
    required this.bm50th3star,
    required this.bm75th4star,
    required this.bm90th5star,
    required this.weight,
    required this.hitsToNextTarget,
    this.achieved,
  });

  factory QualityScore.fromJson(Map<String, dynamic> json) {
    return QualityScore(
      mco: json['mco'] ?? '',
      billingTin: json['billing_tin'] ?? '',
      locationName: json['location_name'] ?? '',
      displayKey: json['display_key'] ?? 0,
      lineOfBusiness: json['line_of_business'] ?? '',
      product: json['product'] ?? '',
      measureCode: json['measure_code'] ?? '',
      measureName: json['measure_name'] ?? '',
      numerator: double.tryParse(json['numerator'].toString()) ?? 0.0,
      denominator: double.tryParse(json['denominator'].toString()) ?? 0.0,
      open: double.tryParse(json['open'].toString()) ?? 0.0,
      app: json['app'] ?? 0,
      claim: json['claim'] ?? 0,
      ehr: json['ehr'] ?? 0,
      complianceRate:
          double.tryParse(json['compliance_rate'].toString()) ?? 0.0,
      bm50th3star: double.tryParse(json['bm50th_3star'].toString()) ?? 0.0,
      bm75th4star: double.tryParse(json['bm75th_4star'].toString()) ?? 0.0,
      bm90th5star: double.tryParse(json['bm90th_5star'].toString()) ?? 0.0,
      weight: double.tryParse(json['weight'].toString()) ?? 0.0,
      hitsToNextTarget:
          double.tryParse(json['hits_to_next_target'].toString()) ?? 0.0,
      achieved: json['achieved'] != null
          ? double.tryParse(json['achieved'].toString())
          : null,
    );
  }
}
