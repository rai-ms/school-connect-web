import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
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
    on<ExportStudents>(_onExportStudents);
    on<ImportStudents>(_onImportStudents);
    on<DownloadImportTemplate>(_onDownloadTemplate);
  }

  FVoid _onFetchStudents(
      FetchStudents event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        if (event.loadMore) {
          emit(state.copyWith(isLoadingMore: true));
        } else {
          emit(state.copyWith(state: state.loading, event: event));
        }
        final result = await _repository.getAllStudents(
          page: event.page,
          size: event.size,
          classId: event.classId,
          search: event.search,
        );
        final updatedStudents = event.loadMore
            ? [...state.students, ...result.content]
            : result.content;
        emit(state.copyWith(
          state: state.success,
          students: updatedStudents,
          currentPage: result.number,
          totalPages: result.totalPages,
          hasMore: !result.last,
          isLoadingMore: false,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching students: ${e.message}');
        emit(state.copyWith(
          state: state.failed,
          error: e.message,
          isLoadingMore: false,
        ));
      },
      error: (e) {
        Log.e('Error fetching students: $e');
        emit(state.copyWith(
          state: state.failed,
          error: e.toString(),
          isLoadingMore: false,
        ));
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
        final result = await _repository.getAllStudents();
        emit(state.copyWith(
            state: state.success,
            students: result.content,
            currentPage: result.number,
            totalPages: result.totalPages,
            hasMore: !result.last,
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
        final result = await _repository.getAllStudents();
        emit(state.copyWith(
            state: state.success,
            students: result.content,
            currentPage: result.number,
            totalPages: result.totalPages,
            hasMore: !result.last,
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
        emit(state.copyWith(
          state: state.success,
          students: students,
          currentPage: 0,
          totalPages: 1,
          hasMore: false,
          isLoadingMore: false,
        ));
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
        emit(state.copyWith(
          state: state.success,
          students: students,
          currentPage: 0,
          totalPages: 1,
          hasMore: false,
          isLoadingMore: false,
        ));
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

  FVoid _onExportStudents(
      ExportStudents event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final bytes = await _repository.exportStudents(
          classId: event.classId,
          sectionId: event.sectionId,
          status: event.status,
        );
        final dir = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = '${dir.path}/students_export_$timestamp.csv';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        emit(state.copyWith(
          state: state.success,
          exportedFilePath: filePath,
          actionCompleted: true,
        ));
      },
      dioError: (e) {
        Log.e('Error exporting students: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error exporting students: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onImportStudents(
      ImportStudents event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final result = await _repository.importStudents(
          event.filePath,
          classId: event.classId,
        );
        emit(state.copyWith(
          state: state.success,
          importResult: result,
          actionCompleted: true,
        ));
      },
      dioError: (e) {
        Log.e('Error importing students: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error importing students: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onDownloadTemplate(
      DownloadImportTemplate event, Emitter<StudentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final bytes = await _repository.downloadImportTemplate();
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/student_import_template.csv';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        emit(state.copyWith(
          state: state.success,
          exportedFilePath: filePath,
          actionCompleted: true,
        ));
      },
      dioError: (e) {
        Log.e('Error downloading template: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error downloading template: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
