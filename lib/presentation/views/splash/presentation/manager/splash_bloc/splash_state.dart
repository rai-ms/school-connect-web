part of 'splash_bloc.dart';

class SplashState extends BlocEventState<bool> {
  final String? updateUrl;
  final RouteOnPage routeOnPage;
  const SplashState({
    this.updateUrl,
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.routeOnPage = RouteOnPage.splash,
  });

  @override
  SplashState copyWith({
    bool? data,
    String? error,
    String? updateUrl,
    BlocEvent? event,
    int? statusCode,
    BlocState? state,
    RouteOnPage? routeOnPage,
  }) {
    return SplashState(
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      state: state ?? this.state,
      updateUrl: updateUrl ?? this.updateUrl,
      routeOnPage: routeOnPage ?? this.routeOnPage,
    );
  }

  @override
  SplashState clear() => const SplashState();
}

enum RouteOnPage {
  home,
  login,
  splash,
  intro,
}
