import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/subject_model.dart';
import '../../../data/repositories/subject_repository.dart';

part 'subject_event.dart';
part 'subject_state.dart';

@injectable
class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectRepository _repository;
  final StateRequestHandler _handler;

  SubjectBloc(this._repository, this._handler)
      : super(const SubjectState()) {
    on<FetchSubjects>(_onFetchSubjects);
    on<FetchSubjectById>(_onFetchById);
    on<CreateSubjectEvent>(_onCreateSubject);
    on<UpdateSubjectEvent>(_onUpdateSubject);
    on<DeleteSubjectEvent>(_onDeleteSubject);
    on<SearchSubjects>(_onSearchSubjects);
    on<FetchSubjectsByClass>(_onFetchByClass);
    on<FetchSubjectsByTeacher>(_onFetchByTeacher);
  }

  FVoid _onFetchSubjects(
      FetchSubjects event, Emitter<SubjectState> emit) async {
    await _handler(
      apiCall: () async {
        if (event.loadMore) {
          emit(state.copyWith(isLoadingMore: true));
        } else {
          emit(state.copyWith(state: state.loading, event: event));
        }
        final result = await _repository.getAllSubjects(
          page: event.page,
          size: event.size,
          search: event.search,
        );
        final updatedSubjects = event.loadMore
            ? [...state.subjects, ...result.content]
            : result.content;
        emit(state.copyWith(
          state: state.success,
          subjects: updatedSubjects,
          currentPage: result.number,
          totalPages: result.totalPages,
          hasMore: !result.last,
          isLoadingMore: false,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching subjects: ${e.message}');
        emit(state.copyWith(
          state: state.failed,
          error: e.message,
          isLoadingMore: false,
        ));
      },
      error: (e) {
        Log.e('Error fetching subjects: $e');
        emit(state.copyWith(
          state: state.failed,
          error: e.toString(),
          isLoadingMore: false,
        ));
      },
    );
  }

  FVoid _onFetchById(
      FetchSubjectById event, Emitter<SubjectState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final subject = await _repository.getSubjectById(event.subjectId);
        emit(state.copyWith(
            state: state.success, selectedSubject: subject));
      },
      dioError: (e) {
        Log.e('Error fetching subject: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching subject: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateSubject(
      CreateSubjectEvent event, Emitter<SubjectState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createSubject(event.request);
        final result = await _repository.getAllSubjects();
        emit(state.copyWith(
            state: state.success,
            subjects: result.content,
            currentPage: result.number,
            totalPages: result.totalPages,
            hasMore: !result.last,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error creating subject: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating subject: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onUpdateSubject(
      UpdateSubjectEvent event, Emitter<SubjectState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final updated =
            await _repository.updateSubject(event.subjectId, event.request);
        emit(state.copyWith(
            state: state.success,
            selectedSubject: updated,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error updating subject: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error updating subject: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onDeleteSubject(
      DeleteSubjectEvent event, Emitter<SubjectState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.deleteSubject(event.subjectId);
        final result = await _repository.getAllSubjects();
        emit(state.copyWith(
            state: state.success,
            subjects: result.content,
            currentPage: result.number,
            totalPages: result.totalPages,
            hasMore: !result.last,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error deleting subject: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error deleting subject: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onSearchSubjects(
      SearchSubjects event, Emitter<SubjectState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final result = await _repository.searchSubjects(event.query);
        emit(state.copyWith(
          state: state.success,
          subjects: result.content,
          currentPage: result.number,
          totalPages: result.totalPages,
          hasMore: !result.last,
          isLoadingMore: false,
        ));
      },
      dioError: (e) {
        Log.e('Error searching subjects: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error searching subjects: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchByClass(
      FetchSubjectsByClass event, Emitter<SubjectState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final subjects = await _repository.getSubjectsByClass(event.classId);
        emit(state.copyWith(
          state: state.success,
          subjects: subjects,
          currentPage: 0,
          totalPages: 1,
          hasMore: false,
          isLoadingMore: false,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching subjects by class: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching subjects by class: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchByTeacher(
      FetchSubjectsByTeacher event, Emitter<SubjectState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final subjects =
            await _repository.getSubjectsByTeacher(event.teacherId);
        emit(state.copyWith(
          state: state.success,
          subjects: subjects,
          currentPage: 0,
          totalPages: 1,
          hasMore: false,
          isLoadingMore: false,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching subjects by teacher: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching subjects by teacher: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
