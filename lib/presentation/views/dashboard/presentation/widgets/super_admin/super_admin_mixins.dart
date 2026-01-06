part of 'super_admin_dashboard.dart';

mixin _SuperAdminMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    context.read<SuperAdminDashboardBloc>().add(GetDashBoardData());
    super.initState();
  }

  void _profileListner(BuildContext ctx, ProfileManageState profileState) {
    switch (profileState.state) {
      case BlocState.none:
        break;
      case BlocState.loading:
        break;
      case BlocState.noInternet:
        break;
      case BlocState.success:
        toast("Logout Success");
        // context.goNamed(RoutesName.loginScreen);
        break;
      case BlocState.failed:
        toast(
          "Not able to logout ${profileState.error}",
          toastType: ToastType.error,
        );
        break;
    }
  }
}
