part of 'student_bloc.dart';

class StudentState extends BlocEventState<List<StudentResponse>> {
  final List<StudentResponse> students;
  final StudentResponse? selectedStudent;
  final StudentStatistics? statistics;
  final bool actionCompleted;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool isLoadingMore;
  final BulkImportResult? importResult;
  final String? exportedFilePath;

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
    this.currentPage = 0,
    this.totalPages = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.importResult,
    this.exportedFilePath,
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
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    bool? isLoadingMore,
    BulkImportResult? importResult,
    String? exportedFilePath,
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
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      importResult: importResult ?? this.importResult,
      exportedFilePath: exportedFilePath ?? this.exportedFilePath,
    );
  }

  @override
  StudentState clear({BlocState? state, BlocEvent? event}) =>
      StudentState(state: state ?? super.state, event: event);
}
