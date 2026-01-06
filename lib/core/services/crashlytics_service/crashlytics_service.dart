import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:student_management/core/base/base_service/base_service.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';

/// [CrashlyticsService] handles logging events, user properties,
/// screen views, and errors to Firebase Analytics.
/// It follows the [BaseService] pattern to ensure a single instance
/// is created and initialized at app start.
class CrashlyticsService extends BaseService<void, void> {
  static final CrashlyticsService service = CrashlyticsService();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  bool isDebug = false;

  CrashlyticsService();

  /// Initialize Analytics service
  @override
  Future<void> init({void param}) async {
    Log.d("FirebaseAnalyticsService initialized");
  }

  /// Converts a Map with dynamic values to a Map with Object values
  Map<String, Object>? _convertParameters(Map<String, dynamic>? parameters) {
    if (parameters == null) return null;

    final jsonString = jsonEncode(parameters);
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

    return decoded.map((key, value) {
      if (value is Map<String, dynamic>) {
        return MapEntry(key, _convertParameters(value)!);
      } else if (value is List) {
        return MapEntry(key, value.map((e) => e.toString()).toList());
      } else if (value is String || value is num || value is bool) {
        return MapEntry(key, value as Object);
      } else {
        return MapEntry(key, value.toString());
      }
    });
  }

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (isDebug) {
      Log.d('Analytics Event: $name, Params: $parameters');
      return;
    }

    try {
      final safeParams = _convertParameters(parameters);
      await _analytics.logEvent(name: name, parameters: safeParams);
    } catch (e, stack) {
      Log.e('Failed to log event: $e\n$stack');
    }
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    if (isDebug) {
      Log.d('Analytics User Property - $name: $value');
      return;
    }

    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e, stack) {
      Log.e('Failed to set user property: $e\n$stack');
    }
  }

  Future<void> setUserId(String? userId) async {
    if (isDebug) {
      Log.d('Analytics User ID set to: $userId');
      return;
    }

    try {
      await _analytics.setUserId(id: userId);
    } catch (e, stack) {
      Log.e('Failed to set user ID: $e\n$stack');
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
    Map<String, dynamic>? parameters,
  }) async {
    if (isDebug) {
      Log.d('Screen View: $screenName, Class: $screenClass, Params: $parameters');
      return;
    }

    try {
      final safeParams = _convertParameters(parameters);
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
        parameters: safeParams,
      );
    } catch (e, stack) {
      Log.e('Failed to log screen view: $e\n$stack');
    }
  }

  Future<void> logLogin({
    String? loginMethod,
    bool success = true,
    Map<String, String>? parameters,
  }) async {
    final params = {
      'method': loginMethod,
      'success': success.toString(),
      ...?parameters,
    }..removeWhere((_, value) => value == null);

    await logEvent(name: 'login', parameters: params);
  }

  Future<void> logSignUp({
    String? signUpMethod,
    bool success = true,
    Map<String, dynamic>? parameters,
  }) async {
    final params = {
      'method': signUpMethod,
      'success': success,
      ...?parameters,
    }..removeWhere((_, value) => value == null);

    await logEvent(name: 'sign_up', parameters: params);
  }

  Future<void> logError({
    required dynamic error,
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
    Map<String, String>? parameters,
  }) async {
    var params = {
      'error': error.toString(),
      'reason': reason,
      'fatal': fatal.toString(),
      'stack_trace': stackTrace?.toString(),
      ...?parameters,
    }..removeWhere((_, value) => value == null);
    if(params.isEmpty){
      params = <String, String>{"error": error.toString()};
    }
    await logEvent(name: 'error_occurred', parameters: params);
  }
}
