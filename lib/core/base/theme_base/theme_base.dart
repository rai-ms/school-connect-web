import 'package:flutter/material.dart';

@protected
@immutable
abstract class AppCustomTheme {
  final Brightness brightness;
  const AppCustomTheme(this.brightness);

  ThemeData getTheme();

  TextTheme textTheme();

  ColorScheme get colorScheme;
}