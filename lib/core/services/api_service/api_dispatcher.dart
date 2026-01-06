import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_service.dart';

import '../../base/logger/app_logger_impl.dart';

enum RequestType {
  get("get"),
  post("post"),
  put("put"),
  patch("patch"),
  delete("delete"),
  formData("formData"),
  download("download"),
  stream("stream"),
  bytes("bytes"),
  uploadStream("uploadStream");

  final String value;

  const RequestType(this.value);

  static RequestType fromString(String val) {
    return RequestType.values.firstWhere((test) => test.value == val);
  }

  @override
  String toString() {
    return value;
  }
}

@lazySingleton
class ApiDispatcher {
  final ApiService _service;
  const ApiDispatcher(this._service);

  Future<Response> call({
    required RequestType type,
    required String endPoint,
    Map<String, dynamic>? queryParam,
    Map<String, dynamic>? body,
    FormData? formData,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    String method;
    switch (type) {
      case RequestType.get:
        method = 'GET';
        break;
      case RequestType.post:
      case RequestType.formData:
        method = 'POST';
        break;
      case RequestType.put:
        method = 'PUT';
        break;
      case RequestType.delete:
        method = 'DELETE';
        break;
      case RequestType.download:
        method = 'GET';
        break;
      default:
        method = 'POST';
    }

    try {
      return await _service.dio.fetch(
        Options(
          headers: options?.headers ?? {},
          method: method,
          responseType: type == RequestType.download
              ? ResponseType.stream
              : ResponseType.json,
          validateStatus: (status) => status! < 500,
        ).compose(
          _service.dio.options,
          endPoint,
          data: formData ?? body,
          queryParameters: queryParam,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
      );
    } on DioException catch (e) {
      Log.e("Error in API call $e");
      rethrow;
    }
  }
}
