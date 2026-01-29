part of 'school_admin_dashboard_bloc.dart';

class SchoolAdminDashboardEvent extends BlocEvent {
  const SchoolAdminDashboardEvent();
}

class FetchDashboardStats extends SchoolAdminDashboardEvent {}

class FetchFeeReport extends SchoolAdminDashboardEvent {}

class FetchPendingLeaves extends SchoolAdminDashboardEvent {}

class RefreshDashboard extends SchoolAdminDashboardEvent {}
