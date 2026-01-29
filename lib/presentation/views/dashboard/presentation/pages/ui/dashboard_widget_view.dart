part of '../controller/dashboard_controller.dart';

class _DashBoardWidgetView extends WidgetView<_DashBoardWidgetView, _DashboardControllerState> {
  const _DashBoardWidgetView(super.controllerState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileManageBloc, ProfileManageState>(
        listener: ctr._profileManageListner,
        buildWhen: (pr, cr) => pr.isLoading || cr.isLoading,
        builder: (context, ProfileManageState profileManageState) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.darkRedColor,
              image: DecorationImage(
                image: AssetImage(AppAssets.bg3),
                fit: BoxFit.cover,
              ),
            ),
            child: AppPullToRefresh(
              onRefresh: () async {
                context.read<ProfileManageBloc>().add(LoadUserProfile());
              },
              child: RotatingDotsLoader(
                isLoading: profileManageState.isLoading || (profileManageState.role?.value.isEmpty ?? true),
                child: BlocBuilder<ProfileManageBloc, ProfileManageState>(
                  builder: (context, ProfileManageState profileManageState) {
                    Log.d("This getting called ${profileManageState.role}");
                    switch (profileManageState.role) {
                      case UserRole.superAdmin:
                        return SuperAdminDashboard(profileState: profileManageState,);
                      case UserRole.schoolAdmin:
                        return SchoolAdminDashboard(profileState: profileManageState);
                      case UserRole.student:
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider<TimetableBloc>(
                              create: (_) => InjectorService.service.inject<TimetableBloc>(),
                            ),
                            BlocProvider<AttendanceBloc>(
                              create: (_) => InjectorService.service.inject<AttendanceBloc>(),
                            ),
                            BlocProvider<NotificationBloc>(
                              create: (_) => InjectorService.service.inject<NotificationBloc>(),
                            ),
                            BlocProvider<StudentBloc>(
                              create: (_) => InjectorService.service.inject<StudentBloc>(),
                            ),
                          ],
                          child: StudentDashboard(profileState: profileManageState),
                        );
                      case UserRole.parent:
                        return ParentDashboard(profileState: profileManageState);
                      case UserRole.teacher:
                        return TeacherDashboard(profileState: profileManageState);
                      default:
                        Log.d("This is getting called in default");
                        return const Center(
                            child: CircularProgressIndicator()
                        );
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
