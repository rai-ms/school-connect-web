import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_service/base_service.dart'
    show BaseService;
import 'package:student_management/core/utils/app_enum.dart'
    show RequestResource;
import 'package:permission_handler/permission_handler.dart';
import '../../base/logger/app_logger_impl.dart';

@protected
@immutable
@singleton
class PermissionService extends BaseService<void, void> {
  /// open system settings
  Future<void> openSettings() async {
    await openAppSettings();
  }

  /// request some permission
  Future<bool> requestPermission(RequestResource requestResource) async {
    switch (requestResource) {
      case RequestResource.camera:
        return await _checkPermission(Permission.camera);
      case RequestResource.storage:
        return await _checkPermission(
          defaultTargetPlatform == TargetPlatform.android
              ? Permission.storage
              : Permission.photos,
        );
      case RequestResource.microphone:
        return await _checkPermission(Permission.microphone);
    }
  }

  /// check permission status of the requested resource
  Future<bool> _checkPermission(Permission permission) async {
    switch (await permission.status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        return false;
      default:
        var newStatus = await [permission].request();
        if (newStatus[permission] == PermissionStatus.granted) return true;
        return false;
    }
  }

  @override
  void init({void param}) {
    Log.d("Initialised Permission Service");
  }
}
