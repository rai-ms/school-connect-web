import 'env/app_environment.dart';

enum Flavor {
  dev,
  prod,
}

class F {
  F._();

  /// Get flavor from compile-time environment variable
  static Flavor get appFlavor {
    switch (EnvironmentConfig.environment) {
      case AppEnvironment.dev:
        return Flavor.dev;
      case AppEnvironment.prod:
        return Flavor.prod;
    }
  }

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'School Connect Dev';
      case Flavor.prod:
        return 'School Connect';
    }
  }

  /// Get base URL from envied generated files
  static String get baseUrl => EnvironmentConfig.baseUrl;

  static bool get isDev => appFlavor == Flavor.dev;
  static bool get isProd => appFlavor == Flavor.prod;
}
