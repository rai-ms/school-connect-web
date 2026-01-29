part of 'attendance_bloc.dart';

class AttendanceState extends BlocEventState<List<AttendanceResponse>> {
  final List<AttendanceResponse> records;
  final AttendancePercentage? percentage;
  final bool attendanceMarked;

  const AttendanceState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.records = const [],
    this.percentage,
    this.attendanceMarked = false,
  });

  @override
  AttendanceState copyWith({
    BlocState? state,
    List<AttendanceResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<AttendanceResponse>? records,
    AttendancePercentage? percentage,
    bool? attendanceMarked,
  }) {
    return AttendanceState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      records: records ?? this.records,
      percentage: percentage ?? this.percentage,
      attendanceMarked: attendanceMarked ?? false,
    );
  }

  @override
  AttendanceState clear({BlocState? state, BlocEvent? event}) =>
      AttendanceState(state: state ?? super.state, event: event);
}
