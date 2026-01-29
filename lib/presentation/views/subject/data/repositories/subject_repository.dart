import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/paginated_response.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/subject_model.dart';

abstract class SubjectRepository {
  Future<PaginatedResponse<SubjectResponse>> getAllSubjects({
    int page,
    int size,
    String? search,
  });
  Future<SubjectResponse> getSubjectById(String id);
  Future<SubjectResponse> getSubjectByCode(String code);
  Future<SubjectResponse> createSubject(CreateSubjectRequest request);
  Future<SubjectResponse> updateSubject(
      String id, CreateSubjectRequest request);
  Future<void> deleteSubject(String id);
  Future<List<SubjectResponse>> getSubjectsByClass(String classId);
  Future<List<SubjectResponse>> getSubjectsByTeacher(String teacherId);
  Future<PaginatedResponse<SubjectResponse>> searchSubjects(
      String query, {int page, int size});
}

@Singleton(as: SubjectRepository)
class SubjectRepositoryImpl implements SubjectRepository {
  final ApiDispatcher _apiDispatcher;

  SubjectRepositoryImpl(this._apiDispatcher);

  @override
  Future<PaginatedResponse<SubjectResponse>> getAllSubjects({
    int page = 0,
    int size = 20,
    String? search,
  }) async {
    final params = <String>['page=$page', 'size=$size'];
    if (search != null && search.isNotEmpty) {
      params.add('search=$search');
    }

    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/subjects?${params.join('&')}',
    );
    if (response.data is Map<String, dynamic>) {
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => SubjectResponse.fromJson(json),
      );
    }
    // Fallback for plain list responses
    final data = response.data is List ? response.data as List : [];
    return PaginatedResponse.fromList(
      data.map((e) => SubjectResponse.fromJson(e)).toList(),
    );
  }

  @override
  Future<SubjectResponse> getSubjectById(String id) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/subjects/$id',
    );
    return SubjectResponse.fromJson(response.data);
  }

  @override
  Future<SubjectResponse> getSubjectByCode(String code) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/subjects/code/$code',
    );
    return SubjectResponse.fromJson(response.data);
  }

  @override
  Future<SubjectResponse> createSubject(CreateSubjectRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/subjects',
      body: request.toJson(),
    );
    return SubjectResponse.fromJson(response.data);
  }

  @override
  Future<SubjectResponse> updateSubject(
      String id, CreateSubjectRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/subjects/$id',
      body: request.toJson(),
    );
    return SubjectResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteSubject(String id) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/subjects/$id',
    );
  }

  @override
  Future<List<SubjectResponse>> getSubjectsByClass(String classId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/subjects/class/$classId',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => SubjectResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<SubjectResponse>> getSubjectsByTeacher(
      String teacherId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/subjects/teacher/$teacherId',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => SubjectResponse.fromJson(e))
        .toList();
  }

  @override
  Future<PaginatedResponse<SubjectResponse>> searchSubjects(
    String query, {
    int page = 0,
    int size = 20,
  }) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/subjects/search?query=$query&page=$page&size=$size',
    );
    if (response.data is Map<String, dynamic>) {
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => SubjectResponse.fromJson(json),
      );
    }
    final data = response.data is List ? response.data as List : [];
    return PaginatedResponse.fromList(
      data.map((e) => SubjectResponse.fromJson(e)).toList(),
    );
  }
}
