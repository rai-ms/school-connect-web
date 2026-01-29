part of 'student_bloc.dart';

class StudentState extends BlocEventState<List<StudentResponse>> {
  final List<StudentResponse> students;
  final StudentResponse? selectedStudent;
  final StudentStatistics? statistics;
  final bool actionCompleted;

  const StudentState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.students = const [],
    this.selectedStudent,
    this.statistics,
    this.actionCompleted = false,
  });

  @override
  StudentState copyWith({
    BlocState? state,
    List<StudentResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<StudentResponse>? students,
    StudentResponse? selectedStudent,
    StudentStatistics? statistics,
    bool? actionCompleted,
  }) {
    return StudentState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      students: students ?? this.students,
      selectedStudent: selectedStudent ?? this.selectedStudent,
      statistics: statistics ?? this.statistics,
      actionCompleted: actionCompleted ?? false,
    );
  }

  @override
  StudentState clear({BlocState? state, BlocEvent? event}) =>
      StudentState(state: state ?? super.state, event: event);
}
