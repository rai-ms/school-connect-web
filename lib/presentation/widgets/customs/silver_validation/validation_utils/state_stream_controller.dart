import 'dart:async';

/// Must Call Dispose
/// Only Broadcast Streams
class StateStreamController<T> {
  final StreamController<T> controller;
  late final StreamSubscription<T> _observerStream;
  T value;

  Stream<T> get stream => controller.stream;
  Sink<T> get sink => controller.sink;

  StateStreamController({
    required T initialValue,
  })  : value = initialValue,
        controller = StreamController<T>.broadcast() {
    _observerStream = controller.stream.listen((event) {
      value = event;
    });
  }

  StateStreamController.withController({
    required T initialValue,
    required this.controller,
  })  : assert(controller.stream.isBroadcast),
        value = initialValue {
    _observerStream = controller.stream.listen((event) {
      value = event;
    });
  }

  void close() {
    _observerStream.cancel();
    controller.close();
  }
}
