import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/presentation/my_app/presentation/manager/bloc/app_config_bloc/app_config_bloc.dart';
import 'package:student_management/presentation/views/dashboard/presentation/manager/profile_management_bloc/profile_management_bloc.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/super_admin/bloc/dashboard_bloc/super_admin_bloc.dart';
import 'package:student_management/presentation/views/login/presentation/manager/login_bloc/login_bloc.dart';
import 'package:student_management/presentation/views/splash/presentation/manager/splash_bloc/splash_bloc.dart';

class BlocProviders {
  static List<SingleChildWidget> blocProviderForMyApp = [
    Provider<FirebaseAnalytics>(
      create: (_) => InjectorService.service.inject<FirebaseAnalytics>(),
    ),
    BlocProvider<SplashBloc>(
      create: (BuildContext context) =>
          InjectorService.service.inject<SplashBloc>(),
    ),
    BlocProvider<LoginBloc>(
      create: (BuildContext context) =>
          InjectorService.service.inject<LoginBloc>(),
    ),
    BlocProvider<ProfileManageBloc>(
      create: (BuildContext context) =>
          InjectorService.service.inject<ProfileManageBloc>(),
    ),
    BlocProvider<AppConfigBloc>(
      create: (BuildContext context) =>
          InjectorService.service.inject<AppConfigBloc>(),
    ),
    BlocProvider<SuperAdminDashboardBloc>(
      create: (BuildContext context) =>
          InjectorService.service.inject<SuperAdminDashboardBloc>(),
    ),
  ];
}
