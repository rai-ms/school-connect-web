import 'period_model.dart';

class TimetableEntryRequest {
  final String dayOfWeek;
  final String periodId;
  final String classId;
  final String? section;
  final String? subjectId;
  final String? subjectName;
  final String? teacherId;
  final String? teacherName;
  final String? room;
  final String? academicYear;

  TimetableEntryRequest({
    required this.dayOfWeek,
    required this.periodId,
    required this.classId,
    this.section,
    this.subjectId,
    this.subjectName,
    this.teacherId,
    this.teacherName,
    this.room,
    this.academicYear,
  });

  Map<String, dynamic> toJson() => {
        'dayOfWeek': dayOfWeek,
        'period': {'id': periodId},
        'classId': classId,
        if (section != null) 'section': section,
        if (subjectId != null) 'subjectId': subjectId,
        if (subjectName != null) 'subjectName': subjectName,
        if (teacherId != null) 'teacherId': teacherId,
        if (teacherName != null) 'teacherName': teacherName,
        if (room != null) 'room': room,
        if (academicYear != null) 'academicYear': academicYear,
      };
}

class TimetableEntryResponse {
  final String id;
  final String dayOfWeek;
  final PeriodResponse? period;
  final String? classId;
  final String? section;
  final String? subjectId;
  final String? subjectName;
  final String? teacherId;
  final String? teacherName;
  final String? room;
  final bool isActive;
  final String? academicYear;

  TimetableEntryResponse({
    required this.id,
    required this.dayOfWeek,
    this.period,
    this.classId,
    this.section,
    this.subjectId,
    this.subjectName,
    this.teacherId,
    this.teacherName,
    this.room,
    this.isActive = true,
    this.academicYear,
  });

  factory TimetableEntryResponse.fromJson(Map<String, dynamic> json) {
    return TimetableEntryResponse(
      id: json['id'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? '',
      period: json['period'] != null
          ? PeriodResponse.fromJson(json['period'])
          : null,
      classId: json['classId'],
      section: json['section'],
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
      teacherId: json['teacherId'],
      teacherName: json['teacherName'],
      room: json['room'],
      isActive: json['isActive'] ?? true,
      academicYear: json['academicYear'],
    );
  }
}
