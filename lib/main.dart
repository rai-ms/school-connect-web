import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/base/bloc_base/app_bloc_observer.dart'
    show AppBlocObserver;
import 'package:student_management/core/services/crashlytics_service/crashlytics_service.dart';
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
import 'package:student_management/presentation/my_app/presentation/init/my_app.dart'
    show MyApp;
import 'package:student_management/flavors.dart';

import 'core/base/logger/app_logger_impl.dart';
import 'core/utils/app_providers.dart';

// Main entry point of the application (legacy - defaults to dev)
// Use main_dev.dart or main_prod.dart for flavor-specific builds
void main() {
  // Default to dev flavor for backward compatibility
  F.appFlavor = Flavor.dev;
  // Set up error handling for the entire app
  runZonedGuarded<Future<void>>(
    () async {
      try {
        await appInit();
        runApp(
          MultiBlocProvider(
            providers: BlocProviders.blocProviderForMyApp,
            child: const MyApp(),
          ),
        );
      } catch (e, stack) {
        // Handle any errors during app startup
        await CrashlyticsService.service.logError(
          error: e,
          stackTrace: stack,
          reason: 'Error in main()',
          fatal: true,
        );

        // Re-throw in debug mode to see the error in the console
        if (kDebugMode) {
          rethrow;
        }

        // Exit the app in release mode
        exit(1);
      }
    },
    (error, stackTrace) async {
      // Handle uncaught errors
      await CrashlyticsService.service.logError(
        error: error,
        stackTrace: stackTrace,
        reason: 'Uncaught error in runZonedGuarded',
        fatal: true,
      );

      // Also log to console in debug mode
      if (kDebugMode) {
        Log.crash(error: error, stackTrace: stackTrace, reason: 'main');
      }

      // Exit the app in release mode
      exit(1);
    },
  );
}

FVoid appInit() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation if not web
  if (!kIsWeb) OrientationExtension.lockVertical();

  try {
    // Initialize Firebase
    await Firebase.initializeApp();
    await InjectorService.service.init();

    // Initialize other services
    // await AppLanguageService.services.init();

    // Initialize notification service
    await NotificationService.initialize();

    // Initialize remaining services
    RouteService.routeService.init();
    // ThemeService.themeService.init();
    InternetService.service.init();
    // Initialize Crashlytics
    await CrashlyticsService.service.init();

    MyAppListener.service.init();

    // Set up BLoC observer with error handling
    Bloc.observer = AppBlocObserver();

    // Set up screen size constraints
    SizeUtils.setScreenSize(
      const BoxConstraints(
        maxHeight: figmaDesignHeight,
        maxWidth: figmaDesignWidth,
      ),
      Orientation.portrait,
    );

    Log.d("All Services Initialized");
  } catch (e, stack) {
    // Record any initialization errors to Crashlytics
    Log.e("Error in app running $e");
    await CrashlyticsService.service.logError(
      error: e,
      stackTrace: stack,
      reason: 'Error during app initialization',
      fatal: true,
    );
  }
}
