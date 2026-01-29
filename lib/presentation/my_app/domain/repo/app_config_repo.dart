import 'package:dio/dio.dart';

abstract class AppConfigRepo {
  const AppConfigRepo();
  Future<Response> getAppConfig();
  Future<Response> getTenantSettings();
  Future<Response> updateTenantSettings(Map<String, dynamic> settings);
}