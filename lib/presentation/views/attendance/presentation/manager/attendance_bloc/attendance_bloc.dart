import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/attendance_model.dart';
import '../../../data/repositories/attendance_repository.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository _repository;
  final StateRequestHandler _handler;

  AttendanceBloc(this._repository, this._handler)
      : super(const AttendanceState()) {
    on<MarkBulkAttendance>(_onMarkBulk);
    on<FetchClassAttendance>(_onFetchClassAttendance);
    on<FetchStudentAttendance>(_onFetchStudentAttendance);
    on<FetchStudentAttendancePercentage>(_onFetchPercentage);
    on<FetchAttendanceByDate>(_onFetchByDate);
  }

  FVoid _onMarkBulk(
      MarkBulkAttendance event, Emitter<AttendanceState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.markBulkAttendance(event.request);
        emit(state.copyWith(
            state: state.success, attendanceMarked: true));
      },
      dioError: (e) {
        Log.e('Error marking attendance: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error marking attendance: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchClassAttendance(
      FetchClassAttendance event, Emitter<AttendanceState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final records =
            await _repository.getAttendanceByClass(event.classId, event.date);
        emit(state.copyWith(state: state.success, records: records));
      },
      dioError: (e) {
        Log.e('Error fetching class attendance: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching class attendance: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchStudentAttendance(
      FetchStudentAttendance event, Emitter<AttendanceState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final records =
            await _repository.getStudentAttendance(event.studentId);
        emit(state.copyWith(state: state.success, records: records));
      },
      dioError: (e) {
        Log.e('Error fetching student attendance: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching student attendance: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchPercentage(
      FetchStudentAttendancePercentage event,
      Emitter<AttendanceState> emit) async {
    await _handler(
      apiCall: () async {
        final pct = await _repository
            .getStudentAttendancePercentage(event.studentId);
        emit(state.copyWith(state: state.success, percentage: pct));
      },
      dioError: (e) {
        Log.e('Error fetching attendance percentage: ${e.message}');
      },
      error: (e) {
        Log.e('Error fetching attendance percentage: $e');
      },
    );
  }

  FVoid _onFetchByDate(
      FetchAttendanceByDate event, Emitter<AttendanceState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final records = await _repository.getAttendanceByDate(event.date);
        emit(state.copyWith(state: state.success, records: records));
      },
      dioError: (e) {
        Log.e('Error fetching attendance by date: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching attendance by date: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
