import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:student_management/core/base/bloc_base/app_bloc_observer.dart'
    show AppBlocObserver;
import 'package:student_management/core/services/crashlytics_service/crashlytics_service.dart';
import 'package:student_management/core/services/deep_link_service/deep_link_service.dart';
import 'package:student_management/core/services/di/injector.dart'
    show InjectorService;
import 'package:student_management/core/services/internet_service/internet_service.dart'
    show InternetService;
import 'package:student_management/core/services/my_app_listener/my_app_listener.dart'
    show MyAppListener;
import 'package:student_management/core/services/notification/notification_service.dart';
import 'package:student_management/core/services/route_service/app_routing.dart'
    show RouteService;
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;
import 'package:student_management/core/utils/orientation_extension.dart'
    show OrientationExtension;
import 'package:student_management/core/utils/size_utils.dart'
    show SizeUtils, figmaDesignHeight, figmaDesignWidth;
import 'package:student_management/flavors.dart';
import 'package:student_management/presentation/my_app/presentation/init/my_app.dart'
    show MyApp;

import 'core/base/logger/app_logger_impl.dart';
import 'core/utils/app_providers.dart';

/// Main entry point of the application
/// Use: flutter run --flavor dev
/// Or:  flutter run --flavor prod
void main() {
  runZonedGuarded<Future<void>>(
    () async {
      await appInit();
      runApp(
        MultiBlocProvider(
          providers: BlocProviders.blocProviderForMyApp,
          child: const MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      Log.e('Uncaught error in app', error: error, stackTrace: stackTrace);
    },
  );
}

FVoid appInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) OrientationExtension.lockVertical();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Configure dependency injection
  await InjectorService.service.init();
  await GetIt.instance.allReady();

  final injector = GetIt.instance;

  // Initialize route service
  RouteService.routeService.init();

  // Initialize deep link service
  DeepLinkService? deepLinkService;
  try {
    deepLinkService = injector.get<DeepLinkService>();
    await deepLinkService.init();
  } catch (e) {
    Log.w('Deep link service initialization failed: $e');
  }

  // Initialize notification service
  try {
    final notificationService = injector.get<NotificationService>();
    await notificationService.init();
  } catch (e) {
    Log.w('Notification service initialization failed: $e');
  }

  // Initialize other services
  InternetService.service.init();
  await CrashlyticsService.service.init();
  MyAppListener.service.init();

  // Set BLoC observer
  Bloc.observer = AppBlocObserver();

  // Set screen size
  SizeUtils.setScreenSize(
    const BoxConstraints(
      maxHeight: figmaDesignHeight,
      maxWidth: figmaDesignWidth,
    ),
    Orientation.portrait,
  );

  // Mark navigator as ready after a short delay
  Future.delayed(const Duration(milliseconds: 500), () {
    deepLinkService?.markNavigatorReady();
    Log.d('Navigator marked as ready');
  });

  Log.d(
    "${F.name.toUpperCase()}: All Services Initialized - Base URL: ${F.baseUrl}",
  );
}
