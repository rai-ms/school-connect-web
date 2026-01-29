import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/paginated_response.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/parent_model.dart';

abstract class ParentRepository {
  Future<PaginatedResponse<ParentResponse>> getAllParents({
    int page,
    int size,
    String? parentType,
    String? status,
    String? search,
  });
  Future<ParentResponse> getParentById(String parentId);
  Future<ParentResponse> createParent(CreateParentRequest request);
  Future<ParentResponse> updateParent(
      String parentId, Map<String, dynamic> updates);
  Future<void> deleteParent(String parentId);
  Future<void> updateParentStatus(String parentId, String status);
  Future<List<ParentResponse>> getParentsByStudent(String studentId);
  Future<ParentResponse> linkParentToStudent(String parentId, String studentId);
  Future<List<ParentResponse>> searchParents(String query);
}

@Singleton(as: ParentRepository)
class ParentRepositoryImpl implements ParentRepository {
  final ApiDispatcher _apiDispatcher;

  ParentRepositoryImpl(this._apiDispatcher);

  @override
  Future<PaginatedResponse<ParentResponse>> getAllParents({
    int page = 0,
    int size = 20,
    String? parentType,
    String? status,
    String? search,
  }) async {
    final params = <String>['page=$page', 'size=$size'];
    if (parentType != null) params.add('parentType=$parentType');
    if (status != null) params.add('status=$status');
    if (search != null) params.add('search=$search');

    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/parents?${params.join('&')}',
    );
    if (response.data is Map<String, dynamic>) {
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => ParentResponse.fromJson(json),
      );
    }
    // Fallback for plain list responses
    final data = response.data is List ? response.data as List : [];
    return PaginatedResponse.fromList(
      data.map((e) => ParentResponse.fromJson(e)).toList(),
    );
  }

  @override
  Future<ParentResponse> getParentById(String parentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/parents/$parentId',
    );
    return ParentResponse.fromJson(response.data);
  }

  @override
  Future<ParentResponse> createParent(CreateParentRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/parents',
      body: request.toJson(),
    );
    return ParentResponse.fromJson(response.data);
  }

  @override
  Future<ParentResponse> updateParent(
      String parentId, Map<String, dynamic> updates) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/parents/$parentId',
      body: updates,
    );
    return ParentResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteParent(String parentId) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/parents/$parentId',
    );
  }

  @override
  Future<void> updateParentStatus(String parentId, String status) async {
    await _apiDispatcher.call(
      type: RequestType.patch,
      endPoint: 'api/parents/$parentId/status',
      body: {'status': status},
    );
  }

  @override
  Future<List<ParentResponse>> getParentsByStudent(String studentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/parents/student/$studentId',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => ParentResponse.fromJson(e))
        .toList();
  }

  @override
  Future<ParentResponse> linkParentToStudent(
      String parentId, String studentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/parents/$parentId/students/$studentId',
    );
    return ParentResponse.fromJson(response.data);
  }

  @override
  Future<List<ParentResponse>> searchParents(String query) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/parents/search?query=$query',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => ParentResponse.fromJson(e))
        .toList();
  }
}
