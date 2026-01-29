class CreateAssignmentRequest {
  final String title;
  final String? description;
  final String? subjectId;
  final String classId;
  final String? sectionId;
  final String teacherId;
  final String dueDate;
  final String? assignedDate;
  final int? maxMarks;
  final String? attachmentUrl;
  final String? status;
  final String? type;

  CreateAssignmentRequest({
    required this.title,
    this.description,
    this.subjectId,
    required this.classId,
    this.sectionId,
    required this.teacherId,
    required this.dueDate,
    this.assignedDate,
    this.maxMarks,
    this.attachmentUrl,
    this.status,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        if (description != null) 'description': description,
        if (subjectId != null) 'subjectId': subjectId,
        'classId': classId,
        if (sectionId != null) 'sectionId': sectionId,
        'teacherId': teacherId,
        'dueDate': dueDate,
        if (assignedDate != null) 'assignedDate': assignedDate,
        if (maxMarks != null) 'maxMarks': maxMarks,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
        if (status != null) 'status': status,
        if (type != null) 'type': type,
      };
}

class UpdateAssignmentRequest {
  final String? title;
  final String? description;
  final String? subjectId;
  final String? classId;
  final String? sectionId;
  final String? dueDate;
  final int? maxMarks;
  final String? attachmentUrl;
  final String? status;
  final String? type;

  UpdateAssignmentRequest({
    this.title,
    this.description,
    this.subjectId,
    this.classId,
    this.sectionId,
    this.dueDate,
    this.maxMarks,
    this.attachmentUrl,
    this.status,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (subjectId != null) 'subjectId': subjectId,
        if (classId != null) 'classId': classId,
        if (sectionId != null) 'sectionId': sectionId,
        if (dueDate != null) 'dueDate': dueDate,
        if (maxMarks != null) 'maxMarks': maxMarks,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
        if (status != null) 'status': status,
        if (type != null) 'type': type,
      };
}

class AssignmentResponse {
  final String id;
  final String title;
  final String? description;
  final String? subjectId;
  final String? classId;
  final String? sectionId;
  final String? teacherId;
  final String? dueDate;
  final String? assignedDate;
  final int maxMarks;
  final String? attachmentUrl;
  final String status;
  final String type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AssignmentResponse({
    required this.id,
    required this.title,
    this.description,
    this.subjectId,
    this.classId,
    this.sectionId,
    this.teacherId,
    this.dueDate,
    this.assignedDate,
    this.maxMarks = 100,
    this.attachmentUrl,
    this.status = 'DRAFT',
    this.type = 'HOMEWORK',
    this.createdAt,
    this.updatedAt,
  });

  factory AssignmentResponse.fromJson(Map<String, dynamic> json) {
    return AssignmentResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      subjectId: json['subjectId'],
      classId: json['classId'],
      sectionId: json['sectionId'],
      teacherId: json['teacherId'],
      dueDate: json['dueDate'],
      assignedDate: json['assignedDate'],
      maxMarks: json['maxMarks'] ?? 100,
      attachmentUrl: json['attachmentUrl'],
      status: json['status'] ?? 'DRAFT',
      type: json['type'] ?? 'HOMEWORK',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  bool get isDraft => status == 'DRAFT';
  bool get isPublished => status == 'PUBLISHED';
  bool get isClosed => status == 'CLOSED';
  bool get isHomework => type == 'HOMEWORK';
  bool get isClasswork => type == 'CLASSWORK';
  bool get isProject => type == 'PROJECT';

  bool get isOverdue {
    if (dueDate == null) return false;
    final date = DateTime.tryParse(dueDate!);
    return date != null && date.isBefore(DateTime.now());
  }
}

class SubmitAssignmentRequest {
  final String studentId;
  final String? content;
  final String? attachmentUrl;

  SubmitAssignmentRequest({
    required this.studentId,
    this.content,
    this.attachmentUrl,
  });

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        if (content != null) 'content': content,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      };
}

class GradeSubmissionRequest {
  final double marksObtained;
  final String? feedback;

  GradeSubmissionRequest({
    required this.marksObtained,
    this.feedback,
  });

  Map<String, dynamic> toJson() => {
        'marksObtained': marksObtained,
        if (feedback != null) 'feedback': feedback,
      };
}

class AssignmentSubmissionResponse {
  final String id;
  final String? assignmentId;
  final String studentId;
  final DateTime? submissionDate;
  final String? content;
  final String? attachmentUrl;
  final double? marksObtained;
  final String? feedback;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AssignmentSubmissionResponse({
    required this.id,
    this.assignmentId,
    required this.studentId,
    this.submissionDate,
    this.content,
    this.attachmentUrl,
    this.marksObtained,
    this.feedback,
    this.status = 'PENDING',
    this.createdAt,
    this.updatedAt,
  });

  factory AssignmentSubmissionResponse.fromJson(Map<String, dynamic> json) {
    return AssignmentSubmissionResponse(
      id: json['id'] ?? '',
      assignmentId: json['assignmentId'],
      studentId: json['studentId'] ?? '',
      submissionDate: json['submissionDate'] != null
          ? DateTime.tryParse(json['submissionDate'])
          : null,
      content: json['content'],
      attachmentUrl: json['attachmentUrl'],
      marksObtained: (json['marksObtained'] as num?)?.toDouble(),
      feedback: json['feedback'],
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  bool get isPending => status == 'PENDING';
  bool get isSubmitted => status == 'SUBMITTED';
  bool get isGraded => status == 'GRADED';
  bool get isLate => status == 'LATE';
}

class AssignmentStatistics {
  final int totalSubmissions;
  final int submittedCount;
  final int gradedCount;
  final int pendingCount;
  final double averageMarks;

  AssignmentStatistics({
    required this.totalSubmissions,
    required this.submittedCount,
    required this.gradedCount,
    required this.pendingCount,
    required this.averageMarks,
  });

  factory AssignmentStatistics.fromJson(Map<String, dynamic> json) {
    return AssignmentStatistics(
      totalSubmissions: (json['totalSubmissions'] as num?)?.toInt() ?? 0,
      submittedCount: (json['submittedCount'] as num?)?.toInt() ?? 0,
      gradedCount: (json['gradedCount'] as num?)?.toInt() ?? 0,
      pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
      averageMarks: (json['averageMarks'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
