import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/period_model.dart';
import '../models/timetable_entry_model.dart';

abstract class TimetableRepository {
  // Periods
  Future<List<PeriodResponse>> getPeriods();
  Future<List<PeriodResponse>> getActivePeriods();
  Future<PeriodResponse> createPeriod(PeriodRequest request);
  Future<PeriodResponse> updatePeriod(String id, PeriodRequest request);
  Future<void> deletePeriod(String id);

  // Timetable Entries
  Future<TimetableEntryResponse> createEntry(TimetableEntryRequest request);
  Future<List<TimetableEntryResponse>> getClassTimetable(String classId);
  Future<List<TimetableEntryResponse>> getTeacherTimetable(String teacherId);
  Future<Map<String, List<TimetableEntryResponse>>> getClassWeeklyTimetable(String classId);
  Future<Map<String, List<TimetableEntryResponse>>> getTeacherWeeklyTimetable(String teacherId);
  Future<List<TimetableEntryResponse>> getClassDayTimetable(String classId, String day);
  Future<TimetableEntryResponse> updateEntry(String id, TimetableEntryRequest request);
  Future<void> deleteEntry(String id);
}

@Singleton(as: TimetableRepository)
class TimetableRepositoryImpl implements TimetableRepository {
  final ApiDispatcher _apiDispatcher;

  TimetableRepositoryImpl(this._apiDispatcher);

  // ===== Periods =====

  @override
  Future<List<PeriodResponse>> getPeriods() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/timetable/periods',
    );
    final data = response.data is List ? response.data : [];
    return (data as List).map((e) => PeriodResponse.fromJson(e)).toList();
  }

  @override
  Future<List<PeriodResponse>> getActivePeriods() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/timetable/periods/active',
    );
    final data = response.data is List ? response.data : [];
    return (data as List).map((e) => PeriodResponse.fromJson(e)).toList();
  }

  @override
  Future<PeriodResponse> createPeriod(PeriodRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/timetable/periods',
      body: request.toJson(),
    );
    return PeriodResponse.fromJson(response.data);
  }

  @override
  Future<PeriodResponse> updatePeriod(String id, PeriodRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/timetable/periods/$id',
      body: request.toJson(),
    );
    return PeriodResponse.fromJson(response.data);
  }

  @override
  Future<void> deletePeriod(String id) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/timetable/periods/$id',
    );
  }

  // ===== Timetable Entries =====

  @override
  Future<TimetableEntryResponse> createEntry(TimetableEntryRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/timetable/entries',
      body: request.toJson(),
    );
    return TimetableEntryResponse.fromJson(response.data);
  }

  @override
  Future<List<TimetableEntryResponse>> getClassTimetable(String classId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/timetable/class/$classId',
    );
    final data = response.data is List ? response.data : [];
    return (data as List).map((e) => TimetableEntryResponse.fromJson(e)).toList();
  }

  @override
  Future<List<TimetableEntryResponse>> getTeacherTimetable(String teacherId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/timetable/teacher/$teacherId',
    );
    final data = response.data is List ? response.data : [];
    return (data as List).map((e) => TimetableEntryResponse.fromJson(e)).toList();
  }

  @override
  Future<Map<String, List<TimetableEntryResponse>>> getClassWeeklyTimetable(
      String classId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/timetable/class/$classId/weekly',
    );
    return _parseWeeklyData(response.data);
  }

  @override
  Future<Map<String, List<TimetableEntryResponse>>> getTeacherWeeklyTimetable(
      String teacherId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/timetable/teacher/$teacherId/weekly',
    );
    return _parseWeeklyData(response.data);
  }

  @override
  Future<List<TimetableEntryResponse>> getClassDayTimetable(
      String classId, String day) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/timetable/class/$classId/day/$day',
    );
    final data = response.data is List ? response.data : [];
    return (data as List).map((e) => TimetableEntryResponse.fromJson(e)).toList();
  }

  @override
  Future<TimetableEntryResponse> updateEntry(
      String id, TimetableEntryRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/timetable/entries/$id',
      body: request.toJson(),
    );
    return TimetableEntryResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteEntry(String id) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/timetable/entries/$id',
    );
  }

  Map<String, List<TimetableEntryResponse>> _parseWeeklyData(dynamic data) {
    if (data is! Map) return {};
    final Map<String, List<TimetableEntryResponse>> result = {};
    data.forEach((key, value) {
      if (value is List) {
        result[key.toString()] =
            value.map((e) => TimetableEntryResponse.fromJson(e)).toList();
      }
    });
    return result;
  }
}
