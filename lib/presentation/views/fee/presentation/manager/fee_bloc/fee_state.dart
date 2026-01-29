part of 'fee_bloc.dart';

class FeeState extends BlocEventState<List<FeePaymentResponse>> {
  final List<FeeTypeResponse> feeTypes;
  final List<FeeStructureResponse> feeStructures;
  final List<FeePaymentResponse> payments;
  final List<FeePaymentResponse> pendingFees;
  final List<FeePaymentResponse> overduePayments;
  final FeePaymentResponse? selectedPayment;
  final CollectionReport? collectionReport;

  const FeeState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.feeTypes = const [],
    this.feeStructures = const [],
    this.payments = const [],
    this.pendingFees = const [],
    this.overduePayments = const [],
    this.selectedPayment,
    this.collectionReport,
  });

  @override
  FeeState copyWith({
    BlocState? state,
    List<FeePaymentResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<FeeTypeResponse>? feeTypes,
    List<FeeStructureResponse>? feeStructures,
    List<FeePaymentResponse>? payments,
    List<FeePaymentResponse>? pendingFees,
    List<FeePaymentResponse>? overduePayments,
    FeePaymentResponse? selectedPayment,
    CollectionReport? collectionReport,
  }) {
    return FeeState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      feeTypes: feeTypes ?? this.feeTypes,
      feeStructures: feeStructures ?? this.feeStructures,
      payments: payments ?? this.payments,
      pendingFees: pendingFees ?? this.pendingFees,
      overduePayments: overduePayments ?? this.overduePayments,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      collectionReport: collectionReport ?? this.collectionReport,
    );
  }

  @override
  FeeState clear({BlocState? state, BlocEvent? event}) =>
      FeeState(state: state ?? super.state, event: event);
}
