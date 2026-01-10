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

void main() {
  // Set flavor to DEV
  F.appFlavor = Flavor.dev;

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
        await CrashlyticsService.service.logError(
          error: e,
          stackTrace: stack,
          reason: 'Error in main_dev()',
          fatal: true,
        );

        if (kDebugMode) {
          rethrow;
        }
        exit(1);
      }
    },
    (error, stackTrace) async {
      await CrashlyticsService.service.logError(
        error: error,
        stackTrace: stackTrace,
        reason: 'Uncaught error in runZonedGuarded (dev)',
        fatal: true,
      );

      if (kDebugMode) {
        Log.crash(error: error, stackTrace: stackTrace, reason: 'main_dev');
      }
      exit(1);
    },
  );
}

FVoid appInit() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) OrientationExtension.lockVertical();

  try {
    // Initialize Firebase (uses google-services.json from android/app/src/dev/)
    await Firebase.initializeApp();
    await InjectorService.service.init();

    await NotificationService.initialize();

    RouteService.routeService.init();
    InternetService.service.init();
    await CrashlyticsService.service.init();

    MyAppListener.service.init();

    Bloc.observer = AppBlocObserver();

    SizeUtils.setScreenSize(
      const BoxConstraints(
        maxHeight: figmaDesignHeight,
        maxWidth: figmaDesignWidth,
      ),
      Orientation.portrait,
    );

    Log.d("DEV: All Services Initialized - Base URL: ${F.baseUrl}");
  } catch (e, stack) {
    Log.e("Error in app running $e");
    await CrashlyticsService.service.logError(
      error: e,
      stackTrace: stack,
      reason: 'Error during app initialization (dev)',
      fatal: true,
    );
  }
}
