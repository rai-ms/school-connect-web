class EmergencyAlertRequest {
  final String title;
  final String? message;
  final String alertType;
  final String severity;
  final String? location;
  final String? targetAudience;

  EmergencyAlertRequest({
    required this.title,
    this.message,
    required this.alertType,
    required this.severity,
    this.location,
    this.targetAudience,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    if (message != null) 'message': message,
    'alertType': alertType.toUpperCase(),
    'severity': severity.toUpperCase(),
    if (location != null) 'location': location,
    if (targetAudience != null) 'targetAudience': targetAudience,
  };
}

class EmergencyAlertResponse {
  final String id;
  final String title;
  final String? message;
  final String alertType;
  final String severity;
  final bool isActive;
  final bool acknowledged;
  final String? triggeredBy;
  final DateTime? createdAt;

  EmergencyAlertResponse({
    required this.id,
    required this.title,
    this.message,
    required this.alertType,
    required this.severity,
    required this.isActive,
    required this.acknowledged,
    this.triggeredBy,
    this.createdAt,
  });

  factory EmergencyAlertResponse.fromJson(Map<String, dynamic> json) {
    return EmergencyAlertResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'],
      alertType: json['alertType'] ?? 'SOS',
      severity: json['severity'] ?? 'HIGH',
      isActive: json['isActive'] ?? true,
      acknowledged: json['acknowledged'] ?? false,
      triggeredBy: json['triggeredBy'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
