import 'package:flutter/material.dart';

class AppAssets {
  static const String noInternet = 'assets/images/no_internet/no_internet.webp';
  static const String animatedBackground =
      'assets/images/login/animated_background.webp';
  static const String bg1 = 'assets/images/backgrounds/bg_1.webp';
  static const String bg2 = 'assets/images/backgrounds/bg_2.webp';
  static const String bg3 = 'assets/images/backgrounds/bg_3.webp';
  static const String bg4 = 'assets/images/backgrounds/bg_4.webp';
  static const String bg5 = 'assets/images/backgrounds/bg_5.webp';
  static const String icLauncher =
      'assets/images/app_build_image/ic_launcher.png';
  static const String logo = 'assets/images/logo.png';
}

Future<void> myPrecacheImage(BuildContext context) async {
  await Future.wait([]);
}
