import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/assignment_model.dart';
import '../../../data/repositories/assignment_repository.dart';

part 'assignment_event.dart';
part 'assignment_state.dart';

@injectable
class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final AssignmentRepository _assignmentRepository;
  final StateRequestHandler _handler;

  AssignmentBloc(this._assignmentRepository, this._handler)
      : super(const AssignmentState()) {
    on<FetchAssignments>(_onFetchAssignments);
    on<FetchAssignmentById>(_onFetchAssignmentById);
    on<FetchAssignmentsByClass>(_onFetchAssignmentsByClass);
    on<FetchAssignmentsByTeacher>(_onFetchAssignmentsByTeacher);
    on<FetchAssignmentsBySubject>(_onFetchAssignmentsBySubject);
    on<CreateAssignment>(_onCreateAssignment);
    on<UpdateAssignment>(_onUpdateAssignment);
    on<DeleteAssignment>(_onDeleteAssignment);
    on<SubmitAssignment>(_onSubmitAssignment);
    on<GradeSubmission>(_onGradeSubmission);
    on<FetchSubmissions>(_onFetchSubmissions);
    on<FetchStudentSubmissions>(_onFetchStudentSubmissions);
    on<FetchAssignmentStatistics>(_onFetchAssignmentStatistics);
  }

  FVoid _onFetchAssignments(
    FetchAssignments event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final assignments = await _assignmentRepository.getAssignments(
          classId: event.classId,
          teacherId: event.teacherId,
          subjectId: event.subjectId,
          status: event.status,
          type: event.type,
        );
        emit(state.copyWith(
            state: state.success, assignments: assignments));
      },
      dioError: (e) {
        Log.e('Error fetching assignments: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching assignments: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchAssignmentById(
    FetchAssignmentById event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final assignment =
            await _assignmentRepository.getAssignmentById(event.assignmentId);
        emit(state.copyWith(
            state: state.success, selectedAssignment: assignment));
      },
      dioError: (e) {
        Log.e('Error fetching assignment: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching assignment: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchAssignmentsByClass(
    FetchAssignmentsByClass event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final assignments =
            await _assignmentRepository.getAssignmentsByClass(event.classId);
        emit(state.copyWith(
            state: state.success, assignments: assignments));
      },
      dioError: (e) {
        Log.e('Error fetching assignments by class: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching assignments by class: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchAssignmentsByTeacher(
    FetchAssignmentsByTeacher event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final assignments = await _assignmentRepository
            .getAssignmentsByTeacher(event.teacherId);
        emit(state.copyWith(
            state: state.success, assignments: assignments));
      },
      dioError: (e) {
        Log.e('Error fetching assignments by teacher: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching assignments by teacher: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchAssignmentsBySubject(
    FetchAssignmentsBySubject event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final assignments = await _assignmentRepository
            .getAssignmentsBySubject(event.subjectId);
        emit(state.copyWith(
            state: state.success, assignments: assignments));
      },
      dioError: (e) {
        Log.e('Error fetching assignments by subject: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching assignments by subject: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateAssignment(
    CreateAssignment event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _assignmentRepository.createAssignment(event.request);
        Log.d('Assignment created successfully');
        emit(state.copyWith(
            state: state.success, actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error creating assignment: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating assignment: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onUpdateAssignment(
    UpdateAssignment event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _assignmentRepository.updateAssignment(
            event.assignmentId, event.request);
        Log.d('Assignment updated successfully');
        emit(state.copyWith(
            state: state.success, actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error updating assignment: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error updating assignment: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onDeleteAssignment(
    DeleteAssignment event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _assignmentRepository.deleteAssignment(event.assignmentId);
        Log.d('Assignment deleted successfully');
        emit(state.copyWith(
            state: state.success, actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error deleting assignment: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error deleting assignment: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onSubmitAssignment(
    SubmitAssignment event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _assignmentRepository.submitAssignment(
            event.assignmentId, event.request);
        Log.d('Assignment submitted successfully');
        emit(state.copyWith(
            state: state.success, actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error submitting assignment: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error submitting assignment: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onGradeSubmission(
    GradeSubmission event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _assignmentRepository.gradeSubmission(
            event.submissionId, event.request);
        Log.d('Submission graded successfully');
        emit(state.copyWith(
            state: state.success, actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error grading submission: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error grading submission: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchSubmissions(
    FetchSubmissions event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final submissions = await _assignmentRepository
            .getSubmissionsByAssignment(event.assignmentId);
        emit(state.copyWith(
            state: state.success, submissions: submissions));
      },
      dioError: (e) {
        Log.e('Error fetching submissions: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching submissions: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchStudentSubmissions(
    FetchStudentSubmissions event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final submissions = await _assignmentRepository
            .getStudentSubmissions(event.studentId);
        emit(state.copyWith(
            state: state.success, submissions: submissions));
      },
      dioError: (e) {
        Log.e('Error fetching student submissions: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching student submissions: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchAssignmentStatistics(
    FetchAssignmentStatistics event,
    Emitter<AssignmentState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final stats = await _assignmentRepository
            .getAssignmentStatistics(event.assignmentId);
        emit(state.copyWith(
            state: state.success, statistics: stats));
      },
      dioError: (e) {
        Log.e('Error fetching assignment statistics: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching assignment statistics: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
