class LeaveRequestCreate {
  final String leaveTypeId;
  final String startDate;
  final String endDate;
  final String reason;
  final bool isHalfDay;
  final String? attachmentUrl;

  LeaveRequestCreate({
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.isHalfDay = false,
    this.attachmentUrl,
  });

  Map<String, dynamic> toJson() => {
        'leaveType': {'id': leaveTypeId},
        'startDate': startDate,
        'endDate': endDate,
        'reason': reason,
        'isHalfDay': isHalfDay,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      };
}

class LeaveRequestResponse {
  final String id;
  final String? leaveTypeId;
  final String? leaveTypeName;
  final String userId;
  final String? userName;
  final String? userRole;
  final String startDate;
  final String endDate;
  final int totalDays;
  final String reason;
  final String status;
  final String? approvedBy;
  final String? approvedByName;
  final String? approvalRemarks;
  final String? approvedAt;
  final bool isHalfDay;
  final String? attachmentUrl;
  final DateTime? createdAt;

  LeaveRequestResponse({
    required this.id,
    this.leaveTypeId,
    this.leaveTypeName,
    required this.userId,
    this.userName,
    this.userRole,
    required this.startDate,
    required this.endDate,
    this.totalDays = 0,
    required this.reason,
    this.status = 'PENDING',
    this.approvedBy,
    this.approvedByName,
    this.approvalRemarks,
    this.approvedAt,
    this.isHalfDay = false,
    this.attachmentUrl,
    this.createdAt,
  });

  factory LeaveRequestResponse.fromJson(Map<String, dynamic> json) {
    return LeaveRequestResponse(
      id: json['id'] ?? '',
      leaveTypeId: json['leaveType'] is Map ? json['leaveType']['id'] : null,
      leaveTypeName:
          json['leaveType'] is Map ? json['leaveType']['name'] : null,
      userId: json['userId'] ?? '',
      userName: json['userName'],
      userRole: json['userRole'],
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      totalDays: json['totalDays'] ?? 0,
      reason: json['reason'] ?? '',
      status: json['status'] ?? 'PENDING',
      approvedBy: json['approvedBy'],
      approvedByName: json['approvedByName'],
      approvalRemarks: json['approvalRemarks'],
      approvedAt: json['approvedAt'],
      isHalfDay: json['isHalfDay'] ?? false,
      attachmentUrl: json['attachmentUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  bool get isPending => status == 'PENDING';
  bool get isApproved => status == 'APPROVED';
  bool get isRejected => status == 'REJECTED';
  bool get isCancelled => status == 'CANCELLED';

  String get statusLabel {
    switch (status) {
      case 'APPROVED':
        return 'Approved';
      case 'REJECTED':
        return 'Rejected';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  String get dateRange {
    if (startDate == endDate) return startDate;
    return '$startDate - $endDate';
  }
}
