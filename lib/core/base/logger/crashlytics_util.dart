import 'package:student_management/core/services/crashlytics_service/crashlytics_service.dart';

/// Utility class for recording errors and non-fatal exceptions to Crashlytics
class CrashlyticsUtil {
  /// Records an error to Crashlytics with an optional reason
  /// 
  /// [reason] A short message explaining what was happening when the error occurred
  /// [error] The error that was caught
  /// [stackTrace] The stack trace associated with the error
  /// [fatal] If the error was fatal to the app's execution
  static Future<void> recordError({
    String reason = '',
    Object? error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) async {
    if (error != null) {
      await CrashlyticsService.service.logError(
        error: error,
        stackTrace: stackTrace,
        reason: reason,
        fatal: fatal,
      );
    }
  }

  /// Records a non-fatal error to Crashlytics
  /// 
  /// [reason] A short message explaining what was happening when the error occurred
  /// [error] The error that was caught
  /// [stackTrace] The stack trace associated with the error
  static Future<void> recordNonFatalError({
    String reason = '',
    Object? error,
    StackTrace? stackTrace,
  }) async {
    if (error != null) {
      await CrashlyticsService.service.logError(
        error: error,
        stackTrace: stackTrace,
        reason: reason,
      );
    }
  }

  /// Sets the user ID to be associated with crash reports
  static Future<void> setUserId(String userId) async {
    await CrashlyticsService.service.setUserId(userId);
  }
}
