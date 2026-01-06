import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class StateRequestHandler {
  StateRequestHandler();
  Future call({
    required Future Function() apiCall,
    required Function(DioException e) dioError,
    required Function(Exception) error,
  }) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      dioError(e);
    } on Exception catch (e) {
      error(e);
    }
    return null;
  }
}
