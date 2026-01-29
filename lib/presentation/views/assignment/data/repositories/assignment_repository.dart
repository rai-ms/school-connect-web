import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/assignment_model.dart';

abstract class AssignmentRepository {
  // Assignments
  Future<List<AssignmentResponse>> getAssignments({
    int page = 0,
    int size = 20,
    String? classId,
    String? teacherId,
    String? subjectId,
    String? status,
    String? type,
  });
  Future<AssignmentResponse> getAssignmentById(String id);
  Future<List<AssignmentResponse>> getAssignmentsByClass(String classId);
  Future<List<AssignmentResponse>> getAssignmentsByTeacher(String teacherId);
  Future<List<AssignmentResponse>> getAssignmentsBySubject(String subjectId);
  Future<AssignmentResponse> createAssignment(CreateAssignmentRequest request);
  Future<AssignmentResponse> updateAssignment(
      String id, UpdateAssignmentRequest request);
  Future<void> deleteAssignment(String id);

  // Submissions
  Future<AssignmentSubmissionResponse> submitAssignment(
      String assignmentId, SubmitAssignmentRequest request);
  Future<List<AssignmentSubmissionResponse>> getSubmissionsByAssignment(
      String assignmentId);
  Future<AssignmentSubmissionResponse> gradeSubmission(
      String submissionId, GradeSubmissionRequest request);
  Future<List<AssignmentSubmissionResponse>> getStudentSubmissions(
      String studentId);
  Future<AssignmentStatistics> getAssignmentStatistics(String assignmentId);
}

@Singleton(as: AssignmentRepository)
class AssignmentRepositoryImpl implements AssignmentRepository {
  final ApiDispatcher _apiDispatcher;

  AssignmentRepositoryImpl(this._apiDispatcher);

  // ===== Assignments =====

  @override
  Future<List<AssignmentResponse>> getAssignments({
    int page = 0,
    int size = 20,
    String? classId,
    String? teacherId,
    String? subjectId,
    String? status,
    String? type,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
    };
    if (classId != null) queryParams['classId'] = classId;
    if (teacherId != null) queryParams['teacherId'] = teacherId;
    if (subjectId != null) queryParams['subjectId'] = subjectId;
    if (status != null) queryParams['status'] = status;
    if (type != null) queryParams['type'] = type;

    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/assignments',
      queryParam: queryParams,
    );
    final data = response.data['content'] ?? response.data;
    if (data is List) {
      return data.map((e) => AssignmentResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<AssignmentResponse> getAssignmentById(String id) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/assignments/$id',
    );
    return AssignmentResponse.fromJson(response.data);
  }

  @override
  Future<List<AssignmentResponse>> getAssignmentsByClass(
      String classId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/assignments/class/$classId',
    );
    final data = response.data is List
        ? response.data
        : (response.data['content'] ?? response.data);
    if (data is List) {
      return data.map((e) => AssignmentResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<AssignmentResponse>> getAssignmentsByTeacher(
      String teacherId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/assignments/teacher/$teacherId',
    );
    final data = response.data is List
        ? response.data
        : (response.data['content'] ?? response.data);
    if (data is List) {
      return data.map((e) => AssignmentResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<AssignmentResponse>> getAssignmentsBySubject(
      String subjectId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/assignments/subject/$subjectId',
    );
    final data = response.data is List
        ? response.data
        : (response.data['content'] ?? response.data);
    if (data is List) {
      return data.map((e) => AssignmentResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<AssignmentResponse> createAssignment(
      CreateAssignmentRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/assignments',
      body: request.toJson(),
    );
    return AssignmentResponse.fromJson(response.data);
  }

  @override
  Future<AssignmentResponse> updateAssignment(
      String id, UpdateAssignmentRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/assignments/$id',
      body: request.toJson(),
    );
    return AssignmentResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteAssignment(String id) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/assignments/$id',
    );
  }

  // ===== Submissions =====

  @override
  Future<AssignmentSubmissionResponse> submitAssignment(
      String assignmentId, SubmitAssignmentRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/assignments/$assignmentId/submit',
      body: request.toJson(),
    );
    return AssignmentSubmissionResponse.fromJson(response.data);
  }

  @override
  Future<List<AssignmentSubmissionResponse>> getSubmissionsByAssignment(
      String assignmentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/assignments/$assignmentId/submissions',
    );
    final data = response.data is List
        ? response.data
        : (response.data['content'] ?? response.data);
    if (data is List) {
      return data
          .map((e) => AssignmentSubmissionResponse.fromJson(e))
          .toList();
    }
    return [];
  }

  @override
  Future<AssignmentSubmissionResponse> gradeSubmission(
      String submissionId, GradeSubmissionRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/assignments/submissions/$submissionId/grade',
      body: request.toJson(),
    );
    return AssignmentSubmissionResponse.fromJson(response.data);
  }

  @override
  Future<List<AssignmentSubmissionResponse>> getStudentSubmissions(
      String studentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/assignments/student/$studentId/submissions',
    );
    final data = response.data is List
        ? response.data
        : (response.data['content'] ?? response.data);
    if (data is List) {
      return data
          .map((e) => AssignmentSubmissionResponse.fromJson(e))
          .toList();
    }
    return [];
  }

  @override
  Future<AssignmentStatistics> getAssignmentStatistics(
      String assignmentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/assignments/$assignmentId/statistics',
    );
    return AssignmentStatistics.fromJson(response.data);
  }
}
