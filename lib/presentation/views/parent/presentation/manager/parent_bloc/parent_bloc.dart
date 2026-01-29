import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/parent_model.dart';
import '../../../data/repositories/parent_repository.dart';

part 'parent_event.dart';
part 'parent_state.dart';

@injectable
class ParentBloc extends Bloc<ParentEvent, ParentState> {
  final ParentRepository _repository;
  final StateRequestHandler _handler;

  ParentBloc(this._repository, this._handler) : super(const ParentState()) {
    on<FetchParents>(_onFetchParents);
    on<FetchParentById>(_onFetchById);
    on<CreateParent>(_onCreateParent);
    on<UpdateParent>(_onUpdateParent);
    on<DeleteParent>(_onDeleteParent);
    on<FetchParentsByStudent>(_onFetchByStudent);
    on<LinkParentToStudent>(_onLinkToStudent);
    on<SearchParents>(_onSearchParents);
  }

  FVoid _onFetchParents(
      FetchParents event, Emitter<ParentState> emit) async {
    await _handler(
      apiCall: () async {
        if (event.loadMore) {
          emit(state.copyWith(isLoadingMore: true));
        } else {
          emit(state.copyWith(state: state.loading, event: event));
        }
        final result = await _repository.getAllParents(
          page: event.page,
          size: event.size,
          parentType: event.parentType,
          search: event.search,
        );
        final updatedParents = event.loadMore
            ? [...state.parents, ...result.content]
            : result.content;
        emit(state.copyWith(
          state: state.success,
          parents: updatedParents,
          currentPage: result.number,
          totalPages: result.totalPages,
          hasMore: !result.last,
          isLoadingMore: false,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching parents: ${e.message}');
        emit(state.copyWith(
          state: state.failed,
          error: e.message,
          isLoadingMore: false,
        ));
      },
      error: (e) {
        Log.e('Error fetching parents: $e');
        emit(state.copyWith(
          state: state.failed,
          error: e.toString(),
          isLoadingMore: false,
        ));
      },
    );
  }

  FVoid _onFetchById(
      FetchParentById event, Emitter<ParentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final parent = await _repository.getParentById(event.parentId);
        emit(state.copyWith(
            state: state.success, selectedParent: parent));
      },
      dioError: (e) {
        Log.e('Error fetching parent: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching parent: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateParent(
      CreateParent event, Emitter<ParentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createParent(event.request);
        final result = await _repository.getAllParents();
        emit(state.copyWith(
            state: state.success,
            parents: result.content,
            currentPage: result.number,
            totalPages: result.totalPages,
            hasMore: !result.last,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error creating parent: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating parent: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onUpdateParent(
      UpdateParent event, Emitter<ParentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final updated =
            await _repository.updateParent(event.parentId, event.updates);
        emit(state.copyWith(
            state: state.success,
            selectedParent: updated,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error updating parent: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error updating parent: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onDeleteParent(
      DeleteParent event, Emitter<ParentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.deleteParent(event.parentId);
        final result = await _repository.getAllParents();
        emit(state.copyWith(
            state: state.success,
            parents: result.content,
            currentPage: result.number,
            totalPages: result.totalPages,
            hasMore: !result.last,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error deleting parent: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error deleting parent: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchByStudent(
      FetchParentsByStudent event, Emitter<ParentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final parents = await _repository.getParentsByStudent(event.studentId);
        emit(state.copyWith(
          state: state.success,
          parents: parents,
          currentPage: 0,
          totalPages: 1,
          hasMore: false,
          isLoadingMore: false,
        ));
      },
      dioError: (e) {
        Log.e('Error fetching parents by student: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching parents by student: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onLinkToStudent(
      LinkParentToStudent event, Emitter<ParentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final updated = await _repository.linkParentToStudent(
            event.parentId, event.studentId);
        emit(state.copyWith(
            state: state.success,
            selectedParent: updated,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error linking parent to student: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error linking parent to student: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onSearchParents(
      SearchParents event, Emitter<ParentState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final parents = await _repository.searchParents(event.query);
        emit(state.copyWith(
          state: state.success,
          parents: parents,
          currentPage: 0,
          totalPages: 1,
          hasMore: false,
          isLoadingMore: false,
        ));
      },
      dioError: (e) {
        Log.e('Error searching parents: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error searching parents: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
