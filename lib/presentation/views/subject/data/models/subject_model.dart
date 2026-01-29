class CreateSubjectRequest {
  final String name;
  final String code;
  final String? description;
  final String? type;
  final int? creditHours;
  final int? maxMarks;
  final int? passingMarks;
  final String? academicYear;
  final String? department;
  final bool? isActive;
  final List<String>? classIds;
  final List<String>? teacherIds;
  final List<String>? prerequisites;
  final List<String>? learningObjectives;

  CreateSubjectRequest({
    required this.name,
    required this.code,
    this.description,
    this.type,
    this.creditHours,
    this.maxMarks,
    this.passingMarks,
    this.academicYear,
    this.department,
    this.isActive = true,
    this.classIds,
    this.teacherIds,
    this.prerequisites,
    this.learningObjectives,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        if (description != null) 'description': description,
        if (type != null) 'type': type,
        if (creditHours != null) 'creditHours': creditHours,
        if (maxMarks != null) 'maxMarks': maxMarks,
        if (passingMarks != null) 'passingMarks': passingMarks,
        if (academicYear != null) 'academicYear': academicYear,
        if (department != null) 'department': department,
        if (isActive != null) 'isActive': isActive,
        if (classIds != null) 'classIds': classIds,
        if (teacherIds != null) 'teacherIds': teacherIds,
        if (prerequisites != null) 'prerequisites': prerequisites,
        if (learningObjectives != null)
          'learningObjectives': learningObjectives,
      };
}

class SubjectResponse {
  final String id;
  final String code;
  final String name;
  final String? description;
  final String type;
  final int? creditHours;
  final int? maxMarks;
  final int? passingMarks;
  final String? academicYear;
  final String? department;
  final bool isActive;
  final List<String> prerequisites;
  final List<String> learningObjectives;
  final String? createdAt;
  final String? updatedAt;

  SubjectResponse({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.type = 'CORE',
    this.creditHours,
    this.maxMarks,
    this.passingMarks,
    this.academicYear,
    this.department,
    this.isActive = true,
    this.prerequisites = const [],
    this.learningObjectives = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory SubjectResponse.fromJson(Map<String, dynamic> json) {
    return SubjectResponse(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      type: json['type'] ?? 'CORE',
      creditHours: json['creditHours'],
      maxMarks: json['maxMarks'],
      passingMarks: json['passingMarks'],
      academicYear: json['academicYear'],
      department: json['department'],
      isActive: json['isActive'] ?? json['active'] ?? true,
      prerequisites: (json['prerequisites'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      learningObjectives: (json['learningObjectives'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  String get typeLabel {
    switch (type) {
      case 'CORE':
        return 'Core';
      case 'ELECTIVE':
        return 'Elective';
      case 'EXTRA_CURRICULAR':
        return 'Extra Curricular';
      default:
        return type;
    }
  }

  String get initials {
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}
