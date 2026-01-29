part of 'leave_bloc.dart';

class LeaveState extends BlocEventState<List<LeaveRequestResponse>> {
  final List<LeaveTypeResponse> leaveTypes;
  final List<LeaveRequestResponse> myLeaves;
  final List<LeaveRequestResponse> pendingApprovals;
  final List<LeaveRequestResponse> allRequests;
  final List<LeaveBalanceResponse> balances;
  final LeaveSummaryResponse? summary;
  final bool leaveApplied;
  final bool actionCompleted;

  const LeaveState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.leaveTypes = const [],
    this.myLeaves = const [],
    this.pendingApprovals = const [],
    this.allRequests = const [],
    this.balances = const [],
    this.summary,
    this.leaveApplied = false,
    this.actionCompleted = false,
  });

  @override
  LeaveState copyWith({
    BlocState? state,
    List<LeaveRequestResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<LeaveTypeResponse>? leaveTypes,
    List<LeaveRequestResponse>? myLeaves,
    List<LeaveRequestResponse>? pendingApprovals,
    List<LeaveRequestResponse>? allRequests,
    List<LeaveBalanceResponse>? balances,
    LeaveSummaryResponse? summary,
    bool? leaveApplied,
    bool? actionCompleted,
  }) {
    return LeaveState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      leaveTypes: leaveTypes ?? this.leaveTypes,
      myLeaves: myLeaves ?? this.myLeaves,
      pendingApprovals: pendingApprovals ?? this.pendingApprovals,
      allRequests: allRequests ?? this.allRequests,
      balances: balances ?? this.balances,
      summary: summary ?? this.summary,
      leaveApplied: leaveApplied ?? false,
      actionCompleted: actionCompleted ?? false,
    );
  }

  @override
  LeaveState clear({BlocState? state, BlocEvent? event}) =>
      LeaveState(state: state ?? super.state, event: event);
}
