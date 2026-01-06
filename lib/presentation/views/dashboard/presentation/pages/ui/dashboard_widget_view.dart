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
                        return SchoolAdminDashboard();
                      case UserRole.student:
                        return StudentDashboard();
                      case UserRole.parent:
                        return ParentDashboard();
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
