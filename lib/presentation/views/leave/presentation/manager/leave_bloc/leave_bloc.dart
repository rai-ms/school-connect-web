import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/leave_type_model.dart';
import '../../../data/models/leave_request_model.dart';
import '../../../data/models/leave_balance_model.dart';
import '../../../data/repositories/leave_repository.dart';

part 'leave_event.dart';
part 'leave_state.dart';

@injectable
class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final LeaveRepository _repository;
  final StateRequestHandler _handler;

  LeaveBloc(this._repository, this._handler) : super(const LeaveState()) {
    on<FetchLeaveTypes>(_onFetchLeaveTypes);
    on<FetchActiveLeaveTypes>(_onFetchActiveLeaveTypes);
    on<CreateLeaveType>(_onCreateLeaveType);
    on<UpdateLeaveType>(_onUpdateLeaveType);
    on<DeleteLeaveType>(_onDeleteLeaveType);
    on<ApplyLeave>(_onApplyLeave);
    on<FetchMyLeaves>(_onFetchMyLeaves);
    on<FetchPendingApprovals>(_onFetchPendingApprovals);
    on<FetchAllLeaveRequests>(_onFetchAllRequests);
    on<ApproveLeave>(_onApproveLeave);
    on<RejectLeave>(_onRejectLeave);
    on<CancelLeave>(_onCancelLeave);
    on<FetchMyBalance>(_onFetchMyBalance);
    on<FetchMySummary>(_onFetchMySummary);
  }

  FVoid _onFetchLeaveTypes(
      FetchLeaveTypes event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final types = await _repository.getLeaveTypes();
        emit(state.copyWith(state: state.success, leaveTypes: types));
      },
      dioError: (e) {
        Log.e('Error fetching leave types: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching leave types: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchActiveLeaveTypes(
      FetchActiveLeaveTypes event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final types = await _repository.getActiveLeaveTypes();
        emit(state.copyWith(state: state.success, leaveTypes: types));
      },
      dioError: (e) {
        Log.e('Error fetching active leave types: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching active leave types: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateLeaveType(
      CreateLeaveType event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createLeaveType(event.request);
        final types = await _repository.getLeaveTypes();
        emit(state.copyWith(
            state: state.success,
            leaveTypes: types,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error creating leave type: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating leave type: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onUpdateLeaveType(
      UpdateLeaveType event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.updateLeaveType(event.id, event.request);
        final types = await _repository.getLeaveTypes();
        emit(state.copyWith(
            state: state.success,
            leaveTypes: types,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error updating leave type: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error updating leave type: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onDeleteLeaveType(
      DeleteLeaveType event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.deleteLeaveType(event.id);
        final types = await _repository.getLeaveTypes();
        emit(state.copyWith(
            state: state.success,
            leaveTypes: types,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error deleting leave type: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error deleting leave type: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onApplyLeave(ApplyLeave event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.applyLeave(event.request);
        emit(state.copyWith(
            state: state.success, leaveApplied: true));
      },
      dioError: (e) {
        Log.e('Error applying leave: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error applying leave: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchMyLeaves(
      FetchMyLeaves event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final leaves = await _repository.getMyLeaves();
        emit(state.copyWith(state: state.success, myLeaves: leaves));
      },
      dioError: (e) {
        Log.e('Error fetching my leaves: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching my leaves: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchPendingApprovals(
      FetchPendingApprovals event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final pending = await _repository.getPendingApprovals();
        emit(state.copyWith(
            state: state.success, pendingApprovals: pending));
      },
      dioError: (e) {
        Log.e('Error fetching pending approvals: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching pending approvals: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchAllRequests(
      FetchAllLeaveRequests event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final all = await _repository.getAllLeaveRequests();
        emit(state.copyWith(state: state.success, allRequests: all));
      },
      dioError: (e) {
        Log.e('Error fetching all leave requests: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching all leave requests: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onApproveLeave(
      ApproveLeave event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.approveLeave(event.id, remarks: event.remarks);
        // Refresh pending list
        final pending = await _repository.getPendingApprovals();
        emit(state.copyWith(
          state: state.success,
          pendingApprovals: pending,
          actionCompleted: true,
        ));
      },
      dioError: (e) {
        Log.e('Error approving leave: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error approving leave: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onRejectLeave(
      RejectLeave event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.rejectLeave(event.id, remarks: event.remarks);
        final pending = await _repository.getPendingApprovals();
        emit(state.copyWith(
          state: state.success,
          pendingApprovals: pending,
          actionCompleted: true,
        ));
      },
      dioError: (e) {
        Log.e('Error rejecting leave: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error rejecting leave: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCancelLeave(
      CancelLeave event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.cancelLeave(event.id);
        final leaves = await _repository.getMyLeaves();
        emit(state.copyWith(
          state: state.success,
          myLeaves: leaves,
          actionCompleted: true,
        ));
      },
      dioError: (e) {
        Log.e('Error cancelling leave: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error cancelling leave: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchMyBalance(
      FetchMyBalance event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final balances =
            await _repository.getMyBalance(academicYear: event.academicYear);
        emit(state.copyWith(state: state.success, balances: balances));
      },
      dioError: (e) {
        Log.e('Error fetching balance: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching balance: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchMySummary(
      FetchMySummary event, Emitter<LeaveState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final summary = await _repository.getMySummary();
        emit(state.copyWith(
          state: state.success,
          summary: summary,
          balances: summary.balances,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching summary: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching summary: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
