part of 'exam_bloc.dart';

class ExamEvent extends BlocEvent {
  const ExamEvent();
}

class FetchExamTypes extends ExamEvent {
  const FetchExamTypes();
}

class FetchExams extends ExamEvent {
  const FetchExams();
}

class FetchUpcomingExams extends ExamEvent {
  const FetchUpcomingExams();
}

class FetchExamsByClass extends ExamEvent {
  final String classId;
  const FetchExamsByClass(this.classId);
}

class FetchExamDetails extends ExamEvent {
  final String examId;
  const FetchExamDetails(this.examId);
}

class CreateExam extends ExamEvent {
  final ExamRequest request;
  const CreateExam(this.request);
}

class UpdateExam extends ExamEvent {
  final String examId;
  final ExamRequest request;
  const UpdateExam(this.examId, this.request);
}

class DeleteExam extends ExamEvent {
  final String examId;
  const DeleteExam(this.examId);
}

class CreateExamType extends ExamEvent {
  final ExamTypeRequest request;
  const CreateExamType(this.request);
}

class EnterMarks extends ExamEvent {
  final String examId;
  final ExamResultRequest request;
  const EnterMarks(this.examId, this.request);
}

class EnterBulkMarks extends ExamEvent {
  final String examId;
  final List<ExamResultRequest> requests;
  const EnterBulkMarks(this.examId, this.requests);
}

class FetchExamResults extends ExamEvent {
  final String examId;
  const FetchExamResults(this.examId);
}

class FetchExamStatistics extends ExamEvent {
  final String examId;
  const FetchExamStatistics(this.examId);
}

class FetchStudentResults extends ExamEvent {
  final String studentId;
  const FetchStudentResults(this.studentId);
}

class FetchReportCard extends ExamEvent {
  final String studentId;
  const FetchReportCard(this.studentId);
}
