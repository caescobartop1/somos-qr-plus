class Schedule {
  final int id;
  final String memberName;
  final DateTime day;
  final int gic;
  final int ra;
  final int memberPlanId;
  final DateTime? dob;
  final int provider;
  final int patientId;
  final String providerName;
  final String practiceDin;
  final String appointmentNpi;
  final String billingTin;
  final String source;
  final String cancelable;
  final String status;
  final bool visited;
  final bool unread;
  final String? treatedProviderName;
  final DateTime? created;
  final DateTime? modified;

  Schedule({
    required this.id,
    required this.memberName,
    required this.day,
    required this.gic,
    required this.ra,
    required this.memberPlanId,
    this.dob,
    required this.provider,
    required this.patientId,
    required this.providerName,
    required this.practiceDin,
    required this.appointmentNpi,
    required this.billingTin,
    required this.source,
    required this.cancelable,
    required this.status,
    required this.visited,
    required this.unread,
    this.treatedProviderName,
    this.created,
    this.modified,
  });
  factory Schedule.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    String _toString(dynamic v) => v?.toString() ?? '';

    DateTime _toDateRequired(dynamic v) {
      // lanza si viene nulo/empty: ajusta si prefieres valor por defecto
      final s = v?.toString();
      if (s == null || s.isEmpty) {
        throw FormatException('Missing required DateTime field');
      }
      final dt = DateTime.tryParse(s);
      if (dt == null) throw FormatException('Invalid DateTime: $s');
      return dt;
    }

    DateTime? _toDateOptional(dynamic v) {
      final s = v?.toString();
      if (s == null || s.isEmpty) return null;
      return DateTime.tryParse(s);
    }

    bool _toBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) return v.toLowerCase() == 'true' || v == '1';
      return false;
    }

    return Schedule(
      id: _toInt(json['id']),
      memberName: _toString(json['member_name']),
      day: _toDateRequired(json['day']),
      gic: _toInt(json['gic']),
      ra: _toInt(json['ra']),
      memberPlanId: _toInt(json['member_plan_id']),
      dob: _toDateOptional(json['dob']),
      provider: _toInt(json['provider']),
      patientId: _toInt(json['patient_id']),
      providerName: _toString(json['provider_name']),
      practiceDin: _toString(json['practice_din']),
      appointmentNpi: _toString(json['appointment_npi']),
      billingTin: _toString(json['billing_tin']),
      source: _toString(json['source']),
      cancelable: _toString(json['cancelable']),
      status: _toString(json['status']),
      visited: _toBool(json['visited']),
      unread: _toBool(json['unread']),
      treatedProviderName: json['treated_provider_name'] != null
          ? _toString(json['treated_provider_name'])
          : null,
      created: _toDateOptional(json['created']),
      modified: _toDateOptional(json['modified']),
    );
  }
}
