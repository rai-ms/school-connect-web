import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/paginated_response.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/academic_event_model.dart';

abstract class AcademicCalendarRepository {
  Future<PaginatedResponse<AcademicEventResponse>> getAllEvents({
    int page,
    int size,
  });
  Future<AcademicEventResponse> getEventById(String id);
  Future<AcademicEventResponse> createEvent(
      CreateAcademicEventRequest request);
  Future<AcademicEventResponse> updateEvent(
      String id, CreateAcademicEventRequest request);
  Future<void> deleteEvent(String id);
  Future<List<AcademicEventResponse>> getEventsByDateRange(
      String start, String end);
  Future<List<AcademicEventResponse>> getEventsByMonth(int year, int month);
  Future<List<AcademicEventResponse>> getUpcomingEvents({int limit});
  Future<List<AcademicEventResponse>> getHolidays(String academicYear);
}

@Singleton(as: AcademicCalendarRepository)
class AcademicCalendarRepositoryImpl implements AcademicCalendarRepository {
  final ApiDispatcher _apiDispatcher;

  AcademicCalendarRepositoryImpl(this._apiDispatcher);

  @override
  Future<PaginatedResponse<AcademicEventResponse>> getAllEvents({
    int page = 0,
    int size = 20,
  }) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/calendar?page=$page&size=$size',
    );
    if (response.data is Map<String, dynamic>) {
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => AcademicEventResponse.fromJson(json),
      );
    }
    final data = response.data is List ? response.data as List : [];
    return PaginatedResponse.fromList(
      data.map((e) => AcademicEventResponse.fromJson(e)).toList(),
    );
  }

  @override
  Future<AcademicEventResponse> getEventById(String id) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/calendar/$id',
    );
    return AcademicEventResponse.fromJson(response.data);
  }

  @override
  Future<AcademicEventResponse> createEvent(
      CreateAcademicEventRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/calendar',
      body: request.toJson(),
    );
    return AcademicEventResponse.fromJson(response.data);
  }

  @override
  Future<AcademicEventResponse> updateEvent(
      String id, CreateAcademicEventRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/calendar/$id',
      body: request.toJson(),
    );
    return AcademicEventResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/calendar/$id',
    );
  }

  @override
  Future<List<AcademicEventResponse>> getEventsByDateRange(
      String start, String end) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/calendar/range?start=$start&end=$end',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => AcademicEventResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<AcademicEventResponse>> getEventsByMonth(
      int year, int month) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/calendar/month?year=$year&month=$month',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => AcademicEventResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<AcademicEventResponse>> getUpcomingEvents(
      {int limit = 10}) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/calendar/upcoming?limit=$limit',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => AcademicEventResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<AcademicEventResponse>> getHolidays(
      String academicYear) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/calendar/holidays?academicYear=$academicYear',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => AcademicEventResponse.fromJson(e))
        .toList();
  }
}
