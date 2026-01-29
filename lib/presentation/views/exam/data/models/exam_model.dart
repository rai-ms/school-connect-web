import 'exam_type_model.dart';

class ExamRequest {
  final String name;
  final String? description;
  final String examTypeId;
  final String classId;
  final String? section;
  final String? subjectId;
  final String? subjectName;
  final String examDate;
  final String? startTime;
  final String? endTime;
  final int maxMarks;
  final int? passingMarks;
  final String? room;
  final String? status;
  final String? academicYear;
  final String? instructions;

  ExamRequest({
    required this.name,
    this.description,
    required this.examTypeId,
    required this.classId,
    this.section,
    this.subjectId,
    this.subjectName,
    required this.examDate,
    this.startTime,
    this.endTime,
    this.maxMarks = 100,
    this.passingMarks,
    this.room,
    this.status,
    this.academicYear,
    this.instructions,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        'examTypeId': examTypeId,
        'classId': classId,
        if (section != null) 'section': section,
        if (subjectId != null) 'subjectId': subjectId,
        if (subjectName != null) 'subjectName': subjectName,
        'examDate': examDate,
        if (startTime != null) 'startTime': startTime,
        if (endTime != null) 'endTime': endTime,
        'maxMarks': maxMarks,
        if (passingMarks != null) 'passingMarks': passingMarks,
        if (room != null) 'room': room,
        if (status != null) 'status': status,
        if (academicYear != null) 'academicYear': academicYear,
        if (instructions != null) 'instructions': instructions,
      };
}

class ExamResponse {
  final String id;
  final String name;
  final String? description;
  final ExamTypeResponse? examType;
  final String? classId;
  final String? section;
  final String? subjectId;
  final String? subjectName;
  final String? examDate;
  final String? startTime;
  final String? endTime;
  final int maxMarks;
  final int passingMarks;
  final String? room;
  final String status;
  final String? academicYear;
  final String? instructions;
  final DateTime? createdAt;

  ExamResponse({
    required this.id,
    required this.name,
    this.description,
    this.examType,
    this.classId,
    this.section,
    this.subjectId,
    this.subjectName,
    this.examDate,
    this.startTime,
    this.endTime,
    this.maxMarks = 100,
    this.passingMarks = 33,
    this.room,
    this.status = 'SCHEDULED',
    this.academicYear,
    this.instructions,
    this.createdAt,
  });

  factory ExamResponse.fromJson(Map<String, dynamic> json) {
    return ExamResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      examType: json['examType'] != null
          ? ExamTypeResponse.fromJson(json['examType'])
          : null,
      classId: json['classId'],
      section: json['section'],
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
      examDate: json['examDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      maxMarks: json['maxMarks'] ?? 100,
      passingMarks: json['passingMarks'] ?? 33,
      room: json['room'],
      status: json['status'] ?? 'SCHEDULED',
      academicYear: json['academicYear'],
      instructions: json['instructions'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  bool get isUpcoming {
    if (examDate == null) return false;
    final date = DateTime.tryParse(examDate!);
    return date != null && date.isAfter(DateTime.now());
  }

  bool get isCompleted => status == 'COMPLETED';
  bool get isScheduled => status == 'SCHEDULED';
  bool get isCancelled => status == 'CANCELLED';
}
