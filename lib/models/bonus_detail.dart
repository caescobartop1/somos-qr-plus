class BonusDetail {
  final String labelCode;
  final double potential;
  final double earnings;
  final double totalOpenGaps;

  const BonusDetail({
    required this.labelCode,
    required this.potential,
    required this.earnings,
    required this.totalOpenGaps,
  });

  factory BonusDetail.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0.0;

    return BonusDetail(
      labelCode: json['label_code']?.toString() ?? '',
      potential: _toDouble(json['potential']),
      earnings: _toDouble(json['earnings']),
      totalOpenGaps: _toDouble(json['total_open_gaps']),
    );
  }

  Map<String, dynamic> toJson() => {
        'label_code': labelCode,
        'potential': potential,
        'earnings': earnings,
        'total_open_gaps': totalOpenGaps,
      };
}
