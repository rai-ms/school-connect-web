part of 'subject_bloc.dart';

class SubjectState extends BlocEventState<List<SubjectResponse>> {
  final List<SubjectResponse> subjects;
  final SubjectResponse? selectedSubject;
  final bool actionCompleted;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool isLoadingMore;

  const SubjectState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.subjects = const [],
    this.selectedSubject,
    this.actionCompleted = false,
    this.currentPage = 0,
    this.totalPages = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  SubjectState copyWith({
    BlocState? state,
    List<SubjectResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<SubjectResponse>? subjects,
    SubjectResponse? selectedSubject,
    bool? actionCompleted,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SubjectState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      subjects: subjects ?? this.subjects,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      actionCompleted: actionCompleted ?? false,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  SubjectState clear({BlocState? state, BlocEvent? event}) =>
      SubjectState(state: state ?? super.state, event: event);
}
