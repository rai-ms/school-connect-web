import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_client/status_message.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';

import 'package:student_management/presentation/views/dashboard/data/models/res/school_admin/dashboard_stats_model.dart';
import 'package:student_management/presentation/views/dashboard/data/repositories/school_admin_dashboard_repository.dart';
import 'package:student_management/presentation/views/fee/data/models/fee_payment_model.dart';

part 'school_admin_dashboard_event.dart';
part 'school_admin_dashboard_state.dart';

@injectable
class SchoolAdminDashboardBloc
    extends Bloc<SchoolAdminDashboardEvent, SchoolAdminDashboardState> {
  final StateRequestHandler _handler;
  final SchoolAdminDashboardRepository _repository;

  SchoolAdminDashboardBloc(this._handler, this._repository)
      : super(const SchoolAdminDashboardState()) {
    on<FetchDashboardStats>(_onFetchDashboardStats);
    on<FetchFeeReport>(_onFetchFeeReport);
    on<FetchPendingLeaves>(_onFetchPendingLeaves);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onFetchDashboardStats(
    FetchDashboardStats event,
    Emitter<SchoolAdminDashboardState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(event: event, state: state.loading));
        final stats = await _repository.getTenantStatistics();
        emit(state.copyWith(
          state: state.success,
          tenantStats: stats,
        ));
      },
      dioError: (DioException error) {
        Log.d("Error fetching dashboard stats: ${error.response}");
        emit(state.copyWith(
          state: state.failed,
          error: error.response?.statusCode.message,
        ));
      },
      error: (error) {
        Log.d("Error fetching dashboard stats: $error");
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }

  Future<void> _onFetchFeeReport(
    FetchFeeReport event,
    Emitter<SchoolAdminDashboardState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(event: event, state: state.loading));
        final report = await _repository.getFeeCollectionReport();
        emit(state.copyWith(
          state: state.success,
          feeReport: report,
        ));
      },
      dioError: (DioException error) {
        Log.d("Error fetching fee report: ${error.response}");
        emit(state.copyWith(
          state: state.failed,
          error: error.response?.statusCode.message,
        ));
      },
      error: (error) {
        Log.d("Error fetching fee report: $error");
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }

  Future<void> _onFetchPendingLeaves(
    FetchPendingLeaves event,
    Emitter<SchoolAdminDashboardState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(event: event, state: state.loading));
        final count = await _repository.getPendingLeaveCount();
        emit(state.copyWith(
          state: state.success,
          pendingLeaveCount: count,
        ));
      },
      dioError: (DioException error) {
        Log.d("Error fetching pending leaves: ${error.response}");
        emit(state.copyWith(
          state: state.failed,
          error: error.response?.statusCode.message,
        ));
      },
      error: (error) {
        Log.d("Error fetching pending leaves: $error");
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<SchoolAdminDashboardState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(event: event, state: state.loading));

        final results = await Future.wait([
          _repository.getTenantStatistics(),
          _repository.getFeeCollectionReport(),
          _repository.getPendingLeaveCount(),
        ]);

        emit(state.copyWith(
          state: state.success,
          tenantStats: results[0] as TenantStatistics,
          feeReport: results[1] as CollectionReport,
          pendingLeaveCount: results[2] as int,
        ));
      },
      dioError: (DioException error) {
        Log.d("Error refreshing dashboard: ${error.response}");
        emit(state.copyWith(
          state: state.failed,
          error: error.response?.statusCode.message,
        ));
      },
      error: (error) {
        Log.d("Error refreshing dashboard: $error");
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }
}
