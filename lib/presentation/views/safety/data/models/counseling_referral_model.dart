class CounselingReferralRequest {
  final String studentId;
  final String studentName;
  final String? classInfo;
  final String reason;
  final String urgency;

  CounselingReferralRequest({
    required this.studentId,
    required this.studentName,
    this.classInfo,
    required this.reason,
    required this.urgency,
  });

  Map<String, dynamic> toJson() => {
    'studentId': studentId,
    'studentName': studentName,
    if (classInfo != null) 'classInfo': classInfo,
    'reason': reason,
    'urgency': urgency.toUpperCase(),
  };
}

class CounselingReferralResponse {
  final String id;
  final String studentId;
  final String studentName;
  final String? classInfo;
  final String reason;
  final String urgency;
  final String status;
  final String? referredBy;
  final DateTime? createdAt;

  CounselingReferralResponse({
    required this.id,
    required this.studentId,
    required this.studentName,
    this.classInfo,
    required this.reason,
    required this.urgency,
    required this.status,
    this.referredBy,
    this.createdAt,
  });

  factory CounselingReferralResponse.fromJson(Map<String, dynamic> json) {
    return CounselingReferralResponse(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      classInfo: json['classInfo'],
      reason: json['reason'] ?? '',
      urgency: json['urgency'] ?? 'MEDIUM',
      status: json['status'] ?? 'PENDING',
      referredBy: json['referredBy'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
