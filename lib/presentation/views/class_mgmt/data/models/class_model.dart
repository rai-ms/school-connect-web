class CreateClassRequest {
  final String code;
  final String name;
  final String? description;
  final List<CreateSectionRequest>? sections;

  CreateClassRequest({
    required this.code,
    required this.name,
    this.description,
    this.sections,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        if (description != null) 'description': description,
        if (sections != null)
          'sections': sections!.map((s) => s.toJson()).toList(),
      };
}

class CreateSectionRequest {
  final String name;
  final int? capacity;
  final String? schoolClassId;

  CreateSectionRequest({
    required this.name,
    this.capacity,
    this.schoolClassId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (capacity != null) 'capacity': capacity,
        if (schoolClassId != null) 'schoolClassId': schoolClassId,
      };
}

class SchoolClassResponse {
  final String id;
  final String code;
  final String name;
  final String? description;
  final List<SectionResponse> sections;
  final DateTime? createdAt;

  SchoolClassResponse({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.sections = const [],
    this.createdAt,
  });

  factory SchoolClassResponse.fromJson(Map<String, dynamic> json) {
    return SchoolClassResponse(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      sections: (json['sections'] as List? ?? [])
          .map((s) => SectionResponse.fromJson(s))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  String get displayName => name.isNotEmpty ? name : 'Class $code';
  int get totalCapacity =>
      sections.fold(0, (sum, s) => sum + (s.capacity ?? 0));
}

class SectionResponse {
  final String id;
  final String name;
  final int? capacity;
  final String? schoolClassId;
  final String? schoolClassCode;
  final String? schoolClassName;
  final String? classTeacherId;
  final String? classTeacherName;

  SectionResponse({
    required this.id,
    required this.name,
    this.capacity,
    this.schoolClassId,
    this.schoolClassCode,
    this.schoolClassName,
    this.classTeacherId,
    this.classTeacherName,
  });

  factory SectionResponse.fromJson(Map<String, dynamic> json) {
    return SectionResponse(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      capacity: json['capacity'],
      schoolClassId: json['schoolClassId']?.toString(),
      schoolClassCode: json['schoolClassCode'],
      schoolClassName: json['schoolClassName'],
      classTeacherId: json['classTeacherId']?.toString(),
      classTeacherName: json['classTeacherName'],
    );
  }

  String get displayName {
    if (schoolClassName != null) return '$schoolClassName - $name';
    return name;
  }
}
