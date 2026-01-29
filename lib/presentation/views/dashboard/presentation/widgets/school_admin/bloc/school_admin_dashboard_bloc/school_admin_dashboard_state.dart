part of 'school_admin_dashboard_bloc.dart';

class SchoolAdminDashboardState extends BlocEventState {
  final TenantStatistics? tenantStats;
  final CollectionReport? feeReport;
  final int pendingLeaveCount;

  const SchoolAdminDashboardState({
    super.data,
    super.error,
    super.event,
    super.state,
    super.statusCode,
    this.tenantStats,
    this.feeReport,
    this.pendingLeaveCount = 0,
  });

  @override
  SchoolAdminDashboardState clear() => const SchoolAdminDashboardState();

  @override
  SchoolAdminDashboardState copyWith({
    BlocEvent? event,
    String? error,
    int? statusCode,
    Object? data,
    BlocState? state,
    TenantStatistics? tenantStats,
    CollectionReport? feeReport,
    int? pendingLeaveCount,
  }) {
    return SchoolAdminDashboardState(
      state: state ?? this.state,
      event: event ?? this.event,
      data: data ?? this.data,
      error: error ?? this.error,
      statusCode: statusCode ?? this.statusCode,
      tenantStats: tenantStats ?? this.tenantStats,
      feeReport: feeReport ?? this.feeReport,
      pendingLeaveCount: pendingLeaveCount ?? this.pendingLeaveCount,
    );
  }
}
