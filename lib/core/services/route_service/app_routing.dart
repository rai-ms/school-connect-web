import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/base/base_service/base_service.dart'
    show BaseService;
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/presentation/views/dashboard/presentation/pages/controller/add_school_super_admin_controller.dart';
import 'package:student_management/presentation/views/dashboard/presentation/pages/controller/dashboard_controller.dart'
    show DashboardController;
import 'package:student_management/presentation/views/dashboard/presentation/widgets/super_admin/bloc/add_school_bloc/add_school_bloc.dart';
import 'package:student_management/presentation/views/intro/presentation/pages/controller/intro_controller.dart';
import 'package:student_management/presentation/views/login/presentation/pages/controller/login_controller.dart'
    show LoginController;
import 'package:student_management/presentation/views/safety/counseling_referral_screen.dart';
import 'package:student_management/presentation/views/safety/emergency_alerts_screen.dart';
import 'package:student_management/presentation/views/safety/incident_report_screen.dart';
import 'package:student_management/presentation/views/splash/presentation/pages/controller/splash_controller.dart'
    show SplashController;

import '../../base/logger/app_logger_impl.dart';
import 'route_names.dart';

@protected
@immutable
class RouteService extends BaseService<void, void> {
  static final RouteService routeService = RouteService();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'mainNavigation');

  @override
  void init({void param}) {
    Log.d("RouteService Initialized");
  }

  final GoRouter goRouter = GoRouter(
    initialLocation: RoutesName.splashScreen,
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    observers: [BotToastNavigatorObserver()],
    redirect: (context, state) {
      Log.d(state.uri.path);
      return null;
    },
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text("Link Broken", style: AppStyles.medium.medium.red),
        ),
      );
    },
    routes: <RouteBase>[
      // Splash Screen
      GoRoute(
        path: RoutesName.splashScreen,
        name: RoutesName.splashScreen,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashController()),
      ),

      // Auth Screens
      GoRoute(
        path: RoutesName.loginScreen,
        name: RoutesName.loginScreen,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginController()),
      ),
      // Main App Screens
      GoRoute(
        path: RoutesName.home,
        name: RoutesName.home,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: DashboardController()),
      ),

      GoRoute(
        path: RoutesName.introScreen,
        name: RoutesName.introScreen,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: IntroController()),
      ),

      // Safety & Compliance Routes
      GoRoute(
        path: RoutesName.incidentReport,
        name: RoutesName.incidentReport,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: IncidentReportScreen()),
      ),

      GoRoute(
        path: RoutesName.counselingReferral,
        name: RoutesName.counselingReferral,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CounselingReferralScreen()),
      ),

      GoRoute(
        path: RoutesName.emergencyAlerts,
        name: RoutesName.emergencyAlerts,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: EmergencyAlertsScreen()),
      ),

      GoRoute(
        path: RoutesName.safetyLog,
        name: RoutesName.safetyLog,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Scaffold(
            body: Center(
              child: Text(
                'Safety Log - Coming Soon',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.addSchool,
        name: RoutesName.addSchool,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<AddSchoolBloc>(),
            child: AddSchoolSuperAdminController(),
          ),
        ),
      ),
    ],
  );
}
