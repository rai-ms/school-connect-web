import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/teacher_model.dart';
import '../../../data/repositories/teacher_repository.dart';

part 'teacher_event.dart';
part 'teacher_state.dart';

@injectable
class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final TeacherRepository _repository;
  final StateRequestHandler _handler;

  TeacherBloc(this._repository, this._handler)
      : super(const TeacherState()) {
    on<FetchTeachers>(_onFetchTeachers);
    on<FetchTeacherById>(_onFetchById);
    on<CreateTeacher>(_onCreateTeacher);
    on<UpdateTeacher>(_onUpdateTeacher);
    on<DeleteTeacher>(_onDeleteTeacher);
  }

  FVoid _onFetchTeachers(
      FetchTeachers event, Emitter<TeacherState> emit) async {
    await _handler(
      apiCall: () async {
        if (event.loadMore) {
          emit(state.copyWith(isLoadingMore: true));
        } else {
          emit(state.copyWith(state: state.loading, event: event));
        }
        final result = await _repository.getAllTeachers(
          page: event.page,
          size: event.size,
        );
        final updatedTeachers = event.loadMore
            ? [...state.teachers, ...result.content]
            : result.content;
        emit(state.copyWith(
          state: state.success,
          teachers: updatedTeachers,
          currentPage: result.number,
          totalPages: result.totalPages,
          hasMore: !result.last,
          isLoadingMore: false,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching teachers: ${e.message}');
        emit(state.copyWith(
          state: state.failed,
          error: e.message,
          isLoadingMore: false,
        ));
      },
      error: (e) {
        Log.e('Error fetching teachers: $e');
        emit(state.copyWith(
          state: state.failed,
          error: e.toString(),
          isLoadingMore: false,
        ));
      },
    );
  }

  FVoid _onFetchById(
      FetchTeacherById event, Emitter<TeacherState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final teacher = await _repository.getTeacherById(event.id);
        emit(state.copyWith(
            state: state.success, selectedTeacher: teacher));
      },
      dioError: (e) {
        Log.e('Error fetching teacher: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching teacher: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateTeacher(
      CreateTeacher event, Emitter<TeacherState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createTeacher(event.request);
        final result = await _repository.getAllTeachers();
        emit(state.copyWith(
            state: state.success,
            teachers: result.content,
            currentPage: result.number,
            totalPages: result.totalPages,
            hasMore: !result.last,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error creating teacher: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating teacher: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onUpdateTeacher(
      UpdateTeacher event, Emitter<TeacherState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final updated =
            await _repository.updateTeacher(event.id, event.updates);
        emit(state.copyWith(
            state: state.success,
            selectedTeacher: updated,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error updating teacher: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error updating teacher: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onDeleteTeacher(
      DeleteTeacher event, Emitter<TeacherState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.deleteTeacher(event.id);
        final result = await _repository.getAllTeachers();
        emit(state.copyWith(
            state: state.success,
            teachers: result.content,
            currentPage: result.number,
            totalPages: result.totalPages,
            hasMore: !result.last,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error deleting teacher: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error deleting teacher: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
