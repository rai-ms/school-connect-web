import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/teacher_model.dart';

abstract class TeacherRepository {
  Future<List<TeacherResponse>> getAllTeachers({int page, int size});
  Future<TeacherResponse> getTeacherById(String id);
  Future<TeacherResponse> getTeacherByEmployeeId(String employeeId);
  Future<TeacherResponse> createTeacher(CreateTeacherRequest request);
  Future<TeacherResponse> updateTeacher(
      String id, Map<String, dynamic> updates);
  Future<void> deleteTeacher(String id);
}

@Singleton(as: TeacherRepository)
class TeacherRepositoryImpl implements TeacherRepository {
  final ApiDispatcher _apiDispatcher;

  TeacherRepositoryImpl(this._apiDispatcher);

  @override
  Future<List<TeacherResponse>> getAllTeachers(
      {int page = 0, int size = 20}) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/teachers?page=$page&size=$size',
    );
    final data = response.data is Map
        ? (response.data['content'] ?? [])
        : response.data is List
            ? response.data
            : [];
    return (data as List)
        .map((e) => TeacherResponse.fromJson(e))
        .toList();
  }

  @override
  Future<TeacherResponse> getTeacherById(String id) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/teachers/$id',
    );
    return TeacherResponse.fromJson(response.data);
  }

  @override
  Future<TeacherResponse> getTeacherByEmployeeId(String employeeId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/teachers/employee/$employeeId',
    );
    return TeacherResponse.fromJson(response.data);
  }

  @override
  Future<TeacherResponse> createTeacher(CreateTeacherRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/teachers',
      body: request.toJson(),
    );
    return TeacherResponse.fromJson(response.data);
  }

  @override
  Future<TeacherResponse> updateTeacher(
      String id, Map<String, dynamic> updates) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/teachers/$id',
      body: updates,
    );
    return TeacherResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteTeacher(String id) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/teachers/$id',
    );
  }
}
