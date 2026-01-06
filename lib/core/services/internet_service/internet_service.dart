import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:student_management/core/base/base_service/base_service.dart';
import 'package:student_management/core/services/my_app_listener/my_app_listener.dart'
    show MyAppListener;
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;
import '../../base/logger/app_logger_impl.dart';

/// [InternetService] service to handle the internet activity across the app
@protected
class InternetService extends BaseService<FVoid, void> {
  static final InternetService service = InternetService();

  ValueNotifier<bool?> netListener = ValueNotifier<bool?>(null);

  InternetConnection connection = InternetConnection();

  @override
  FVoid init({void param}) async {
    Log.d("Internet Service Initialized");
    netListener.value = await isConnected();
    addListner();
    Log.d("Internet Service Initialized ${netListener.value}");
  }

  Future<bool> isConnected() async {
    bool result = await connection.hasInternetAccess;
    return result;
  }

  void addListner() {
    connection.onStatusChange.listen((InternetStatus listenStatus) {
      netListener.value = listenStatus == InternetStatus.connected;
      MyAppListener.service.addNetListener();
    });
  }

  Stream<InternetStatus> internetStatus() {
    var status = connection.onStatusChange;
    return status;
  }
}
