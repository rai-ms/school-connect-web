part of 'fee_bloc.dart';

class FeeEvent extends BlocEvent {
  const FeeEvent();
}

class FetchFeeTypes extends FeeEvent {
  const FetchFeeTypes();
}

class FetchActiveFeeTypes extends FeeEvent {
  const FetchActiveFeeTypes();
}

class CreateFeeType extends FeeEvent {
  final FeeTypeRequest request;
  const CreateFeeType(this.request);
}

class UpdateFeeType extends FeeEvent {
  final String id;
  final FeeTypeRequest request;
  const UpdateFeeType(this.id, this.request);
}

class DeleteFeeType extends FeeEvent {
  final String id;
  const DeleteFeeType(this.id);
}

class FetchFeeStructures extends FeeEvent {
  const FetchFeeStructures();
}

class FetchFeeStructuresByClass extends FeeEvent {
  final String classId;
  const FetchFeeStructuresByClass(this.classId);
}

class CreateFeeStructure extends FeeEvent {
  final FeeStructureRequest request;
  const CreateFeeStructure(this.request);
}

class UpdateFeeStructure extends FeeEvent {
  final String id;
  final FeeStructureRequest request;
  const UpdateFeeStructure(this.id, this.request);
}

class CollectFee extends FeeEvent {
  final FeePaymentRequest request;
  const CollectFee(this.request);
}

class FetchStudentPayments extends FeeEvent {
  final String studentId;
  const FetchStudentPayments(this.studentId);
}

class FetchStudentPendingFees extends FeeEvent {
  final String studentId;
  const FetchStudentPendingFees(this.studentId);
}

class FetchAllPayments extends FeeEvent {
  const FetchAllPayments();
}

class FetchReceipt extends FeeEvent {
  final String paymentId;
  const FetchReceipt(this.paymentId);
}

class FetchOverduePayments extends FeeEvent {
  const FetchOverduePayments();
}

class FetchCollectionReport extends FeeEvent {
  const FetchCollectionReport();
}
