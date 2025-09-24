class Mco {
  final int ownerId;
  final int practiceId;
  final int mcoId;
  final String mcoName;

  Mco({
    required this.ownerId,
    required this.practiceId,
    required this.mcoId,
    required this.mcoName,
  });

  factory Mco.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return Mco(
      ownerId: _toInt(json['owner_id']),
      practiceId: _toInt(json['practice_id']),
      mcoId: _toInt(json['mco_id']),
      mcoName: json['mco_name']?.toString() ?? '',
    );
  }
}
