class PracticeDetails {
  final String practiceId;
  final String practiceName;

  final int patients;

  final int gic;
  final int gicAim;
  final double gicStar;

  final int ra;
  final int raAim;
  final double raStar;

  final int nu;
  final int nuAim;
  final double nuStar;

  final int rankedGap;
  final int rankedGapPractices;

  final int rankedRa;
  final int rankedRaPractices;

  final int rankedNu;
  final int rankedNuPractices;

  const PracticeDetails({
    required this.practiceId,
    required this.practiceName,
    required this.patients,
    required this.gic,
    required this.gicAim,
    required this.gicStar,
    required this.ra,
    required this.raAim,
    required this.raStar,
    required this.nu,
    required this.nuAim,
    required this.nuStar,
    required this.rankedGap,
    required this.rankedGapPractices,
    required this.rankedRa,
    required this.rankedRaPractices,
    required this.rankedNu,
    required this.rankedNuPractices,
  });

  /// Fábrica con todos los valores en cero (y strings vacíos)
  factory PracticeDetails.empty() => const PracticeDetails(
        practiceId: "0",
        practiceName: "",
        patients: 0,
        gic: 0,
        gicAim: 0,
        gicStar: 0.0,
        ra: 0,
        raAim: 0,
        raStar: 0.0,
        nu: 0,
        nuAim: 0,
        nuStar: 0.0,
        rankedGap: 0,
        rankedGapPractices: 0,
        rankedRa: 0,
        rankedRaPractices: 0,
        rankedNu: 0,
        rankedNuPractices: 0,
      );

  factory PracticeDetails.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic v) => int.tryParse(v?.toString() ?? "") ?? 0;
    double _toDouble(dynamic v) => double.tryParse(v?.toString() ?? "") ?? 0.0;

    return PracticeDetails(
      practiceId: json['practice_id']?.toString() ?? "0",
      practiceName: json['practice_name']?.toString() ?? "",
      patients: _toInt(json['patients']),
      gic: _toInt(json['gic']),
      gicAim: _toInt(json['gic_aim']),
      gicStar: _toDouble(json['gic_star']),
      ra: _toInt(json['ra']),
      raAim: _toInt(json['ra_aim']),
      raStar: _toDouble(json['ra_star']),
      nu: _toInt(json['nu']),
      nuAim: _toInt(json['nu_aim']),
      nuStar: _toDouble(json['nu_star']),
      rankedGap: _toInt(json['ranked_gap']),
      rankedGapPractices: _toInt(json['ranked_gap_practices']),
      rankedRa: _toInt(json['ranked_ra']),
      rankedRaPractices: _toInt(json['ranked_ra_practices']),
      rankedNu: _toInt(json['ranked_nu']),
      rankedNuPractices: _toInt(json['ranked_nu_practices']),
    );
  }

  Map<String, dynamic> toJson() => {
        "practice_id": practiceId,
        "practice_name": practiceName,
        "patients": patients,
        "gic": gic,
        "gic_aim": gicAim,
        "gic_star": gicStar,
        "ra": ra,
        "ra_aim": raAim,
        "ra_star": raStar,
        "nu": nu,
        "nu_aim": nuAim,
        "nu_star": nuStar,
        "ranked_gap": rankedGap,
        "ranked_gap_practices": rankedGapPractices,
        "ranked_ra": rankedRa,
        "ranked_ra_practices": rankedRaPractices,
        "ranked_nu": rankedNu,
        "ranked_nu_practices": rankedNuPractices,
      };
}
