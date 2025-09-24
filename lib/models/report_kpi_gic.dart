class ReportKpiGic {
  final String practiceId;
  final String kpiType;
  final int ownerId;
  final String practiceName;

  // Today
  final int todayMessedWoa;
  final int todayCompletedWa;
  final int todayStar;
  final int todayRank;
  final int todayRankOf;
  final DateTime todayDate;

  // Last Month
  final int lmonthMessedWoa;
  final int lmonthCompletedWa;
  final int lmonthStar;
  final int lmonthRank;
  final int lmonthRankOf;
  final DateTime lmonthBegin;
  final DateTime lmonthEnd;

  ReportKpiGic({
    required this.practiceId,
    required this.kpiType,
    required this.ownerId,
    required this.practiceName,
    required this.todayMessedWoa,
    required this.todayCompletedWa,
    required this.todayStar,
    required this.todayRank,
    required this.todayRankOf,
    required this.todayDate,
    required this.lmonthMessedWoa,
    required this.lmonthCompletedWa,
    required this.lmonthStar,
    required this.lmonthRank,
    required this.lmonthRankOf,
    required this.lmonthBegin,
    required this.lmonthEnd,
  });

  factory ReportKpiGic.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return ReportKpiGic(
      practiceId: json['practice_id']?.toString() ?? '',
      kpiType: json['kpi_type']?.toString() ?? '',
      ownerId: (json['owner_id'] is num)
          ? (json['owner_id'] as num).toInt()
          : int.tryParse(json['owner_id']?.toString() ?? '') ?? 0,
      practiceName: json['practice_name']?.toString() ?? '',

      // Today
      todayMessedWoa: _toDouble(json['today_messed_woa']).toInt(),
      todayCompletedWa: _toDouble(json['today_completed_wa']).toInt(),
      todayStar: _toDouble(json['today_star']).toInt(),
      todayRank: _toDouble(json['today_rank']).toInt(),
      todayRankOf: _toDouble(json['today_rank_of']).toInt(),
      todayDate: DateTime.tryParse(json['today_date']?.toString() ?? '') ??
          DateTime(1970),

      // Last Month
      lmonthMessedWoa: _toDouble(json['lmonth_messed_woa']).toInt(),
      lmonthCompletedWa: _toDouble(json['lmonth_completed_wa']).toInt(),
      lmonthStar: _toDouble(json['lmonth_star']).toInt(),
      lmonthRank: _toDouble(json['lmonth_rank']).toInt(),
      lmonthRankOf: _toDouble(json['lmonth_rank_of']).toInt(),
      lmonthBegin: DateTime.tryParse(json['lmonth_begin']?.toString() ?? '') ??
          DateTime(1970),
      lmonthEnd: DateTime.tryParse(json['lmonth_end']?.toString() ?? '') ??
          DateTime(1970),
    );
  }
}
