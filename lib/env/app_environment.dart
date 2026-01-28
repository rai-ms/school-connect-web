// ignore_for_file: constant_identifier_names

import 'env_dev.dart';
import 'env_prod.dart';

/// Application environment types
enum AppEnvironment {
  dev,
  prod,
}

/// Environment configuration loaded from Flutter flavor
/// Use: flutter run --flavor dev
/// Or:  flutter run --flavor prod
class EnvironmentConfig {
  // Flutter automatically sets FLUTTER_APP_FLAVOR when using --flavor
  static const String _flavor =
      String.fromEnvironment('FLUTTER_APP_FLAVOR', defaultValue: 'dev');

  EnvironmentConfig._();

  /// Current environment
  static AppEnvironment get environment {
    switch (_flavor.toLowerCase()) {
      case 'dev':
        return AppEnvironment.dev;
      case 'prod':
        return AppEnvironment.prod;
      default:
        return AppEnvironment.dev;
    }
  }

  /// Check if current environment is dev
  static bool get isDev => environment == AppEnvironment.dev;

  /// Check if current environment is production
  static bool get isProd => environment == AppEnvironment.prod;

  /// Get base URL from envied generated files based on environment
  static String get baseUrl {
    switch (environment) {
      case AppEnvironment.dev:
        return EnvDev.baseUrl;
      case AppEnvironment.prod:
        return EnvProd.baseUrl;
    }
  }

  /// Environment name for display/logging
  static String get environmentName => _flavor.toUpperCase();
}
