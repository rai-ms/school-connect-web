// ignore_for_file: implementation_imports

import 'dart:developer' as d;

import 'package:dio/src/dio.dart';
import 'package:dio/src/options.dart';
import 'package:injectable/injectable.dart';
import 'package:network_logger/network_logger.dart' show DioNetworkLogger;
import 'package:student_management/core/base/base_client/base_client.dart';
import 'package:student_management/core/base/base_client/base_interceptor.dart';
import 'package:student_management/core/utils/config/app_config_impl.dart';
import 'package:student_management/flavors.dart';

import '../../base/base_service/base_service.dart';
import '../../base/logger/app_logger_impl.dart';

@singleton
class ApiService extends BaseService<void, String?> with BaseClientDio {
  const ApiService();

  @override
  BaseOptions get baseOptions => BaseOptions(
    baseUrl: F.baseUrl,
    connectTimeout: const Duration(minutes: 5),
    receiveTimeout: const Duration(minutes: 5),
  );

  @override
  Dio get dio => _dio();

  Dio _dio() {
    var dio = Dio(baseOptions);
    if (AppConfigurations().isLoggerEnable) {
      dio.interceptors.add(
        BaseInterceptor(
          logPrint: d.log,
          responseBody: false,
          responseHeader: false,
          requestBody: true,
          requestHeader: false,
          queryParameters: false,
          showProcessingTime: false,
          convertFormData: false,
        ),
      );
      if (AppConfigurations().isNetworkLoggerEnable) {
        dio.interceptors.add(DioNetworkLogger());
      }
    }
    return dio;
  }

  @override
  void init({String? param}) {
    Log.d("Initializing ApiService with baseUrl: ${F.baseUrl}");
  }
}
