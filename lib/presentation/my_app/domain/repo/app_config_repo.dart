

import 'package:dio/dio.dart';

abstract class AppConfigRepo{
  const AppConfigRepo();
  Future<Response> getAppConfig();
}