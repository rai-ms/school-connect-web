class IncidentReportRequest {
  final String title;
  final String description;
  final String category;
  final String severity;
  final String? location;
  final DateTime? occurredAt;
  final List<String>? attachments;

  IncidentReportRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    this.location,
    this.occurredAt,
    this.attachments,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'category': category.toUpperCase(),
    'severity': severity.toUpperCase(),
    if (location != null) 'location': location,
    if (occurredAt != null) 'occurredAt': occurredAt!.toIso8601String(),
    if (attachments != null) 'attachments': attachments,
  };
}

class IncidentReportResponse {
  final String id;
  final String title;
  final String description;
  final String category;
  final String severity;
  final String status;
  final String? location;
  final String? reportedBy;
  final DateTime? occurredAt;
  final DateTime? createdAt;

  IncidentReportResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.status,
    this.location,
    this.reportedBy,
    this.occurredAt,
    this.createdAt,
  });

  factory IncidentReportResponse.fromJson(Map<String, dynamic> json) {
    return IncidentReportResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      severity: json['severity'] ?? '',
      status: json['status'] ?? 'REPORTED',
      location: json['location'],
      reportedBy: json['reportedBy'],
      occurredAt: json['occurredAt'] != null
          ? DateTime.tryParse(json['occurredAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
