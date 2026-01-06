import 'dart:io';

import 'package:dio/dio.dart';

abstract class APIHeaders {
  static Options bearerOnlyHeader(String? token) {
    return Options(
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      contentType: "application/json",
    );
  }
}
