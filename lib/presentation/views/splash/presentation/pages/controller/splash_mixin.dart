part of 'splash_controller.dart';

mixin _SplashMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getToken();
    });
  }

  Future _getToken() async {
    try {
      var token = await NotificationService.getFcmToken();
      Log.d("FCM-Token is $token");
    } catch (e) {
      Log.e("Error getting the fcm token $e");
    }
    if (mounted) context.read<AppConfigBloc>().add(InitAppConfig());
  }

  void _splashListener(BuildContext context, SplashState state) {
    Log.d("Splash state is $state");
    if (state.isSuccess) {
      switch (state.routeOnPage) {
        case RouteOnPage.home:
          _navigateToHome();
          break;
        case RouteOnPage.login:
          _navigateToLogin();
          break;
        case RouteOnPage.splash:
          // Do nothing, stay on splash
          break;
        case RouteOnPage.intro:
          _navigateToIntro();
      }
    } else if (state.isFailed) {
      Log.e("Error in the splash: ${state.error}");
      // On error, default to login screen
      _navigateToLogin();
    }
  }

  void _appConfigListener(BuildContext context, AppConfigState state) {
    Log.d("Splash state is $state");
    if (state.isSuccess) {
      context.read<SplashBloc>().add(FetchDeviceStatusEvent());
    } else if (state.isFailed) {
      Log.e("Error in splash: ${state.error}");
      toast("Hiccup Detected");
      context.error(error: state.error);
    }
  }

  void _navigateToHome() {
    // Clear the entire navigation stack and go to home
    context.goNamed(RoutesName.home);
  }

  void _navigateToLogin() {
    // Clear the entire navigation stack and go to login
    context.goNamed(RoutesName.loginScreen);
  }

  void _navigateToIntro() {
    // Clear the entire navigation stack and go to intro
    context.goNamed(RoutesName.introScreen);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
