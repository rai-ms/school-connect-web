import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/fee_type_model.dart';
import '../models/fee_structure_model.dart';
import '../models/fee_payment_model.dart';

abstract class FeeRepository {
  // Fee Types
  Future<List<FeeTypeResponse>> getFeeTypes();
  Future<List<FeeTypeResponse>> getActiveFeeTypes();
  Future<FeeTypeResponse> createFeeType(FeeTypeRequest request);
  Future<FeeTypeResponse> updateFeeType(String id, FeeTypeRequest request);
  Future<void> deleteFeeType(String id);

  // Fee Structures
  Future<List<FeeStructureResponse>> getFeeStructures();
  Future<List<FeeStructureResponse>> getFeeStructuresByClass(String classId);
  Future<FeeStructureResponse> createFeeStructure(
      FeeStructureRequest request);
  Future<FeeStructureResponse> updateFeeStructure(
      String id, FeeStructureRequest request);

  // Fee Payments
  Future<FeePaymentResponse> collectFee(FeePaymentRequest request);
  Future<List<FeePaymentResponse>> getStudentPayments(String studentId);
  Future<List<FeePaymentResponse>> getStudentPendingFees(String studentId);
  Future<List<FeePaymentResponse>> getAllPayments({int page, int size});
  Future<FeePaymentResponse> getReceipt(String paymentId);
  Future<List<FeePaymentResponse>> getOverduePayments();

  // Reports
  Future<CollectionReport> getCollectionReport();
}

@Singleton(as: FeeRepository)
class FeeRepositoryImpl implements FeeRepository {
  final ApiDispatcher _apiDispatcher;

  FeeRepositoryImpl(this._apiDispatcher);

  // ===== Fee Types =====

  @override
  Future<List<FeeTypeResponse>> getFeeTypes() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/fees/types',
    );
    final data = response.data is List ? response.data : [];
    return (data as List).map((e) => FeeTypeResponse.fromJson(e)).toList();
  }

  @override
  Future<List<FeeTypeResponse>> getActiveFeeTypes() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/fees/types/active',
    );
    final data = response.data is List ? response.data : [];
    return (data as List).map((e) => FeeTypeResponse.fromJson(e)).toList();
  }

  @override
  Future<FeeTypeResponse> createFeeType(FeeTypeRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/fees/types',
      body: request.toJson(),
    );
    return FeeTypeResponse.fromJson(response.data);
  }

  @override
  Future<FeeTypeResponse> updateFeeType(
      String id, FeeTypeRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/fees/types/$id',
      body: request.toJson(),
    );
    return FeeTypeResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteFeeType(String id) async {
    await _apiDispatcher.call(
      type: RequestType.delete,
      endPoint: 'api/fees/types/$id',
    );
  }

  // ===== Fee Structures =====

  @override
  Future<List<FeeStructureResponse>> getFeeStructures() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/fees/structure',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => FeeStructureResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<FeeStructureResponse>> getFeeStructuresByClass(
      String classId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/fees/structure/class/$classId',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => FeeStructureResponse.fromJson(e))
        .toList();
  }

  @override
  Future<FeeStructureResponse> createFeeStructure(
      FeeStructureRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/fees/structure',
      body: request.toJson(),
    );
    return FeeStructureResponse.fromJson(response.data);
  }

  @override
  Future<FeeStructureResponse> updateFeeStructure(
      String id, FeeStructureRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.put,
      endPoint: 'api/fees/structure/$id',
      body: request.toJson(),
    );
    return FeeStructureResponse.fromJson(response.data);
  }

  // ===== Fee Payments =====

  @override
  Future<FeePaymentResponse> collectFee(FeePaymentRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/fees/payment',
      body: request.toJson(),
    );
    return FeePaymentResponse.fromJson(response.data);
  }

  @override
  Future<List<FeePaymentResponse>> getStudentPayments(
      String studentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/fees/student/$studentId',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => FeePaymentResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<FeePaymentResponse>> getStudentPendingFees(
      String studentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/fees/student/$studentId/pending',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => FeePaymentResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<FeePaymentResponse>> getAllPayments(
      {int page = 0, int size = 20}) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/fees/payments?page=$page&size=$size',
    );
    final data = response.data is Map
        ? (response.data['content'] ?? [])
        : response.data is List
            ? response.data
            : [];
    return (data as List)
        .map((e) => FeePaymentResponse.fromJson(e))
        .toList();
  }

  @override
  Future<FeePaymentResponse> getReceipt(String paymentId) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/fees/receipt/$paymentId',
    );
    return FeePaymentResponse.fromJson(response.data);
  }

  @override
  Future<List<FeePaymentResponse>> getOverduePayments() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/fees/overdue',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => FeePaymentResponse.fromJson(e))
        .toList();
  }

  // ===== Reports =====

  @override
  Future<CollectionReport> getCollectionReport() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/fees/report/collection',
    );
    return CollectionReport.fromJson(response.data);
  }
}
