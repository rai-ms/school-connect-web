part of 'leave_bloc.dart';

class LeaveEvent extends BlocEvent {
  const LeaveEvent();
}

// Leave Types
class FetchLeaveTypes extends LeaveEvent {
  const FetchLeaveTypes();
}

class FetchActiveLeaveTypes extends LeaveEvent {
  const FetchActiveLeaveTypes();
}

class CreateLeaveType extends LeaveEvent {
  final LeaveTypeRequest request;
  const CreateLeaveType(this.request);
}

class UpdateLeaveType extends LeaveEvent {
  final String id;
  final LeaveTypeRequest request;
  const UpdateLeaveType(this.id, this.request);
}

class DeleteLeaveType extends LeaveEvent {
  final String id;
  const DeleteLeaveType(this.id);
}

// Leave Requests
class ApplyLeave extends LeaveEvent {
  final LeaveRequestCreate request;
  const ApplyLeave(this.request);
}

class FetchMyLeaves extends LeaveEvent {
  const FetchMyLeaves();
}

class FetchPendingApprovals extends LeaveEvent {
  const FetchPendingApprovals();
}

class FetchAllLeaveRequests extends LeaveEvent {
  const FetchAllLeaveRequests();
}

class ApproveLeave extends LeaveEvent {
  final String id;
  final String? remarks;
  const ApproveLeave(this.id, {this.remarks});
}

class RejectLeave extends LeaveEvent {
  final String id;
  final String? remarks;
  const RejectLeave(this.id, {this.remarks});
}

class CancelLeave extends LeaveEvent {
  final String id;
  const CancelLeave(this.id);
}

// Leave Balance & Summary
class FetchMyBalance extends LeaveEvent {
  final String? academicYear;
  const FetchMyBalance({this.academicYear});
}

class FetchMySummary extends LeaveEvent {
  const FetchMySummary();
}
