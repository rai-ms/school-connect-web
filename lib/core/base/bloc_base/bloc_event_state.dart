



import 'bloc_event.dart' show BlocEvent;

enum BlocState {
  none,
  loading,
  noInternet,
  success,
  failed;
}

abstract class BlocEventState<T> {
  final BlocState state;
  final BlocEvent? event;
  final T? data;
  final int? statusCode;
  final String? error;

  const BlocEventState({
    this.state = BlocState.none,
    this.event,
    this.data,
    this.statusCode,
    this.error
  });

  BlocState get none  => BlocState.none;
  BlocState get loading => BlocState.loading;
  BlocState get success => BlocState.success;
  BlocState get failed => BlocState.failed;
  BlocState get noInternet => BlocState.noInternet;
  bool get isNone => state == none;
  bool get isLoading => state == loading;
  bool get isSuccess => state == success;
  bool get isFailed => state == failed;
  bool get isNoInternet => state == noInternet;

  BlocEventState clear();
  BlocEventState copyWith();
}