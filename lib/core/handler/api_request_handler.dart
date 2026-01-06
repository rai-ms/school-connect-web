import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/*
class responsible for removal of redundant status checks
and returning suitable api responses on basic of that..
This takes two callbacks :
1. apiCall() where we have to perform the dio api call with post, get etc..
2. refreshToken() handles with the refresh token logic
 */

@singleton
class ApiHandler {
  const ApiHandler();
  Future<Response> dioHandler({
    required Future<Response> Function() apiCall,
    required Function? refreshTokenCallBack,
  }) async {
    try {
      Response res = await apiCall();
      return res;
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.unauthorized &&
          refreshTokenCallBack != null) {
        return refreshTokenCallBack();
      } else {
        rethrow;
      }
    }
  }
}
