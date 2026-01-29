import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/paginated_response.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/student_model.dart';

abstract class StudentRepository {
  Future<PaginatedResponse<StudentResponse>> getAllStudents({
    int page,
    int size,
    String? classId,
    String? sectionId,
    String? status,
    String? search,
  });
  Future<StudentResponse> getStudentById(String studentId);
  Future<StudentResponse> createStudent(CreateStudentRequest request);
  Future<StudentResponse> updateStudent(
      String studentId, Map<String, dynamic> updates);
  Future<void> deleteStudent(String studentId);
  Future<void> updateStudentStatus(String studentId, String status);
  Future<StudentStatistics> getStatistics();
  Future<List<StudentResponse>> getStudentsByClass(String classId);
  Future<List<StudentResponse>> searchStudents(String query);
  Future<BulkImportResult> importStudents(String filePath, {String? classId});
  Future<Uint8List> exportStudents({String? classId, String? sectionId, String? status});
  Future<Uint8List> downloadImportTemplate();
}

@Singleton(as: StudentRepository)
class StudentRepositoryImpl implements StudentRepository {
  final ApiDispatcher _apiDispatcher;

  StudentRepositoryImpl(this._apiDispatcher);

  @override
  Future<PaginatedResponse<StudentResponse>> getAllStudents({
    int page = 0,
    int size = 20,
    String? classId,
    String? sectionId,
    String? status,
    String? search,
  }) async {
    final params = <String>['page=$page', 'size=$size'];
    if (classId != null) params.add('classId=$classId');
    if (sectionId != null) params.add('sectionId=$sectionId');
    if (status != null) params.add('status=$status');
    if (search != null) params.add('search=$search');

    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/students?${params.join('&')}',
    );
    if (response.data is Map<String, dynamic>) {
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => StudentResponse.fromJson(json),
      );
    }
    // Fallback for plain list responses
    final data = response.data is List ? response.data as List : [];
    return PaginatedResponse.fromList(
      data.map((e) => StudentResponse.fromJson(e)).toList(),
    );
  }

  @override
  Future<StudentResponse> getStudentById(String studentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/students/$studentId',
    );
    return StudentResponse.fromJson(response.data);
  }

  @override
  Future<StudentResponse> createStudent(CreateStudentRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/students',
      body: request.toJson(),
    );
    return StudentResponse.fromJson(response.data);
  }

  @override
  Future<StudentResponse> updateStudent(
      String studentId, Map<String, dynamic> updates) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/students/$studentId',
      body: updates,
    );
    return StudentResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteStudent(String studentId) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/students/$studentId',
    );
  }

  @override
  Future<void> updateStudentStatus(String studentId, String status) async {
    await _apiDispatcher.call(
      type: RequestType.patch,
      endPoint: 'api/students/$studentId/status',
      body: {'status': status},
    );
  }

  @override
  Future<StudentStatistics> getStatistics() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/students/statistics',
    );
    return StudentStatistics.fromJson(response.data);
  }

  @override
  Future<List<StudentResponse>> getStudentsByClass(String classId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/students/class/$classId',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => StudentResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<StudentResponse>> searchStudents(String query) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/students/search?query=$query',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => StudentResponse.fromJson(e))
        .toList();
  }

  @override
  Future<BulkImportResult> importStudents(String filePath, {String? classId}) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: 'students.csv'),
      if (classId != null) 'classId': classId,
    });
    final response = await _apiDispatcher.call(
      type: RequestType.formData,
      endPoint: 'api/students/import',
      formData: formData,
    );
    return BulkImportResult.fromJson(response.data);
  }

  @override
  Future<Uint8List> exportStudents({String? classId, String? sectionId, String? status}) async {
    final params = <String>[];
    if (classId != null) params.add('classId=$classId');
    if (sectionId != null) params.add('sectionId=$sectionId');
    if (status != null) params.add('status=$status');

    final query = params.isNotEmpty ? '?${params.join('&')}' : '';
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/students/export$query',
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data);
  }

  @override
  Future<Uint8List> downloadImportTemplate() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/students/import/template',
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data);
  }
}
