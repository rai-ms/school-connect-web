import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;

/// A utility class that provides device and application information.
/// This class provides both device-specific information (like model, OS version)
/// and application-specific information (like version, build number).
///
/// Example:
/// ```dart
/// // Get device information
/// String deviceName = await DeviceInfoUtils.deviceName;
/// String osVersion = await DeviceInfoUtils.deviceOsVersion;
///
/// // Get app information
/// String appName = await DeviceInfoUtils.appName;
/// String version = await DeviceInfoUtils.appVersion;
/// String buildNumber = await DeviceInfoUtils.buildNumber;
///
/// // Get complete device info as a map
/// Map<String, dynamic> deviceInfo = await DeviceInfoUtils.getCompleteDeviceInfo();
/// ```
class DeviceInfoUtils {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  // Private getter for package info to avoid multiple initializations
  static Future<PackageInfo> get _packageInfo async =>
      await PackageInfo.fromPlatform();

  /// Get the app version (e.g., '1.0.0')
  static Future<String> get appVersion async {
    var packageInfo = await _packageInfo;
    return packageInfo.version;
  }

  /// Get the app version number without build number (e.g., '1.0.0' from '1.0.0+1')
  static Future<String> get appVersionNumber async {
    var packageInfo = await _packageInfo;
    return packageInfo.version.split('+').first;
  }

  /// Get the full app build version (e.g., '1.0.0 (1)')
  static Future<String> get appBuildVersion async {
    var packageInfo = await _packageInfo;
    return '${packageInfo.version} (${packageInfo.buildNumber})';
  }

  /// Get the app display name
  static Future<String> get appName async {
    var packageInfo = await _packageInfo;
    return packageInfo.appName;
  }

  /// Get the app package name (e.g., 'com.example.app')
  static Future<String> get appPackageName async {
    var packageInfo = await _packageInfo;
    return packageInfo.packageName;
  }

  /// Get the app build signature (Android only)
  static Future<String> get appBuildSignature async {
    var packageInfo = await _packageInfo;
    return packageInfo.buildSignature;
  }

  /// Get the app installer store (e.g., 'com.android.vending' for Play Store)
  static Future<String> get appInstallerStore async {
    var packageInfo = await _packageInfo;
    return packageInfo.installerStore ?? 'Unknown Installer Store';
  }

  /// Get the app installation time
  static Future<DateTime?> get appInstallTime async {
    var packageInfo = await _packageInfo;
    return packageInfo.installTime;
  }

  /// Get the app last update time
  static Future<DateTime?> get appUpdateTime async {
    var packageInfo = await _packageInfo;
    return packageInfo.updateTime;
  }

  /// Get the current app version (alias for appVersion)
  static Future<String> get currentVersion async {
    return appVersion;
  }

  /// Get the app build number (e.g., '1')
  static Future<String> get buildNumber async {
    var packageInfo = await _packageInfo;
    return packageInfo.buildNumber;
  }

  /// Get the device name (e.g., 'iPhone 13' or 'sdk_gphone64_arm64')
  static Future<String> get deviceName async {
    if (Platform.isAndroid) {
      var androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      var iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.name;
    } else {
      return 'Unknown Device';
    }
  }

  /// Get the device OS version (e.g., '13.0')
  static Future<String> get deviceOsVersion async {
    if (Platform.isAndroid) {
      var androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.version.release;
    } else if (Platform.isIOS) {
      var iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.systemVersion;
    } else {
      return 'Unknown OS Version';
    }
  }

  /// Get the device model (e.g., 'iPhone13,2' or 'sdk_gphone64_arm64')
  static Future<String> get deviceModel async {
    if (Platform.isAndroid) {
      var androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      var iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.model;
    } else {
      return 'Unknown Model';
    }
  }

  /// Get the device platform ('android', 'ios', 'windows', 'macos', 'linux' or 'web')
  static String get devicePlatform {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isLinux) return 'linux';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isFuchsia) return 'fuchsia';
    return 'web';
  }

  /// Get the device SDK version (Android) or system version (iOS)
  static Future<String> get deviceBuildNumber async {
    if (Platform.isAndroid) {
      var androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.version.sdkInt.toString();
    } else if (Platform.isIOS) {
      var iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.systemVersion;
    } else {
      return 'Unknown Build Number';
    }
  }

  /// Get the device manufacturer (e.g., 'Apple' or 'Google')
  static Future<String> get deviceManufacturer async {
    if (Platform.isAndroid) {
      var androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.manufacturer;
    } else if (Platform.isIOS) {
      return 'Apple';
    } else {
      return 'Unknown Manufacturer';
    }
  }

  /// Get the device serial number or unique identifier
  static Future<String> get deviceId async {
    if (Platform.isAndroid) {
      var androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      var iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor ?? "";
    } else {
      return 'Unknown Device ID';
    }
  }

  /// Get complete device and app information as a Map
  static Future<Map<String, dynamic>> getCompleteDeviceInfo() async {
    return {
      'app': {
        'name': await appName,
        'version': await appVersion,
        'buildNumber': await buildNumber,
        'packageName': await appPackageName,
        'installerStore': await appInstallerStore,
      },
      'device': {
        'name': await deviceName,
        'model': await deviceModel,
        'platform': devicePlatform,
        'osVersion': await deviceOsVersion,
        'manufacturer': await deviceManufacturer,
        'id': await deviceId,
      },
    };
  }

  /// Get a formatted string with device and app information
  static Future<String> getFormattedDeviceInfo() async {
    final info = await getCompleteDeviceInfo();
    return '''
App Information:
  Name: ${info['app']!['name']}
  Version: ${info['app']!['version']} (${info['app']!['buildNumber']})
  Package: ${info['app']!['packageName']}
  Store: ${info['app']!['installerStore']}

Device Information:
  Name: ${info['device']!['name']}
  Model: ${info['device']!['model']}
  Platform: ${info['device']!['platform']}
  OS Version: ${info['device']!['osVersion']}
  Manufacturer: ${info['device']!['manufacturer']}
  ID: ${info['device']!['id']}
''';
  }
}
