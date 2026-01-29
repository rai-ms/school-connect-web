part of 'teacher_bloc.dart';

class TeacherState extends BlocEventState<List<TeacherResponse>> {
  final List<TeacherResponse> teachers;
  final TeacherResponse? selectedTeacher;
  final bool actionCompleted;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool isLoadingMore;

  const TeacherState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.teachers = const [],
    this.selectedTeacher,
    this.actionCompleted = false,
    this.currentPage = 0,
    this.totalPages = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
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
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    bool? isLoadingMore,
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
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  TeacherState clear({BlocState? state, BlocEvent? event}) =>
      TeacherState(state: state ?? super.state, event: event);
}
