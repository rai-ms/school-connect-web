part of 'super_admin_bloc.dart';

class SuperAdminDashboardState extends BlocEventState {
  final GetAllUsersResponse? allUsersResponse;
  final List<SuperAdminAllUsers>? totalTeachers;
  final List<SuperAdminAllUsers>? totalStudents;
  final List<SuperAdminAllUsers>? totalOthers;

  const SuperAdminDashboardState({
    super.data,
    super.error,
    super.event,
    super.state,
    super.statusCode,
    this.allUsersResponse,
    this.totalTeachers,
    this.totalStudents,
    this.totalOthers,
  });

  @override
  SuperAdminDashboardState clear() => SuperAdminDashboardState();

  @override
  SuperAdminDashboardState copyWith({
    BlocEvent? event,
    String? error,
    int? statusCode,
    Object? data,
    BlocState? state,
    GetAllUsersResponse? allUsersResponse,
    List<SuperAdminAllUsers>? totalTeachers,
    List<SuperAdminAllUsers>? totalStudents,
    List<SuperAdminAllUsers>? totalOthers,
  }) {
    return SuperAdminDashboardState(
      state: state ?? this.state,
      event: event ?? this.event,
      data: data ?? this.data,
      error: error ?? this.error,
      statusCode: statusCode ?? this.statusCode,
      allUsersResponse: allUsersResponse ?? this.allUsersResponse,
      totalOthers: totalOthers ?? this.totalOthers,
      totalStudents: totalStudents ?? this.totalStudents,
      totalTeachers: totalTeachers ?? this.totalTeachers,
    );
  }
}
