class PocketQualityCode {
  final int id;
  final int categoryId;
  final String code;
  final String description;
  final String classification;
  final bool isEnabled;
  final DateTime created;
  final DateTime modified;

  PocketQualityCode({
    required this.id,
    required this.categoryId,
    required this.code,
    required this.description,
    required this.classification,
    required this.isEnabled,
    required this.created,
    required this.modified,
  });

  factory PocketQualityCode.fromJson(Map<String, dynamic> json) {
    DateTime _toDate(dynamic v) => DateTime.parse(v.toString());
    bool _toBool(dynamic v) => v is bool
        ? v
        : (v is num ? v != 0 : v.toString().toLowerCase() == 'true');

    return PocketQualityCode(
      id: json['id'] ?? 0,
      categoryId: json['category'] ?? 0,
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      classification: json['classification']?.toString() ?? '',
      isEnabled: _toBool(json['is_enabled']),
      created: _toDate(json['created']),
      modified: _toDate(json['modified']),
    );
  }
}

class PocketQualityCategory {
  final int id;
  final String name;
  final bool isEnabled;
  final PocketQualityParent? parent; // Datos resumidos del padre
  final DateTime created;
  final DateTime modified;
  final List<PocketQualityCode> codes;

  PocketQualityCategory({
    required this.id,
    required this.name,
    required this.isEnabled,
    this.parent,
    required this.created,
    required this.modified,
    required this.codes,
  });

  factory PocketQualityCategory.fromJson(Map<String, dynamic> json) {
    DateTime _toDate(dynamic v) => DateTime.parse(v.toString());
    bool _toBool(dynamic v) => v is bool
        ? v
        : (v is num ? v != 0 : v.toString().toLowerCase() == 'true');

    return PocketQualityCategory(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      isEnabled: _toBool(json['is_enabled']),
      parent: json['category_parent'] != null
          ? PocketQualityParent.fromJson(json['category_parent'])
          : null,
      created: _toDate(json['created']),
      modified: _toDate(json['modified']),
      codes: (json['codes'] as List<dynamic>? ?? [])
          .map((e) => PocketQualityCode.fromJson(e))
          .toList(),
    );
  }
}

/// Solo datos mínimos del padre para evitar ciclos infinitos
class PocketQualityParent {
  final int id;
  final String name;
  final bool isEnabled;
  final DateTime created;
  final DateTime modified;

  PocketQualityParent({
    required this.id,
    required this.name,
    required this.isEnabled,
    required this.created,
    required this.modified,
  });

  factory PocketQualityParent.fromJson(Map<String, dynamic> json) {
    DateTime _toDate(dynamic v) => DateTime.parse(v.toString());
    bool _toBool(dynamic v) => v is bool
        ? v
        : (v is num ? v != 0 : v.toString().toLowerCase() == 'true');

    return PocketQualityParent(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      isEnabled: _toBool(json['is_enabled']),
      created: _toDate(json['created']),
      modified: _toDate(json['modified']),
    );
  }
}

class PocketGuide {
  final int id;
  final String name;
  final bool isEnabled;
  final DateTime created;
  final DateTime modified;
  final List<PocketQualityCategory>
      categories; // se llena cuando se consulta por categorías

  PocketGuide({
    required this.id,
    required this.name,
    required this.isEnabled,
    required this.created,
    required this.modified,
    this.categories = const [],
  });

  factory PocketGuide.fromJson(Map<String, dynamic> json) {
    DateTime _toDate(dynamic v) => DateTime.parse(v.toString());
    bool _toBool(dynamic v) => v is bool
        ? v
        : (v is num ? v != 0 : v.toString().toLowerCase() == 'true');

    return PocketGuide(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      isEnabled: _toBool(json['is_enabled']),
      created: _toDate(json['created']),
      modified: _toDate(json['modified']),
      // Normalmente vendrá vacío en la consulta inicial
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((e) => PocketQualityCategory.fromJson(e))
          .toList(),
    );
  }

  PocketGuide copyWith({List<PocketQualityCategory>? categories}) {
    return PocketGuide(
      id: id,
      name: name,
      isEnabled: isEnabled,
      created: created,
      modified: modified,
      categories: categories ?? this.categories,
    );
  }
}

class PocketRaChild {
  final String hccCode;
  final String childDescription;
  final int detailId;
  final String diagnosisCode;
  final String diagnosisCodeDescription;
  final String model;

  PocketRaChild({
    required this.hccCode,
    required this.childDescription,
    required this.detailId,
    required this.diagnosisCode,
    required this.diagnosisCodeDescription,
    required this.model,
  });

  factory PocketRaChild.fromJson(Map<String, dynamic> json) {
    return PocketRaChild(
      hccCode: json['hcc_code'] ?? '',
      childDescription: json['child_description'] ?? '',
      detailId: json['detail_id'] ?? 0,
      diagnosisCode: json['diagnosis_code'] ?? '',
      diagnosisCodeDescription: json['diagnosis_code_description'] ?? '',
      model: json['model'] ?? '',
    );
  }
}

class PocketRaParent {
  final int id;
  final String parentName;
  final List<PocketRaChild> childs;

  PocketRaParent({
    required this.id,
    required this.parentName,
    required this.childs,
  });

  factory PocketRaParent.fromJson(Map<String, dynamic> json) {
    final childsJson = json['childs'] as List? ?? [];
    return PocketRaParent(
      id: json['id'] ?? 0,
      parentName: json['parent_name'] ?? '',
      childs: childsJson.map((c) => PocketRaChild.fromJson(c)).toList(),
    );
  }
}
