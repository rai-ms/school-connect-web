import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/exam_type_model.dart';
import '../models/exam_model.dart';
import '../models/exam_result_model.dart';

abstract class ExamRepository {
  // Exam Types
  Future<List<ExamTypeResponse>> getExamTypes();
  Future<List<ExamTypeResponse>> getActiveExamTypes();
  Future<ExamTypeResponse> createExamType(ExamTypeRequest request);
  Future<ExamTypeResponse> updateExamType(String id, ExamTypeRequest request);
  Future<void> deleteExamType(String id);

  // Exams
  Future<List<ExamResponse>> getExams({int page = 0, int size = 20});
  Future<ExamResponse> getExamById(String id);
  Future<List<ExamResponse>> getExamsByClass(String classId);
  Future<List<ExamResponse>> getUpcomingExams();
  Future<List<ExamResponse>> getUpcomingExamsByClass(String classId);
  Future<ExamResponse> createExam(ExamRequest request);
  Future<ExamResponse> updateExam(String id, ExamRequest request);
  Future<void> deleteExam(String id);

  // Results
  Future<ExamResultResponse> enterMarks(String examId, ExamResultRequest request);
  Future<List<ExamResultResponse>> enterBulkMarks(
      String examId, List<ExamResultRequest> requests);
  Future<List<ExamResultResponse>> getExamResults(String examId);
  Future<ExamStatistics> getExamStatistics(String examId);
  Future<List<ExamResultResponse>> getStudentResults(String studentId);
  Future<ReportCard> getReportCard(String studentId);
}

@Singleton(as: ExamRepository)
class ExamRepositoryImpl implements ExamRepository {
  final ApiDispatcher _apiDispatcher;

  ExamRepositoryImpl(this._apiDispatcher);

  // ===== Exam Types =====

  @override
  Future<List<ExamTypeResponse>> getExamTypes() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/exams/types',
    );
    final data = response.data is List ? response.data : (response.data['content'] ?? response.data);
    if (data is List) {
      return data.map((e) => ExamTypeResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<ExamTypeResponse>> getActiveExamTypes() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/exams/types/active',
    );
    final data = response.data is List ? response.data : (response.data['content'] ?? response.data);
    if (data is List) {
      return data.map((e) => ExamTypeResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<ExamTypeResponse> createExamType(ExamTypeRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/exams/types',
      body: request.toJson(),
    );
    return ExamTypeResponse.fromJson(response.data);
  }

  @override
  Future<ExamTypeResponse> updateExamType(String id, ExamTypeRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/exams/types/$id',
      body: request.toJson(),
    );
    return ExamTypeResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteExamType(String id) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/exams/types/$id',
    );
  }

  // ===== Exams =====

  @override
  Future<List<ExamResponse>> getExams({int page = 0, int size = 20}) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/exams',
      queryParam: {'page': page, 'size': size},
    );
    final data = response.data['content'] ?? response.data;
    if (data is List) {
      return data.map((e) => ExamResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<ExamResponse> getExamById(String id) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/exams/$id',
    );
    return ExamResponse.fromJson(response.data);
  }

  @override
  Future<List<ExamResponse>> getExamsByClass(String classId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/exams/class/$classId',
    );
    final data = response.data is List ? response.data : (response.data['content'] ?? response.data);
    if (data is List) {
      return data.map((e) => ExamResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<ExamResponse>> getUpcomingExams() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/exams/upcoming',
    );
    final data = response.data is List ? response.data : (response.data['content'] ?? response.data);
    if (data is List) {
      return data.map((e) => ExamResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<ExamResponse>> getUpcomingExamsByClass(String classId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/exams/upcoming/class/$classId',
    );
    final data = response.data is List ? response.data : (response.data['content'] ?? response.data);
    if (data is List) {
      return data.map((e) => ExamResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<ExamResponse> createExam(ExamRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/exams',
      body: request.toJson(),
    );
    return ExamResponse.fromJson(response.data);
  }

  @override
  Future<ExamResponse> updateExam(String id, ExamRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/exams/$id',
      body: request.toJson(),
    );
    return ExamResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteExam(String id) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/exams/$id',
    );
  }

  // ===== Results =====

  @override
  Future<ExamResultResponse> enterMarks(
      String examId, ExamResultRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/exams/$examId/marks',
      body: request.toJson(),
    );
    return ExamResultResponse.fromJson(response.data);
  }

  @override
  Future<List<ExamResultResponse>> enterBulkMarks(
      String examId, List<ExamResultRequest> requests) async {
    final List<ExamResultResponse> results = [];
    for (final request in requests) {
      final result = await enterMarks(examId, request);
      results.add(result);
    }
    return results;
  }

  @override
  Future<List<ExamResultResponse>> getExamResults(String examId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/exams/$examId/results',
    );
    final data = response.data is List ? response.data : (response.data['content'] ?? response.data);
    if (data is List) {
      return data.map((e) => ExamResultResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<ExamStatistics> getExamStatistics(String examId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/exams/$examId/statistics',
    );
    return ExamStatistics.fromJson(response.data);
  }

  @override
  Future<List<ExamResultResponse>> getStudentResults(String studentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/exams/students/$studentId/results',
    );
    final data = response.data is List ? response.data : (response.data['content'] ?? response.data);
    if (data is List) {
      return data.map((e) => ExamResultResponse.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<ReportCard> getReportCard(String studentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/exams/students/$studentId/report-card',
    );
    return ReportCard.fromJson(response.data);
  }
}
