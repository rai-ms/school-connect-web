class ExamTypeRequest {
  final String name;
  final String? description;
  final double? weightage;
  final int? maxMarks;
  final int? passingMarks;
  final bool? isActive;
  final int? displayOrder;

  ExamTypeRequest({
    required this.name,
    this.description,
    this.weightage,
    this.maxMarks,
    this.passingMarks,
    this.isActive,
    this.displayOrder,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        if (weightage != null) 'weightage': weightage,
        if (maxMarks != null) 'maxMarks': maxMarks,
        if (passingMarks != null) 'passingMarks': passingMarks,
        if (isActive != null) 'isActive': isActive,
        if (displayOrder != null) 'displayOrder': displayOrder,
      };
}

class ExamTypeResponse {
  final String id;
  final String name;
  final String? description;
  final double? weightage;
  final int? maxMarks;
  final int? passingMarks;
  final bool isActive;
  final int displayOrder;
  final DateTime? createdAt;

  ExamTypeResponse({
    required this.id,
    required this.name,
    this.description,
    this.weightage,
    this.maxMarks,
    this.passingMarks,
    this.isActive = true,
    this.displayOrder = 0,
    this.createdAt,
  });

  factory ExamTypeResponse.fromJson(Map<String, dynamic> json) {
    return ExamTypeResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      weightage: (json['weightage'] as num?)?.toDouble(),
      maxMarks: json['maxMarks'] as int?,
      passingMarks: json['passingMarks'] as int?,
      isActive: json['isActive'] ?? true,
      displayOrder: json['displayOrder'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'weightage': weightage,
        'maxMarks': maxMarks,
        'passingMarks': passingMarks,
        'isActive': isActive,
        'displayOrder': displayOrder,
      };
}
