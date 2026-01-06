part of 'login_controller.dart';

mixin _LoginControllerMixin<T extends StatefulWidget> on State<T> {
  late final ValidatedController _userNameController;
  late final ValidatedController _passwordController;

  @override
  void initState() {
    _userNameController = ValidatedController(
      validation: Validation.string.alwaysProper(),
    );
    _passwordController = ValidatedController(
      validation: Validation.string.password(),
    );
    super.initState();
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    var authStorage = InjectorService.service.inject<AuthStorageRepository>();
    var userId = authStorage.userIdRemember();
    var pass = authStorage.userPasswordRemember();

    if (userId?.trim().isNotEmpty ?? false) {
      Log.d("Found user id is $userId");
      _userNameController.text = userId ?? "";
    } else {
      _userNameController.text = "superadmin@system.com";
    }

    if (pass?.trim().isNotEmpty ?? false) {
      _passwordController.text = pass ?? "";
    } else {
      _passwordController.text = "Admin@123";
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginListner(BuildContext ctx, LoginState loginState) {
    switch (loginState.state) {
      case BlocState.none:
        break;
      case BlocState.loading:
        break;
      case BlocState.noInternet:
        break;
      case BlocState.success:
        _goHome();
        break;
      case BlocState.failed:
        context.snackBar(
          message: loginState.error ?? "Login failed",
          dismissDirection: DismissDirection.up,
        );
        break;
    }
  }

  void _goHome() {
    context.goNamed(RoutesName.home);
  }

  String get _backGroundImage {
    switch (InjectorService.service
        .inject<ThemeService>()
        .themeListener
        .value) {
      case AppTheme.system:
        return AppAssets.animatedBackground;
      case AppTheme.dark:
        return AppAssets.animatedBackground;
      // return AppAssets.bg3;
      case AppTheme.light:
        return AppAssets.animatedBackground;
    }
  }
}
