enum Flavor {
  dev,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'School Connect Dev';
      case Flavor.prod:
        return 'School Connect';
    }
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'https://thing-participating-gateway-backed.trycloudflare.com/';
      case Flavor.prod:
        return 'https://thing-participating-gateway-backed.trycloudflare.com/';
    }
  }

  static bool get isDev => appFlavor == Flavor.dev;
  static bool get isProd => appFlavor == Flavor.prod;
}
