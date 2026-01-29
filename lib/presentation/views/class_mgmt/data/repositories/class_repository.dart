import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/class_model.dart';

abstract class ClassRepository {
  Future<List<SchoolClassResponse>> getAllClasses();
  Future<SchoolClassResponse> getClassById(String classId);
  Future<SchoolClassResponse> createClass(CreateClassRequest request);
  Future<SectionResponse> createSection(CreateSectionRequest request);
  Future<List<SectionResponse>> getSectionsByClass(String classId);
  Future<List<SectionResponse>> createBulkSections(
      String classId, List<CreateSectionRequest> sections);
}

@Singleton(as: ClassRepository)
class ClassRepositoryImpl implements ClassRepository {
  final ApiDispatcher _apiDispatcher;

  ClassRepositoryImpl(this._apiDispatcher);

  @override
  Future<List<SchoolClassResponse>> getAllClasses() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/classes',
    );
    final data = response.data is Map
        ? (response.data['content'] ?? [])
        : response.data is List
            ? response.data
            : [];
    return (data as List)
        .map((e) => SchoolClassResponse.fromJson(e))
        .toList();
  }

  @override
  Future<SchoolClassResponse> getClassById(String classId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/classes/$classId',
    );
    return SchoolClassResponse.fromJson(response.data);
  }

  @override
  Future<SchoolClassResponse> createClass(CreateClassRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/classes',
      body: request.toJson(),
    );
    return SchoolClassResponse.fromJson(response.data);
  }

  @override
  Future<SectionResponse> createSection(CreateSectionRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/classes/sections',
      body: request.toJson(),
    );
    return SectionResponse.fromJson(response.data);
  }

  @override
  Future<List<SectionResponse>> getSectionsByClass(String classId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/classes/$classId/sections',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => SectionResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<SectionResponse>> createBulkSections(
      String classId, List<CreateSectionRequest> sections) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/classes/$classId/sections/bulk',
      body: {'sections': sections.map((s) => s.toJson()).toList()},
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => SectionResponse.fromJson(e))
        .toList();
  }
}
