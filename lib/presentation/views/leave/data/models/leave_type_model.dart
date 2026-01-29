class LeaveTypeRequest {
  final String name;
  final String? description;
  final int maxDaysPerYear;
  final bool isPaid;
  final bool requiresApproval;
  final String? applicableRoles;
  final bool isActive;

  LeaveTypeRequest({
    required this.name,
    this.description,
    this.maxDaysPerYear = 12,
    this.isPaid = true,
    this.requiresApproval = true,
    this.applicableRoles,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        'maxDaysPerYear': maxDaysPerYear,
        'isPaid': isPaid,
        'requiresApproval': requiresApproval,
        if (applicableRoles != null) 'applicableRoles': applicableRoles,
        'isActive': isActive,
      };
}

class LeaveTypeResponse {
  final String id;
  final String name;
  final String? description;
  final int maxDaysPerYear;
  final bool isPaid;
  final bool requiresApproval;
  final String? applicableRoles;
  final bool isActive;

  LeaveTypeResponse({
    required this.id,
    required this.name,
    this.description,
    this.maxDaysPerYear = 12,
    this.isPaid = true,
    this.requiresApproval = true,
    this.applicableRoles,
    this.isActive = true,
  });

  factory LeaveTypeResponse.fromJson(Map<String, dynamic> json) {
    return LeaveTypeResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      maxDaysPerYear: json['maxDaysPerYear'] ?? 12,
      isPaid: json['isPaid'] ?? true,
      requiresApproval: json['requiresApproval'] ?? true,
      applicableRoles: json['applicableRoles'],
      isActive: json['isActive'] ?? true,
    );
  }
}
