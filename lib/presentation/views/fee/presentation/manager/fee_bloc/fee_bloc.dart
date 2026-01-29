import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/fee_type_model.dart';
import '../../../data/models/fee_structure_model.dart';
import '../../../data/models/fee_payment_model.dart';
import '../../../data/repositories/fee_repository.dart';

part 'fee_event.dart';
part 'fee_state.dart';

@injectable
class FeeBloc extends Bloc<FeeEvent, FeeState> {
  final FeeRepository _repository;
  final StateRequestHandler _handler;

  FeeBloc(this._repository, this._handler) : super(const FeeState()) {
    on<FetchFeeTypes>(_onFetchFeeTypes);
    on<FetchActiveFeeTypes>(_onFetchActiveFeeTypes);
    on<CreateFeeType>(_onCreateFeeType);
    on<UpdateFeeType>(_onUpdateFeeType);
    on<DeleteFeeType>(_onDeleteFeeType);
    on<FetchFeeStructures>(_onFetchFeeStructures);
    on<FetchFeeStructuresByClass>(_onFetchFeeStructuresByClass);
    on<CreateFeeStructure>(_onCreateFeeStructure);
    on<UpdateFeeStructure>(_onUpdateFeeStructure);
    on<CollectFee>(_onCollectFee);
    on<FetchStudentPayments>(_onFetchStudentPayments);
    on<FetchStudentPendingFees>(_onFetchStudentPendingFees);
    on<FetchAllPayments>(_onFetchAllPayments);
    on<FetchReceipt>(_onFetchReceipt);
    on<FetchOverduePayments>(_onFetchOverduePayments);
    on<FetchCollectionReport>(_onFetchCollectionReport);
  }

  // ===== Fee Type Handlers =====

  FVoid _onFetchFeeTypes(FetchFeeTypes event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final types = await _repository.getFeeTypes();
        emit(state.copyWith(state: state.success, feeTypes: types));
      },
      dioError: (e) {
        Log.e('Error fetching fee types: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching fee types: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchActiveFeeTypes(
      FetchActiveFeeTypes event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final types = await _repository.getActiveFeeTypes();
        emit(state.copyWith(state: state.success, feeTypes: types));
      },
      dioError: (e) {
        Log.e('Error fetching active fee types: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching active fee types: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateFeeType(CreateFeeType event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createFeeType(event.request);
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error creating fee type: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating fee type: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onUpdateFeeType(UpdateFeeType event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.updateFeeType(event.id, event.request);
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error updating fee type: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error updating fee type: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onDeleteFeeType(DeleteFeeType event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.deleteFeeType(event.id);
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error deleting fee type: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error deleting fee type: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  // ===== Fee Structure Handlers =====

  FVoid _onFetchFeeStructures(
      FetchFeeStructures event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final structures = await _repository.getFeeStructures();
        emit(state.copyWith(
            state: state.success, feeStructures: structures));
      },
      dioError: (e) {
        Log.e('Error fetching fee structures: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching fee structures: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchFeeStructuresByClass(
      FetchFeeStructuresByClass event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final structures =
            await _repository.getFeeStructuresByClass(event.classId);
        emit(state.copyWith(
            state: state.success, feeStructures: structures));
      },
      dioError: (e) {
        Log.e('Error fetching class fee structures: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching class fee structures: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateFeeStructure(
      CreateFeeStructure event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createFeeStructure(event.request);
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error creating fee structure: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating fee structure: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onUpdateFeeStructure(
      UpdateFeeStructure event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.updateFeeStructure(event.id, event.request);
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error updating fee structure: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error updating fee structure: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  // ===== Fee Payment Handlers =====

  FVoid _onCollectFee(CollectFee event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final payment = await _repository.collectFee(event.request);
        emit(state.copyWith(
            state: state.success, selectedPayment: payment));
      },
      dioError: (e) {
        Log.e('Error collecting fee: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error collecting fee: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchStudentPayments(
      FetchStudentPayments event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final payments =
            await _repository.getStudentPayments(event.studentId);
        emit(state.copyWith(state: state.success, payments: payments));
      },
      dioError: (e) {
        Log.e('Error fetching student payments: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching student payments: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchStudentPendingFees(
      FetchStudentPendingFees event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final pending =
            await _repository.getStudentPendingFees(event.studentId);
        emit(state.copyWith(state: state.success, pendingFees: pending));
      },
      dioError: (e) {
        Log.e('Error fetching pending fees: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching pending fees: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchAllPayments(
      FetchAllPayments event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final payments = await _repository.getAllPayments();
        emit(state.copyWith(state: state.success, payments: payments));
      },
      dioError: (e) {
        Log.e('Error fetching all payments: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching all payments: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchReceipt(FetchReceipt event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final payment = await _repository.getReceipt(event.paymentId);
        emit(state.copyWith(
            state: state.success, selectedPayment: payment));
      },
      dioError: (e) {
        Log.e('Error fetching receipt: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching receipt: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchOverduePayments(
      FetchOverduePayments event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final overdue = await _repository.getOverduePayments();
        emit(state.copyWith(
            state: state.success, overduePayments: overdue));
      },
      dioError: (e) {
        Log.e('Error fetching overdue payments: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching overdue payments: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchCollectionReport(
      FetchCollectionReport event, Emitter<FeeState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final report = await _repository.getCollectionReport();
        emit(state.copyWith(
            state: state.success, collectionReport: report));
      },
      dioError: (e) {
        Log.e('Error fetching collection report: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching collection report: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
