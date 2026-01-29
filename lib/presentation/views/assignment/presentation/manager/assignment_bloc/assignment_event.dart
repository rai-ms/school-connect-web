part of 'assignment_bloc.dart';

class AssignmentEvent extends BlocEvent {
  const AssignmentEvent();
}

class FetchAssignments extends AssignmentEvent {
  final String? classId;
  final String? teacherId;
  final String? subjectId;
  final String? status;
  final String? type;

  const FetchAssignments({
    this.classId,
    this.teacherId,
    this.subjectId,
    this.status,
    this.type,
  });
}

class FetchAssignmentById extends AssignmentEvent {
  final String assignmentId;
  const FetchAssignmentById(this.assignmentId);
}

class FetchAssignmentsByClass extends AssignmentEvent {
  final String classId;
  const FetchAssignmentsByClass(this.classId);
}

class FetchAssignmentsByTeacher extends AssignmentEvent {
  final String teacherId;
  const FetchAssignmentsByTeacher(this.teacherId);
}

class FetchAssignmentsBySubject extends AssignmentEvent {
  final String subjectId;
  const FetchAssignmentsBySubject(this.subjectId);
}

class CreateAssignment extends AssignmentEvent {
  final CreateAssignmentRequest request;
  const CreateAssignment(this.request);
}

class UpdateAssignment extends AssignmentEvent {
  final String assignmentId;
  final UpdateAssignmentRequest request;
  const UpdateAssignment(this.assignmentId, this.request);
}

class DeleteAssignment extends AssignmentEvent {
  final String assignmentId;
  const DeleteAssignment(this.assignmentId);
}

class SubmitAssignment extends AssignmentEvent {
  final String assignmentId;
  final SubmitAssignmentRequest request;
  const SubmitAssignment(this.assignmentId, this.request);
}

class GradeSubmission extends AssignmentEvent {
  final String submissionId;
  final GradeSubmissionRequest request;
  const GradeSubmission(this.submissionId, this.request);
}

class FetchSubmissions extends AssignmentEvent {
  final String assignmentId;
  const FetchSubmissions(this.assignmentId);
}

class FetchStudentSubmissions extends AssignmentEvent {
  final String studentId;
  const FetchStudentSubmissions(this.studentId);
}

class FetchAssignmentStatistics extends AssignmentEvent {
  final String assignmentId;
  const FetchAssignmentStatistics(this.assignmentId);
}
