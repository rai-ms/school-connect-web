part of 'exam_bloc.dart';

class ExamState extends BlocEventState<List<ExamResponse>> {
  final List<ExamTypeResponse> examTypes;
  final List<ExamResponse> exams;
  final List<ExamResponse> upcomingExams;
  final ExamResponse? selectedExam;
  final List<ExamResultResponse> examResults;
  final List<ExamResultResponse> studentResults;
  final ExamStatistics? statistics;
  final ReportCard? reportCard;

  const ExamState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.examTypes = const [],
    this.exams = const [],
    this.upcomingExams = const [],
    this.selectedExam,
    this.examResults = const [],
    this.studentResults = const [],
    this.statistics,
    this.reportCard,
  });

  @override
  ExamState copyWith({
    BlocState? state,
    List<ExamResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<ExamTypeResponse>? examTypes,
    List<ExamResponse>? exams,
    List<ExamResponse>? upcomingExams,
    ExamResponse? selectedExam,
    List<ExamResultResponse>? examResults,
    List<ExamResultResponse>? studentResults,
    ExamStatistics? statistics,
    ReportCard? reportCard,
  }) {
    return ExamState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      examTypes: examTypes ?? this.examTypes,
      exams: exams ?? this.exams,
      upcomingExams: upcomingExams ?? this.upcomingExams,
      selectedExam: selectedExam ?? this.selectedExam,
      examResults: examResults ?? this.examResults,
      studentResults: studentResults ?? this.studentResults,
      statistics: statistics ?? this.statistics,
      reportCard: reportCard ?? this.reportCard,
    );
  }

  @override
  ExamState clear({BlocState? state, BlocEvent? event}) =>
      ExamState(state: state ?? super.state, event: event);
}
