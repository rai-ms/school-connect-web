import 'package:dio/dio.dart';

mixin BaseClientDio {
  Dio get dio;
  BaseOptions get baseOptions;
}