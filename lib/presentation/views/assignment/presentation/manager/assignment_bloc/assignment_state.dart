part of 'assignment_bloc.dart';

class AssignmentState extends BlocEventState<List<AssignmentResponse>> {
  final List<AssignmentResponse> assignments;
  final AssignmentResponse? selectedAssignment;
  final List<AssignmentSubmissionResponse> submissions;
  final AssignmentStatistics? statistics;
  final bool actionCompleted;

  const AssignmentState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.assignments = const [],
    this.selectedAssignment,
    this.submissions = const [],
    this.statistics,
    this.actionCompleted = false,
  });

  @override
  AssignmentState copyWith({
    BlocState? state,
    List<AssignmentResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<AssignmentResponse>? assignments,
    AssignmentResponse? selectedAssignment,
    List<AssignmentSubmissionResponse>? submissions,
    AssignmentStatistics? statistics,
    bool? actionCompleted,
  }) {
    return AssignmentState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      assignments: assignments ?? this.assignments,
      selectedAssignment: selectedAssignment ?? this.selectedAssignment,
      submissions: submissions ?? this.submissions,
      statistics: statistics ?? this.statistics,
      actionCompleted: actionCompleted ?? false,
    );
  }

  @override
  AssignmentState clear({BlocState? state, BlocEvent? event}) =>
      AssignmentState(state: state ?? super.state, event: event);
}
