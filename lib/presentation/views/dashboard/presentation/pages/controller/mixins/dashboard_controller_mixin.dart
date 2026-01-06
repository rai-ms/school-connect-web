
part of '../dashboard_controller.dart';

mixin _DashBoardControllerMixin<T extends StatefulWidget> on State<T>{

  late final ProfileManageBloc _profileManageBloc;

  @override
  void initState() {
    _profileManageBloc = context.read<ProfileManageBloc>();
    _profileManageBloc.add(LoadUserProfile());
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }


  void _profileManageListner(BuildContext ctx, ProfileManageState manageState){

    if(manageState.isTokenNotFound){
      _goToLogin();
      return;
    }

    switch(manageState.state){
      case BlocState.none:
        break;
      case BlocState.loading:
        break;
      case BlocState.noInternet:
        break;
      case BlocState.success:
        if(manageState.event is LogOutEvent){
          toast("Logout Success");
          context.goNamed(RoutesName.loginScreen);
        }
        break;
      case BlocState.failed:
        if(manageState.statusCode == HttpStatus.unauthorized){
          toast("Session Expired");
          context.goNamed(RoutesName.splashScreen);
        }
        break;
    }
  }

  void _goToLogin(){
    context.goNamed(RoutesName.loginScreen);
  }


}