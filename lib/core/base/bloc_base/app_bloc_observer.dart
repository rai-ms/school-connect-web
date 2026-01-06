import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/services/crashlytics_service/crashlytics_service.dart';
import '../logger/app_logger_impl.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    Log.d('$event');
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // Log the error to console
    Log.e('Error in ${bloc.runtimeType}', error: error, stackTrace: stackTrace);
    
    // Report the error to Crashlytics
    CrashlyticsService.service.logError(
      error: error,
      reason: 'Error in Bloc: ${bloc.runtimeType}',
      fatal: false,
      stackTrace: stackTrace
    );
    super.onError(bloc, error, stackTrace);
  }
  
  @override
  void onChange(BlocBase bloc, Change change) {
    // Log state changes in debug mode
    if (kDebugMode) {
      Log.d('${bloc.runtimeType} state changed: $change');
    }
    super.onChange(bloc, change);
  }
}
