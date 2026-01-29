import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/class_model.dart';
import '../../../data/repositories/class_repository.dart';

part 'class_event.dart';
part 'class_state.dart';

@injectable
class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassRepository _repository;
  final StateRequestHandler _handler;

  ClassBloc(this._repository, this._handler) : super(const ClassState()) {
    on<FetchAllClasses>(_onFetchAll);
    on<FetchClassById>(_onFetchById);
    on<CreateSchoolClass>(_onCreateClass);
    on<FetchSectionsByClass>(_onFetchSections);
    on<CreateSection>(_onCreateSection);
  }

  FVoid _onFetchAll(FetchAllClasses event, Emitter<ClassState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final classes = await _repository.getAllClasses();
        emit(state.copyWith(state: state.success, classes: classes));
      },
      dioError: (e) {
        Log.e('Error fetching classes: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching classes: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchById(
      FetchClassById event, Emitter<ClassState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final cls = await _repository.getClassById(event.classId);
        emit(state.copyWith(
            state: state.success, selectedClass: cls, sections: cls.sections));
      },
      dioError: (e) {
        Log.e('Error fetching class: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching class: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateClass(
      CreateSchoolClass event, Emitter<ClassState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createClass(event.request);
        final classes = await _repository.getAllClasses();
        emit(state.copyWith(
            state: state.success,
            classes: classes,
            actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error creating class: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating class: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchSections(
      FetchSectionsByClass event, Emitter<ClassState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final sections = await _repository.getSectionsByClass(event.classId);
        emit(state.copyWith(state: state.success, sections: sections));
      },
      dioError: (e) {
        Log.e('Error fetching sections: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching sections: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateSection(
      CreateSection event, Emitter<ClassState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createSection(event.request);
        emit(state.copyWith(
            state: state.success, actionCompleted: true));
      },
      dioError: (e) {
        Log.e('Error creating section: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating section: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
