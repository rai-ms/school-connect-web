class MarkAttendanceRequest {
  final String attendanceDate;
  final String classId;
  final String? sectionId;
  final String? subject;
  final String session;
  final List<StudentAttendanceRecord> studentAttendance;

  MarkAttendanceRequest({
    required this.attendanceDate,
    required this.classId,
    this.sectionId,
    this.subject,
    this.session = 'FULL_DAY',
    required this.studentAttendance,
  });

  Map<String, dynamic> toJson() => {
        'attendanceDate': attendanceDate,
        'classId': classId,
        if (sectionId != null) 'sectionId': sectionId,
        if (subject != null) 'subject': subject,
        'session': session,
        'studentAttendance':
            studentAttendance.map((s) => s.toJson()).toList(),
      };
}

class StudentAttendanceRecord {
  final String studentId;
  String status;
  String? remarks;

  StudentAttendanceRecord({
    required this.studentId,
    this.status = 'PRESENT',
    this.remarks,
  });

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'status': status,
        if (remarks != null) 'remarks': remarks,
      };
}

class AttendanceResponse {
  final String id;
  final String studentId;
  final String? studentName;
  final String? rollNumber;
  final String? classId;
  final String? sectionId;
  final String attendanceDate;
  final String status;
  final String? session;
  final String? subject;
  final String? markedByTeacherId;
  final String? markedByTeacherName;
  final String? markedAt;
  final String? remarks;

  AttendanceResponse({
    required this.id,
    required this.studentId,
    this.studentName,
    this.rollNumber,
    this.classId,
    this.sectionId,
    required this.attendanceDate,
    required this.status,
    this.session,
    this.subject,
    this.markedByTeacherId,
    this.markedByTeacherName,
    this.markedAt,
    this.remarks,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      id: json['id']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      studentName: json['studentName'],
      rollNumber: json['rollNumber'],
      classId: json['classId']?.toString(),
      sectionId: json['sectionId']?.toString(),
      attendanceDate: json['attendanceDate'] ?? '',
      status: json['status'] ?? 'PRESENT',
      session: json['session'],
      subject: json['subject'],
      markedByTeacherId: json['markedByTeacherId']?.toString(),
      markedByTeacherName: json['markedByTeacherName'],
      markedAt: json['markedAt'],
      remarks: json['remarks'],
    );
  }

  bool get isPresent => status == 'PRESENT';
  bool get isAbsent => status == 'ABSENT';
  bool get isLate => status == 'LATE';
  bool get isHalfDay => status == 'HALF_DAY';
  bool get isExcused => status == 'EXCUSED_ABSENCE';

  String get statusLabel {
    switch (status) {
      case 'PRESENT':
        return 'Present';
      case 'ABSENT':
        return 'Absent';
      case 'LATE':
        return 'Late';
      case 'HALF_DAY':
        return 'Half Day';
      case 'EXCUSED_ABSENCE':
        return 'Excused';
      default:
        return status;
    }
  }
}

class AttendancePercentage {
  final double percentage;
  final int totalDays;
  final int presentDays;
  final int absentDays;
  final int lateDays;

  AttendancePercentage({
    this.percentage = 0,
    this.totalDays = 0,
    this.presentDays = 0,
    this.absentDays = 0,
    this.lateDays = 0,
  });

  factory AttendancePercentage.fromJson(Map<String, dynamic> json) {
    return AttendancePercentage(
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      totalDays: json['totalDays'] ?? 0,
      presentDays: json['presentDays'] ?? 0,
      absentDays: json['absentDays'] ?? 0,
      lateDays: json['lateDays'] ?? 0,
    );
  }
}
