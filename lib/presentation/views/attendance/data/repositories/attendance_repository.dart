import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRepository {
  Future<void> markBulkAttendance(MarkAttendanceRequest request);
  Future<List<AttendanceResponse>> getAttendanceByClass(
      String classId, String date);
  Future<List<AttendanceResponse>> getStudentAttendance(String studentId,
      {int page, int size});
  Future<List<AttendanceResponse>> getStudentAttendanceByDateRange(
      String studentId, String startDate, String endDate);
  Future<AttendancePercentage> getStudentAttendancePercentage(
      String studentId);
  Future<List<AttendanceResponse>> getAttendanceByDate(String date);
}

@Singleton(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final ApiDispatcher _apiDispatcher;

  AttendanceRepositoryImpl(this._apiDispatcher);

  @override
  Future<void> markBulkAttendance(MarkAttendanceRequest request) async {
    await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/attendance/bulk',
      body: request.toJson(),
    );
  }

  @override
  Future<List<AttendanceResponse>> getAttendanceByClass(
      String classId, String date) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/attendance/class/$classId?date=$date',
    );
    final data = response.data is Map
        ? (response.data['content'] ?? [])
        : response.data is List
            ? response.data
            : [];
    return (data as List)
        .map((e) => AttendanceResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<AttendanceResponse>> getStudentAttendance(String studentId,
      {int page = 0, int size = 30}) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/attendance/student/$studentId?page=$page&size=$size',
    );
    final data = response.data is Map
        ? (response.data['content'] ?? [])
        : response.data is List
            ? response.data
            : [];
    return (data as List)
        .map((e) => AttendanceResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<AttendanceResponse>> getStudentAttendanceByDateRange(
      String studentId, String startDate, String endDate) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint:
          'api/attendance/student/$studentId/date-range?startDate=$startDate&endDate=$endDate',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => AttendanceResponse.fromJson(e))
        .toList();
  }

  @override
  Future<AttendancePercentage> getStudentAttendancePercentage(
      String studentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/attendance/student/$studentId/percentage',
    );
    return AttendancePercentage.fromJson(response.data);
  }

  @override
  Future<List<AttendanceResponse>> getAttendanceByDate(String date) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/attendance/date/$date',
    );
    final data = response.data is Map
        ? (response.data['content'] ?? [])
        : response.data is List
            ? response.data
            : [];
    return (data as List)
        .map((e) => AttendanceResponse.fromJson(e))
        .toList();
  }
}
