class PanelDetail {
  final String mcoName;
  final String lob;
  final int members;

  const PanelDetail({
    required this.mcoName,
    required this.lob,
    required this.members,
  });

  factory PanelDetail.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

    return PanelDetail(
      mcoName: json['mco_name']?.toString() ?? '',
      lob: json['lob']?.toString() ?? '',
      members: _toInt(json['members']),
    );
  }

  Map<String, dynamic> toJson() => {
        'mco_name': mcoName,
        'lob': lob,
        'members': members,
      };
}
