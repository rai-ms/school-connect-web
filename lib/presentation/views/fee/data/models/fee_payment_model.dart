import 'fee_structure_model.dart';

class FeePaymentRequest {
  final String feeStructureId;
  final String studentId;
  final String? studentName;
  final double amountPaid;
  final double totalAmount;
  final double? discountAmount;
  final double? lateFeeAmount;
  final String? paymentMode;
  final String? transactionId;
  final String? remarks;
  final String? collectedBy;

  FeePaymentRequest({
    required this.feeStructureId,
    required this.studentId,
    this.studentName,
    required this.amountPaid,
    required this.totalAmount,
    this.discountAmount,
    this.lateFeeAmount,
    this.paymentMode,
    this.transactionId,
    this.remarks,
    this.collectedBy,
  });

  Map<String, dynamic> toJson() => {
        'feeStructure': {'id': feeStructureId},
        'studentId': studentId,
        if (studentName != null) 'studentName': studentName,
        'amountPaid': amountPaid,
        'totalAmount': totalAmount,
        if (discountAmount != null) 'discountAmount': discountAmount,
        if (lateFeeAmount != null) 'lateFeeAmount': lateFeeAmount,
        if (paymentMode != null) 'paymentMode': paymentMode,
        if (transactionId != null) 'transactionId': transactionId,
        if (remarks != null) 'remarks': remarks,
        if (collectedBy != null) 'collectedBy': collectedBy,
      };
}

class FeePaymentResponse {
  final String id;
  final FeeStructureResponse? feeStructure;
  final String studentId;
  final String? studentName;
  final double amountPaid;
  final double totalAmount;
  final double discountAmount;
  final double lateFeeAmount;
  final double balanceAmount;
  final String? paymentDate;
  final String paymentStatus;
  final String? paymentMode;
  final String? transactionId;
  final String? receiptNumber;
  final String? remarks;
  final String? collectedBy;
  final DateTime? createdAt;

  FeePaymentResponse({
    required this.id,
    this.feeStructure,
    required this.studentId,
    this.studentName,
    required this.amountPaid,
    required this.totalAmount,
    this.discountAmount = 0.0,
    this.lateFeeAmount = 0.0,
    this.balanceAmount = 0.0,
    this.paymentDate,
    this.paymentStatus = 'PENDING',
    this.paymentMode,
    this.transactionId,
    this.receiptNumber,
    this.remarks,
    this.collectedBy,
    this.createdAt,
  });

  factory FeePaymentResponse.fromJson(Map<String, dynamic> json) {
    return FeePaymentResponse(
      id: json['id'] ?? '',
      feeStructure: json['feeStructure'] != null
          ? FeeStructureResponse.fromJson(json['feeStructure'])
          : null,
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'],
      amountPaid: (json['amountPaid'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      lateFeeAmount: (json['lateFeeAmount'] as num?)?.toDouble() ?? 0.0,
      balanceAmount: (json['balanceAmount'] as num?)?.toDouble() ?? 0.0,
      paymentDate: json['paymentDate'],
      paymentStatus: json['paymentStatus'] ?? 'PENDING',
      paymentMode: json['paymentMode'],
      transactionId: json['transactionId'],
      receiptNumber: json['receiptNumber'],
      remarks: json['remarks'],
      collectedBy: json['collectedBy'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  bool get isPaid => paymentStatus == 'PAID';
  bool get isPending => paymentStatus == 'PENDING';
  bool get isPartial => paymentStatus == 'PARTIAL';
  bool get isOverdue => paymentStatus == 'OVERDUE';
  bool get isCancelled => paymentStatus == 'CANCELLED';
}

class CollectionReport {
  final double totalCollected;
  final double totalPending;
  final int overdueCount;
  final double monthlyCollection;

  CollectionReport({
    this.totalCollected = 0.0,
    this.totalPending = 0.0,
    this.overdueCount = 0,
    this.monthlyCollection = 0.0,
  });

  factory CollectionReport.fromJson(Map<String, dynamic> json) {
    return CollectionReport(
      totalCollected: (json['totalCollected'] as num?)?.toDouble() ?? 0.0,
      totalPending: (json['totalPending'] as num?)?.toDouble() ?? 0.0,
      overdueCount: (json['overdueCount'] as num?)?.toInt() ?? 0,
      monthlyCollection:
          (json['monthlyCollection'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
