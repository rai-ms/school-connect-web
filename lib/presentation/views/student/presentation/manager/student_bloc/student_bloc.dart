import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/student_model.dart';
import '../../../data/repositories/student_repository.dart';

part 'student_event.dart';
part 'student_state.dart';

@injectable
class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository _repository;
  final StateRequestHandler _handler;

  StudentBloc(this._repository, this._handler) : super(const StudentState()) {
    on<FetchStudents>(_onFetchStudents);
    on<FetchStudentById>(_onFetchById);
    on<CreateStudent>(_onCreateStudent);
    on<UpdateStudent>(_onUpdateStudent);
    on<DeleteStudent>(_onDeleteStudent);
    on<SearchStudents>(_onSearchStudents);
    on<FetchStudentStatistics>(_onFetchStatistics);
    on<FetchStudentsByClass>(_onFetchByClass);
  }

  FVoid _onFetchStudents(
      FetchStudents event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final students = await _repository.getAllStudents(
          classId: event.classId,
          search: event.search,
        );
        emit(state.copyWith(state: state.success, students: students));
      },
      dioError: (e) {
        Log.e('Error fetching students: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching students: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchById(
      FetchStudentById event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final student = await _repository.getStudentById(event.studentId);
        emit(state.copyWith(
            state: state.success, selectedStudent: student));
      },
      dioError: (e) {
        Log.e('Error fetching student: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching student: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateStudent(
      CreateStudent event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createStudent(event.request);
        final students = await _repository.getAllStudents();
        emit(state.copyWith(
            state: state.success,
            students: students,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error creating student: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating student: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onUpdateStudent(
      UpdateStudent event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final updated =
            await _repository.updateStudent(event.studentId, event.updates);
        emit(state.copyWith(
            state: state.success,
            selectedStudent: updated,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error updating student: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error updating student: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onDeleteStudent(
      DeleteStudent event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.deleteStudent(event.studentId);
        final students = await _repository.getAllStudents();
        emit(state.copyWith(
            state: state.success,
            students: students,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error deleting student: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error deleting student: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onSearchStudents(
      SearchStudents event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final students = await _repository.searchStudents(event.query);
        emit(state.copyWith(state: state.success, students: students));
      },
      dioError: (e) {
        Log.e('Error searching students: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error searching students: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchStatistics(
      FetchStudentStatistics event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        final stats = await _repository.getStatistics();
        emit(state.copyWith(state: state.success, statistics: stats));
      },
      dioError: (e) {
        Log.e('Error fetching statistics: ${e.message}');
      },
      error: (e) {
        Log.e('Error fetching statistics: $e');
      },
    );
  }

  FVoid _onFetchByClass(
      FetchStudentsByClass event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final students = await _repository.getStudentsByClass(event.classId);
        emit(state.copyWith(state: state.success, students: students));
      },
      dioError: (e) {
        Log.e('Error fetching students by class: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching students by class: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
