part of 'attendance_bloc.dart';

class AttendanceEvent extends BlocEvent {
  const AttendanceEvent();
}

class MarkBulkAttendance extends AttendanceEvent {
  final MarkAttendanceRequest request;
  const MarkBulkAttendance(this.request);
}

class FetchClassAttendance extends AttendanceEvent {
  final String classId;
  final String date;
  const FetchClassAttendance(this.classId, this.date);
}

class FetchStudentAttendance extends AttendanceEvent {
  final String studentId;
  const FetchStudentAttendance(this.studentId);
}

class FetchStudentAttendancePercentage extends AttendanceEvent {
  final String studentId;
  const FetchStudentAttendancePercentage(this.studentId);
}

class FetchAttendanceByDate extends AttendanceEvent {
  final String date;
  const FetchAttendanceByDate(this.date);
}
