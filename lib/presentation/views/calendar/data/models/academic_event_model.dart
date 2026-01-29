class CreateAcademicEventRequest {
  final String title;
  final String? description;
  final String eventType;
  final String startDate;
  final String endDate;
  final bool? isAllDay;
  final bool? isRecurring;
  final String? color;
  final String? targetAudience;
  final String? classId;
  final String? academicYear;

  CreateAcademicEventRequest({
    required this.title,
    this.description,
    required this.eventType,
    required this.startDate,
    required this.endDate,
    this.isAllDay = true,
    this.isRecurring = false,
    this.color,
    this.targetAudience = 'ALL',
    this.classId,
    this.academicYear,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'eventType': eventType,
        'startDate': startDate,
        'endDate': endDate,
        if (description != null) 'description': description,
        if (isAllDay != null) 'isAllDay': isAllDay,
        if (isRecurring != null) 'isRecurring': isRecurring,
        if (color != null) 'color': color,
        if (targetAudience != null) 'targetAudience': targetAudience,
        if (classId != null) 'classId': classId,
        if (academicYear != null) 'academicYear': academicYear,
      };
}

class AcademicEventResponse {
  final String id;
  final String title;
  final String? description;
  final String eventType;
  final String startDate;
  final String endDate;
  final bool isAllDay;
  final bool isRecurring;
  final String? color;
  final String targetAudience;
  final String? classId;
  final String? academicYear;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;

  AcademicEventResponse({
    required this.id,
    required this.title,
    this.description,
    required this.eventType,
    required this.startDate,
    required this.endDate,
    this.isAllDay = true,
    this.isRecurring = false,
    this.color,
    this.targetAudience = 'ALL',
    this.classId,
    this.academicYear,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory AcademicEventResponse.fromJson(Map<String, dynamic> json) {
    return AcademicEventResponse(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      eventType: json['eventType'] ?? 'CUSTOM',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      isAllDay: json['isAllDay'] ?? json['allDay'] ?? true,
      isRecurring: json['isRecurring'] ?? json['recurring'] ?? false,
      color: json['color'],
      targetAudience: json['targetAudience'] ?? 'ALL',
      classId: json['classId'],
      academicYear: json['academicYear'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  DateTime get startDateTime => DateTime.parse(startDate);
  DateTime get endDateTime => DateTime.parse(endDate);

  String get eventTypeLabel {
    switch (eventType) {
      case 'HOLIDAY':
        return 'Holiday';
      case 'EXAM':
        return 'Exam';
      case 'MEETING':
        return 'Meeting';
      case 'ACTIVITY':
        return 'Activity';
      case 'CUSTOM':
        return 'Custom';
      default:
        return eventType;
    }
  }

  String get audienceLabel {
    switch (targetAudience) {
      case 'ALL':
        return 'Everyone';
      case 'STUDENTS':
        return 'Students';
      case 'TEACHERS':
        return 'Teachers';
      case 'PARENTS':
        return 'Parents';
      default:
        return targetAudience;
    }
  }
}
