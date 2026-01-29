import 'fee_type_model.dart';

class FeeStructureRequest {
  final String feeTypeId;
  final String classId;
  final double amount;
  final String? dueDate;
  final double? lateFee;
  final double? discountPercentage;
  final String? academicYear;
  final String? term;
  final bool? isActive;

  FeeStructureRequest({
    required this.feeTypeId,
    required this.classId,
    required this.amount,
    this.dueDate,
    this.lateFee,
    this.discountPercentage,
    this.academicYear,
    this.term,
    this.isActive,
  });

  Map<String, dynamic> toJson() => {
        'feeType': {'id': feeTypeId},
        'classId': classId,
        'amount': amount,
        if (dueDate != null) 'dueDate': dueDate,
        if (lateFee != null) 'lateFee': lateFee,
        if (discountPercentage != null)
          'discountPercentage': discountPercentage,
        if (academicYear != null) 'academicYear': academicYear,
        if (term != null) 'term': term,
        if (isActive != null) 'isActive': isActive,
      };
}

class FeeStructureResponse {
  final String id;
  final FeeTypeResponse? feeType;
  final String classId;
  final double amount;
  final String? dueDate;
  final double lateFee;
  final double discountPercentage;
  final String? academicYear;
  final String? term;
  final bool isActive;
  final DateTime? createdAt;

  FeeStructureResponse({
    required this.id,
    this.feeType,
    required this.classId,
    required this.amount,
    this.dueDate,
    this.lateFee = 0.0,
    this.discountPercentage = 0.0,
    this.academicYear,
    this.term,
    this.isActive = true,
    this.createdAt,
  });

  factory FeeStructureResponse.fromJson(Map<String, dynamic> json) {
    return FeeStructureResponse(
      id: json['id'] ?? '',
      feeType: json['feeType'] != null
          ? FeeTypeResponse.fromJson(json['feeType'])
          : null,
      classId: json['classId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      dueDate: json['dueDate'],
      lateFee: (json['lateFee'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      academicYear: json['academicYear'],
      term: json['term'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  bool get isOverdue {
    if (dueDate == null) return false;
    final due = DateTime.tryParse(dueDate!);
    if (due == null) return false;
    return DateTime.now().isAfter(due);
  }

  double get effectiveAmount {
    final discount = amount * (discountPercentage / 100);
    final base = amount - discount;
    return isOverdue ? base + lateFee : base;
  }
}
