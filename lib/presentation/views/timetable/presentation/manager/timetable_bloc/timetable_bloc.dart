import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/period_model.dart';
import '../../../data/models/timetable_entry_model.dart';
import '../../../data/repositories/timetable_repository.dart';

part 'timetable_event.dart';
part 'timetable_state.dart';

@injectable
class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  final TimetableRepository _repository;
  final StateRequestHandler _handler;

  TimetableBloc(this._repository, this._handler) : super(const TimetableState()) {
    on<FetchPeriods>(_onFetchPeriods);
    on<FetchClassTimetable>(_onFetchClassTimetable);
    on<FetchTeacherTimetable>(_onFetchTeacherTimetable);
    on<FetchClassWeeklyTimetable>(_onFetchClassWeekly);
    on<FetchTeacherWeeklyTimetable>(_onFetchTeacherWeekly);
    on<CreatePeriod>(_onCreatePeriod);
    on<CreateTimetableEntry>(_onCreateEntry);
    on<UpdateTimetableEntry>(_onUpdateEntry);
    on<DeleteTimetableEntry>(_onDeleteEntry);
  }

  FVoid _onFetchPeriods(FetchPeriods event, Emitter<TimetableState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final periods = await _repository.getActivePeriods();
        emit(state.copyWith(state: state.success, periods: periods));
      },
      dioError: (e) {
        Log.e('Error fetching periods: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching periods: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchClassTimetable(
      FetchClassTimetable event, Emitter<TimetableState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final entries = await _repository.getClassTimetable(event.classId);
        emit(state.copyWith(state: state.success, entries: entries));
      },
      dioError: (e) {
        Log.e('Error fetching class timetable: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching class timetable: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchTeacherTimetable(
      FetchTeacherTimetable event, Emitter<TimetableState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final entries = await _repository.getTeacherTimetable(event.teacherId);
        emit(state.copyWith(state: state.success, entries: entries));
      },
      dioError: (e) {
        Log.e('Error fetching teacher timetable: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching teacher timetable: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchClassWeekly(
      FetchClassWeeklyTimetable event, Emitter<TimetableState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final weekly = await _repository.getClassWeeklyTimetable(event.classId);
        emit(state.copyWith(state: state.success, weeklyTimetable: weekly));
      },
      dioError: (e) {
        Log.e('Error fetching weekly timetable: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching weekly timetable: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchTeacherWeekly(
      FetchTeacherWeeklyTimetable event, Emitter<TimetableState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final weekly =
            await _repository.getTeacherWeeklyTimetable(event.teacherId);
        emit(state.copyWith(state: state.success, weeklyTimetable: weekly));
      },
      dioError: (e) {
        Log.e('Error fetching teacher weekly timetable: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching teacher weekly timetable: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreatePeriod(CreatePeriod event, Emitter<TimetableState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createPeriod(event.request);
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error creating period: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating period: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onCreateEntry(
      CreateTimetableEntry event, Emitter<TimetableState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.createEntry(event.request);
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error creating timetable entry: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error creating timetable entry: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onUpdateEntry(
      UpdateTimetableEntry event, Emitter<TimetableState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.updateEntry(event.entryId, event.request);
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error updating timetable entry: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error updating timetable entry: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onDeleteEntry(
      DeleteTimetableEntry event, Emitter<TimetableState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.deleteEntry(event.entryId);
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error deleting timetable entry: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error deleting timetable entry: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
