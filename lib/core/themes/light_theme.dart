import 'package:flutter/material.dart';
import 'package:student_management/core/base/theme_base/theme_base.dart';
import 'package:student_management/core/utils/app_colors.dart';

class AppLightTheme extends AppCustomTheme {
  const AppLightTheme() : super(Brightness.light);

  @override
  ColorScheme get colorScheme => ColorScheme.light(
    primary: AppColors.whiteColor,
    onPrimary: AppColors.romanSilver,
    onSurface: AppColors.greyColor.withValues(alpha: 0.1),
    surface: AppColors.whiteColor.withValues(alpha: 0.9),
    secondary: AppColors.blackColor,
    onSecondary: AppColors.whiteColor,
    primaryContainer: AppColors.blueColor,
    onPrimaryContainer: AppColors.whiteColor,
    errorContainer: AppColors.kuCrimson,
    onErrorContainer: AppColors.darkBlueColor,
    inversePrimary: AppColors.darkRedColor,
    tertiary: AppColors.blackColor,
    scrim: AppColors.blueColor,
    surfaceTint: AppColors.blueColor,
  );

  @override
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    useSystemColors: true,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.onSurface,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: colorScheme.secondary,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: colorScheme.primary),
    ),
    brightness: brightness,
    visualDensity: VisualDensity.standard,
    colorScheme: colorScheme,
    textTheme: textTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.scrim,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        padding: EdgeInsets.zero,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: colorScheme.onSurface.withValues(alpha: 0.9),
          width: 1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        padding: EdgeInsets.zero,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.onSurface;
      }),
      visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
    ),
    dividerTheme: DividerThemeData(
      thickness: 23,
      space: 23,
      color: AppColors.greyColor.withValues(alpha: 0.5),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.tertiary;
          }
          return colorScheme.tertiary;
        }),
        surfaceTintColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.tertiary;
          }
          return colorScheme.tertiary;
        }),
      ),
    ),
  );

  @override
  TextTheme textTheme() => const TextTheme();
}
