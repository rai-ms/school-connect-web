import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_service/base_service.dart'
    show BaseService;
import 'package:student_management/core/services/my_app_listener/my_app_listener.dart'
    show MyAppListener;
import 'package:student_management/core/services/storage_service/hive_storage/hive_constants.dart'
    show AppStorageKey;
import 'package:student_management/core/themes/dark_theme.dart'
    show AppDarkTheme;
import 'package:student_management/core/themes/light_theme.dart'
    show AppLightTheme;
import 'package:student_management/core/utils/app_enum.dart' show AppTheme;
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../base/logger/app_logger_impl.dart';
import '../storage_service/storage_repository.dart';

/// [ThemeService] class is responsible to provide and update the [Theme] in the app
@protected
@immutable
@singleton
class ThemeService extends BaseService<void, AppTheme> {
  ThemeService(this._repository);

  /// [themeListener] is the variable which have the theme value
  /// Overriding the value of [themeListener] react to the changes of theme in the app
  final ValueNotifier<AppTheme> themeListener = ValueNotifier<AppTheme>(
    AppTheme.light,
  );

  final StorageRepository _repository;

  /// [themeService] singleton Object of theme class

  @PostConstruct()
  @override
  void init({AppTheme? param}) {
    Log.d("ThemeService Initialized");
  }

  /// [getThemeType] should call before get theme to update the theme data
  void getThemeType(BuildContext context) {
    String? theme = _repository.loadSync(AppStorageKey.themeKey);
    AppTheme appTheme = AppTheme.getTheme(theme);

    if (appTheme == AppTheme.system) {
      final brightness = MediaQuery.platformBrightnessOf(context);
      brightness == Brightness.dark
          ? themeListener.value = AppTheme.dark
          : themeListener.value = AppTheme.light;
    } else {
      themeListener.value = appTheme;
    }
  }

  /// [updateTheme] should call to update the theme
  FVoid updateTheme(AppTheme theme) async {
    themeListener.value = theme;
    MyAppListener.service.addThemeListener();
    await _repository.save(AppStorageKey.themeKey, theme.getThemeVal());
  }

  /// [getTheme] is return in main, to provide the [ThemeData]
  ThemeData getTheme(BuildContext context) {
    getThemeType(context);
    switch (themeListener.value) {
      case AppTheme.light:
        return const AppLightTheme().getTheme();
      case AppTheme.dark:
        return const AppDarkTheme().getTheme();
      default:
        final brightness = MediaQuery.platformBrightnessOf(context);
        return brightness == Brightness.dark
            ? const AppLightTheme().getTheme()
            : const AppDarkTheme().getTheme();
    }
  }
}
