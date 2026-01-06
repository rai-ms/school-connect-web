
enum CubitBaseState {
  initial, loading, error, success;
}

abstract class CubitDataStateBase {
  final CubitBaseState state;
  String? error;
  int? statusCode;
  Object? data;

  CubitDataStateBase({this.state = CubitBaseState.initial, this.error, this.statusCode, this.data});

  bool get isLoading => state == CubitBaseState.loading;
  bool get isSuccess => state == CubitBaseState.success;
  bool get isError => state == CubitBaseState.error;

  CubitBaseState get getSuccess => CubitBaseState.success;
  CubitBaseState get getLoading => CubitBaseState.loading;
  CubitBaseState get getError => CubitBaseState.error;
}