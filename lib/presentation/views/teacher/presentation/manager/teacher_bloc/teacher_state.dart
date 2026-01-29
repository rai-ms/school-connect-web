part of 'teacher_bloc.dart';

class TeacherState extends BlocEventState<List<TeacherResponse>> {
  final List<TeacherResponse> teachers;
  final TeacherResponse? selectedTeacher;
  final bool actionCompleted;

  const TeacherState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.teachers = const [],
    this.selectedTeacher,
    this.actionCompleted = false,
  });

  @override
  TeacherState copyWith({
    BlocState? state,
    List<TeacherResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<TeacherResponse>? teachers,
    TeacherResponse? selectedTeacher,
    bool? actionCompleted,
  }) {
    return TeacherState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      teachers: teachers ?? this.teachers,
      selectedTeacher: selectedTeacher ?? this.selectedTeacher,
      actionCompleted: actionCompleted ?? false,
    );
  }

  @override
  TeacherState clear({BlocState? state, BlocEvent? event}) =>
      TeacherState(state: state ?? super.state, event: event);
}
