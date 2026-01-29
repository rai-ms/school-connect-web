import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/leave_type_model.dart';
import '../models/leave_request_model.dart';
import '../models/leave_balance_model.dart';

abstract class LeaveRepository {
  // Leave Types
  Future<List<LeaveTypeResponse>> getLeaveTypes();
  Future<List<LeaveTypeResponse>> getActiveLeaveTypes();
  Future<LeaveTypeResponse> createLeaveType(LeaveTypeRequest request);
  Future<LeaveTypeResponse> updateLeaveType(String id, LeaveTypeRequest request);
  Future<void> deleteLeaveType(String id);

  // Leave Requests
  Future<LeaveRequestResponse> applyLeave(LeaveRequestCreate request);
  Future<List<LeaveRequestResponse>> getMyLeaves();
  Future<List<LeaveRequestResponse>> getPendingApprovals();
  Future<List<LeaveRequestResponse>> getAllLeaveRequests({int page, int size});
  Future<LeaveRequestResponse> approveLeave(String id, {String? remarks});
  Future<LeaveRequestResponse> rejectLeave(String id, {String? remarks});
  Future<LeaveRequestResponse> cancelLeave(String id);

  // Leave Balance
  Future<List<LeaveBalanceResponse>> getMyBalance({String? academicYear});
  Future<List<LeaveBalanceResponse>> getUserBalance(String userId,
      {String? academicYear});
  Future<LeaveBalanceResponse> initializeBalance(
      String userId, String leaveTypeId, String academicYear, int totalDays);

  // Summary
  Future<LeaveSummaryResponse> getMySummary();
  Future<LeaveSummaryResponse> getUserSummary(String userId);
}

@Singleton(as: LeaveRepository)
class LeaveRepositoryImpl implements LeaveRepository {
  final ApiDispatcher _apiDispatcher;

  LeaveRepositoryImpl(this._apiDispatcher);

  // ===== Leave Types =====

  @override
  Future<List<LeaveTypeResponse>> getLeaveTypes() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/leave/types',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => LeaveTypeResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<LeaveTypeResponse>> getActiveLeaveTypes() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/leave/types/active',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => LeaveTypeResponse.fromJson(e))
        .toList();
  }

  @override
  Future<LeaveTypeResponse> createLeaveType(LeaveTypeRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/leave/types',
      body: request.toJson(),
    );
    return LeaveTypeResponse.fromJson(response.data);
  }

  @override
  Future<LeaveTypeResponse> updateLeaveType(
      String id, LeaveTypeRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/leave/types/$id',
      body: request.toJson(),
    );
    return LeaveTypeResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteLeaveType(String id) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/leave/types/$id',
    );
  }

  // ===== Leave Requests =====

  @override
  Future<LeaveRequestResponse> applyLeave(LeaveRequestCreate request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/leave/request',
      body: request.toJson(),
    );
    return LeaveRequestResponse.fromJson(response.data);
  }

  @override
  Future<List<LeaveRequestResponse>> getMyLeaves() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/leave/my',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => LeaveRequestResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<LeaveRequestResponse>> getPendingApprovals() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/leave/requests/pending',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => LeaveRequestResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<LeaveRequestResponse>> getAllLeaveRequests(
      {int page = 0, int size = 20}) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/leave/requests?page=$page&size=$size',
    );
    final data = response.data is Map
        ? (response.data['content'] ?? [])
        : response.data is List
            ? response.data
            : [];
    return (data as List)
        .map((e) => LeaveRequestResponse.fromJson(e))
        .toList();
  }

  @override
  Future<LeaveRequestResponse> approveLeave(String id,
      {String? remarks}) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/leave/requests/$id/approve',
      body: remarks != null ? {'remarks': remarks} : null,
    );
    return LeaveRequestResponse.fromJson(response.data);
  }

  @override
  Future<LeaveRequestResponse> rejectLeave(String id,
      {String? remarks}) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/leave/requests/$id/reject',
      body: remarks != null ? {'remarks': remarks} : null,
    );
    return LeaveRequestResponse.fromJson(response.data);
  }

  @override
  Future<LeaveRequestResponse> cancelLeave(String id) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/leave/requests/$id/cancel',
    );
    return LeaveRequestResponse.fromJson(response.data);
  }

  // ===== Leave Balance =====

  @override
  Future<List<LeaveBalanceResponse>> getMyBalance(
      {String? academicYear}) async {
    final yearParam =
        academicYear != null ? '?academicYear=$academicYear' : '';
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/leave/balance$yearParam',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => LeaveBalanceResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<LeaveBalanceResponse>> getUserBalance(String userId,
      {String? academicYear}) async {
    final yearParam =
        academicYear != null ? '?academicYear=$academicYear' : '';
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/leave/balance/$userId$yearParam',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => LeaveBalanceResponse.fromJson(e))
        .toList();
  }

  @override
  Future<LeaveBalanceResponse> initializeBalance(
      String userId, String leaveTypeId, String academicYear,
      int totalDays) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/leave/balance/initialize',
      body: {
        'userId': userId,
        'leaveTypeId': leaveTypeId,
        'academicYear': academicYear,
        'totalDays': totalDays,
      },
    );
    return LeaveBalanceResponse.fromJson(response.data);
  }

  // ===== Summary =====

  @override
  Future<LeaveSummaryResponse> getMySummary() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/leave/summary',
    );
    return LeaveSummaryResponse.fromJson(response.data);
  }

  @override
  Future<LeaveSummaryResponse> getUserSummary(String userId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/leave/summary/$userId',
    );
    return LeaveSummaryResponse.fromJson(response.data);
  }
}
