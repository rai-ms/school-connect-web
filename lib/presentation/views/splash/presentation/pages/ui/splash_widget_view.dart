part of '../controller/splash_controller.dart';

class _SplashWidgetView
    extends WidgetView<_SplashWidgetView, _SplashControllerState> {
  const _SplashWidgetView(super.ctr);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppConfigBloc, AppConfigState>(
      listener: ctr._appConfigListener,
      child: BlocListener<SplashBloc, SplashState>(
        listener: ctr._splashListener,
        child: Container(
          color: const Color(0xFF000201),
          child: Center(
            child: Image.asset(AppAssets.logo, width: 100, height: 100),
          ),
        ),
      ),
    );
  }
}
