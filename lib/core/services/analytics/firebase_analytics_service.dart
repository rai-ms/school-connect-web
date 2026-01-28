import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:student_management/core/base/base_service/base_service.dart';

import '../../../presentation/views/login/domain/entities/login_event.dart';
import '../../base/logger/app_logger_impl.dart';

class FirebaseAnalyticsService extends BaseService{
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final bool isDebug = false;

  static final FirebaseAnalyticsService service = FirebaseAnalyticsService();


  /// Converts a Map with dynamic values to a Map with Object values
  Map<String, Object>? _convertParameters(Map<String, dynamic>? parameters) {
    if (parameters == null) return null;
    
    // Convert to JSON and back to ensure all values are serializable
    final jsonString = jsonEncode(parameters);
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    
    // Convert all values to String representation if they're not already Object
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
      await _analytics.logEvent(
        name: name,
        parameters: safeParams,
      );
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

  Future<void> logLogin({required LogLoginEvent event}) async {
    await logEvent(
      name: 'login',
      parameters: event.toMap(),
    );
  }

  Future<void> logSignUp({
    String? signUpMethod,
    bool success = true,
    Map<String, dynamic>? parameters,
  }) async {
    final params = {
      'method': signUpMethod,
      'success': success.toString(),
      ...?parameters,
    }..removeWhere((_, value) => value == null);

    await logEvent(
      name: 'sign_up',
      parameters: params,
    );
  }

  Future<void> logError({
    required dynamic error,
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
    Map<String, dynamic>? parameters,
  }) async {
    final params = {
      'error': error.toString(),
      'reason': reason,
      'fatal': fatal.toString(),
      'stack_trace': stackTrace?.toString(),
      ...?parameters,
    }..removeWhere((_, value) => value == null);

    await logEvent(
      name: 'error_occurred',
      parameters: params,
    );
  }

  @override
  void init({dynamic param}) {
    Log.d("Firebase Analytics Initialized");
  }
}

extension XAnalytics on BuildContext{
  Future<void> logScreen({required String screenName, required  Map<String, dynamic> params, required Object screenClass}) async => await FirebaseAnalyticsService.service.logScreenView(screenName: screenName, parameters: params, screenClass: screenClass.toString());
  Future<void> logEvent({required String name, required  Map<String, dynamic> params}) async => await FirebaseAnalyticsService.service.logEvent(parameters: params, name: name);
  Future<void> error({required dynamic error, Map<String, dynamic>? params, StackTrace? stackTrace, String? reason}) async => await FirebaseAnalyticsService.service.logError(error: error, parameters: params, stackTrace: stackTrace, reason: reason);
  Future<void> login({required LogLoginEvent loginEvent}) async => await FirebaseAnalyticsService.service.logLogin(event: loginEvent);
}
