class LeaveBalanceResponse {
  final String id;
  final String userId;
  final String? leaveTypeId;
  final String? leaveTypeName;
  final String academicYear;
  final int totalAllocated;
  final int used;
  final int pending;

  LeaveBalanceResponse({
    required this.id,
    required this.userId,
    this.leaveTypeId,
    this.leaveTypeName,
    required this.academicYear,
    this.totalAllocated = 0,
    this.used = 0,
    this.pending = 0,
  });

  factory LeaveBalanceResponse.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceResponse(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      leaveTypeId:
          json['leaveType'] is Map ? json['leaveType']['id'] : null,
      leaveTypeName:
          json['leaveType'] is Map ? json['leaveType']['name'] : null,
      academicYear: json['academicYear'] ?? '',
      totalAllocated: json['totalAllocated'] ?? 0,
      used: json['used'] ?? 0,
      pending: json['pending'] ?? 0,
    );
  }

  int get remaining => totalAllocated - used - pending;

  double get usagePercentage =>
      totalAllocated > 0 ? (used / totalAllocated) * 100 : 0;
}

class LeaveSummaryResponse {
  final List<LeaveBalanceResponse> balances;
  final int pendingRequests;
  final String academicYear;
  final int totalAllocated;
  final int totalUsed;
  final int totalPending;
  final int totalRemaining;

  LeaveSummaryResponse({
    required this.balances,
    this.pendingRequests = 0,
    required this.academicYear,
    this.totalAllocated = 0,
    this.totalUsed = 0,
    this.totalPending = 0,
    this.totalRemaining = 0,
  });

  factory LeaveSummaryResponse.fromJson(Map<String, dynamic> json) {
    final balancesList = (json['balances'] as List? ?? [])
        .map((e) => LeaveBalanceResponse.fromJson(e))
        .toList();

    return LeaveSummaryResponse(
      balances: balancesList,
      pendingRequests: json['pendingRequests'] ?? 0,
      academicYear: json['academicYear'] ?? '',
      totalAllocated: json['totalAllocated'] ?? 0,
      totalUsed: json['totalUsed'] ?? 0,
      totalPending: json['totalPending'] ?? 0,
      totalRemaining: json['totalRemaining'] ?? 0,
    );
  }
}
