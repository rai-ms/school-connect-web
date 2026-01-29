import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/exam_model.dart';
import '../../../data/models/exam_result_model.dart';
import '../../../data/models/exam_type_model.dart';
import '../../../data/repositories/exam_repository.dart';

part 'exam_event.dart';
part 'exam_state.dart';

@injectable
class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final ExamRepository _examRepository;
  final StateRequestHandler _handler;

  ExamBloc(this._examRepository, this._handler) : super(const ExamState()) {
    on<FetchExamTypes>(_onFetchExamTypes);
    on<FetchExams>(_onFetchExams);
    on<FetchUpcomingExams>(_onFetchUpcomingExams);
    on<FetchExamsByClass>(_onFetchExamsByClass);
    on<FetchExamDetails>(_onFetchExamDetails);
    on<CreateExam>(_onCreateExam);
    on<UpdateExam>(_onUpdateExam);
    on<DeleteExam>(_onDeleteExam);
    on<CreateExamType>(_onCreateExamType);
    on<EnterMarks>(_onEnterMarks);
    on<EnterBulkMarks>(_onEnterBulkMarks);
    on<FetchExamResults>(_onFetchExamResults);
    on<FetchExamStatistics>(_onFetchExamStatistics);
    on<FetchStudentResults>(_onFetchStudentResults);
    on<FetchReportCard>(_onFetchReportCard);
  }

  FVoid _onFetchExamTypes(
    FetchExamTypes event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final types = await _examRepository.getActiveExamTypes();
        emit(state.copyWith(state: state.success, examTypes: types));
      },
      dioError: (e) {
        Log.e('Error fetching exam types: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching exam types: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchExams(
    FetchExams event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final exams = await _examRepository.getExams();
        emit(state.copyWith(state: state.success, exams: exams));
      },
      dioError: (e) {
        Log.e('Error fetching exams: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching exams: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchUpcomingExams(
    FetchUpcomingExams event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final exams = await _examRepository.getUpcomingExams();
        emit(state.copyWith(state: state.success, upcomingExams: exams));
      },
      dioError: (e) {
        Log.e('Error fetching upcoming exams: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching upcoming exams: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchExamsByClass(
    FetchExamsByClass event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final exams = await _examRepository.getExamsByClass(event.classId);
        emit(state.copyWith(state: state.success, exams: exams));
      },
      dioError: (e) {
        Log.e('Error fetching exams by class: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching exams by class: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchExamDetails(
    FetchExamDetails event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final exam = await _examRepository.getExamById(event.examId);
        emit(state.copyWith(state: state.success, selectedExam: exam));
      },
      dioError: (e) {
        Log.e('Error fetching exam details: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching exam details: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateExam(
    CreateExam event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _examRepository.createExam(event.request);
        Log.d('Exam created successfully');
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error creating exam: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating exam: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onUpdateExam(
    UpdateExam event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _examRepository.updateExam(event.examId, event.request);
        Log.d('Exam updated successfully');
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error updating exam: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error updating exam: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onDeleteExam(
    DeleteExam event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _examRepository.deleteExam(event.examId);
        Log.d('Exam deleted successfully');
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error deleting exam: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error deleting exam: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateExamType(
    CreateExamType event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _examRepository.createExamType(event.request);
        Log.d('Exam type created successfully');
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error creating exam type: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating exam type: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onEnterMarks(
    EnterMarks event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _examRepository.enterMarks(event.examId, event.request);
        Log.d('Marks entered successfully');
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error entering marks: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error entering marks: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onEnterBulkMarks(
    EnterBulkMarks event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final results =
            await _examRepository.enterBulkMarks(event.examId, event.requests);
        Log.d('Bulk marks entered for ${results.length} students');
        emit(state.copyWith(state: state.success, examResults: results));
      },
      dioError: (e) {
        Log.e('Error entering bulk marks: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error entering bulk marks: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchExamResults(
    FetchExamResults event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final results = await _examRepository.getExamResults(event.examId);
        emit(state.copyWith(state: state.success, examResults: results));
      },
      dioError: (e) {
        Log.e('Error fetching exam results: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching exam results: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchExamStatistics(
    FetchExamStatistics event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final stats = await _examRepository.getExamStatistics(event.examId);
        emit(state.copyWith(state: state.success, statistics: stats));
      },
      dioError: (e) {
        Log.e('Error fetching statistics: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching statistics: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchStudentResults(
    FetchStudentResults event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final results =
            await _examRepository.getStudentResults(event.studentId);
        emit(state.copyWith(state: state.success, studentResults: results));
      },
      dioError: (e) {
        Log.e('Error fetching student results: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching student results: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchReportCard(
    FetchReportCard event,
    Emitter<ExamState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final reportCard =
            await _examRepository.getReportCard(event.studentId);
        emit(state.copyWith(state: state.success, reportCard: reportCard));
      },
      dioError: (e) {
        Log.e('Error fetching report card: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching report card: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
