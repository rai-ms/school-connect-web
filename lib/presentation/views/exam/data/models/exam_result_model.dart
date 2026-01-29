class ExamResultRequest {
  final String studentId;
  final String? studentName;
  final double marksObtained;
  final int maxMarks;
  final bool? isAbsent;
  final String? remarks;

  ExamResultRequest({
    required this.studentId,
    this.studentName,
    required this.marksObtained,
    required this.maxMarks,
    this.isAbsent,
    this.remarks,
  });

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        if (studentName != null) 'studentName': studentName,
        'marksObtained': marksObtained,
        'maxMarks': maxMarks,
        if (isAbsent != null) 'isAbsent': isAbsent,
        if (remarks != null) 'remarks': remarks,
      };
}

class ExamResultResponse {
  final String id;
  final String? examId;
  final String studentId;
  final String? studentName;
  final double marksObtained;
  final int maxMarks;
  final double? percentage;
  final String? grade;
  final int? rank;
  final String resultStatus;
  final String? remarks;
  final bool isAbsent;
  final DateTime? createdAt;
  final String? examName;
  final String? subjectName;

  ExamResultResponse({
    required this.id,
    this.examId,
    required this.studentId,
    this.studentName,
    required this.marksObtained,
    required this.maxMarks,
    this.percentage,
    this.grade,
    this.rank,
    this.resultStatus = 'PENDING',
    this.remarks,
    this.isAbsent = false,
    this.createdAt,
    this.examName,
    this.subjectName,
  });

  factory ExamResultResponse.fromJson(Map<String, dynamic> json) {
    return ExamResultResponse(
      id: json['id'] ?? '',
      examId: json['examId'] ?? json['exam']?['id'],
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'],
      marksObtained: (json['marksObtained'] as num?)?.toDouble() ?? 0.0,
      maxMarks: json['maxMarks'] ?? 100,
      percentage: (json['percentage'] as num?)?.toDouble(),
      grade: json['grade'],
      rank: json['rank'] as int?,
      resultStatus: json['resultStatus'] ?? 'PENDING',
      remarks: json['remarks'],
      isAbsent: json['isAbsent'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      examName: json['exam']?['name'],
      subjectName: json['exam']?['subjectName'],
    );
  }

  bool get isPassed => resultStatus == 'PASS';
  bool get isFailed => resultStatus == 'FAIL';
}

class ExamStatistics {
  final int totalStudents;
  final double averagePercentage;
  final int passed;
  final int failed;
  final double passPercentage;
  final double? highestMarks;
  final double? lowestMarks;
  final String? topper;

  ExamStatistics({
    required this.totalStudents,
    required this.averagePercentage,
    required this.passed,
    required this.failed,
    required this.passPercentage,
    this.highestMarks,
    this.lowestMarks,
    this.topper,
  });

  factory ExamStatistics.fromJson(Map<String, dynamic> json) {
    return ExamStatistics(
      totalStudents: json['totalStudents'] ?? 0,
      averagePercentage: (json['averagePercentage'] as num?)?.toDouble() ?? 0.0,
      passed: (json['passed'] as num?)?.toInt() ?? 0,
      failed: (json['failed'] as num?)?.toInt() ?? 0,
      passPercentage: (json['passPercentage'] as num?)?.toDouble() ?? 0.0,
      highestMarks: (json['highestMarks'] as num?)?.toDouble(),
      lowestMarks: (json['lowestMarks'] as num?)?.toDouble(),
      topper: json['topper'],
    );
  }
}

class ReportCard {
  final String studentId;
  final List<ExamResultResponse> results;
  final double overallPercentage;
  final String overallGrade;
  final int totalExams;
  final int examsTaken;

  ReportCard({
    required this.studentId,
    required this.results,
    required this.overallPercentage,
    required this.overallGrade,
    required this.totalExams,
    required this.examsTaken,
  });

  factory ReportCard.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List? ?? [];
    return ReportCard(
      studentId: json['studentId'] ?? '',
      results: resultsList
          .map((e) => ExamResultResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallPercentage:
          (json['overallPercentage'] as num?)?.toDouble() ?? 0.0,
      overallGrade: json['overallGrade'] ?? 'N/A',
      totalExams: json['totalExams'] ?? 0,
      examsTaken: (json['examsTaken'] as num?)?.toInt() ?? 0,
    );
  }
}
