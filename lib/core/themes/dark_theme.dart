import 'package:flutter/material.dart';
import 'package:student_management/core/base/theme_base/theme_base.dart';
import 'package:student_management/core/utils/app_colors.dart';

class AppDarkTheme extends AppCustomTheme {
  const AppDarkTheme() : super(Brightness.dark);

  @override
  ColorScheme get colorScheme => ColorScheme.dark(
    primary: AppColors.blackColor,
    onPrimary: AppColors.romanSilver,
    surface: AppColors.blackColor.withValues(alpha: 0.7),
    onSurface: AppColors.greyColor.withValues(alpha: 0.4),
    secondary: AppColors.whiteColor,
    onSecondary: AppColors.blackColor,
    primaryContainer: AppColors.lightGrey,
    errorContainer: AppColors.kuCrimson,
    onErrorContainer: AppColors.maroon,
    onPrimaryContainer: AppColors.lightBlack.withValues(alpha: 0.4),
    inversePrimary: AppColors.blackColor,
    tertiary: AppColors.whiteColor,
    surfaceTint: AppColors.whiteColor,
  );

  @override
  ThemeData getTheme() => ThemeData(
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.onSurface,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: colorScheme.secondary,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: colorScheme.secondary),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          strokeAlign: 0.5,
          color: colorScheme.surface,
          style: BorderStyle.solid,
        ),
      ),
    ),
    brightness: brightness,
    colorScheme: colorScheme,
    visualDensity: VisualDensity.standard,
    textTheme: textTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        padding: EdgeInsets.zero,
        backgroundColor: colorScheme.onSurface,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: AppColors.greyColor.withValues(alpha: 0.9),
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
