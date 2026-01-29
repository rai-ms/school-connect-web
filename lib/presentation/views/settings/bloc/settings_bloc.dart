import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/services/my_app_listener/my_app_listener.dart';
import 'package:student_management/core/services/storage_service/storage_repo/app_storage_repo.dart';
import 'package:student_management/core/services/theme_service/theme_service.dart';
import 'package:student_management/core/utils/app_enum.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppStorageRepository _appStorage;
  final ThemeService _themeService;

  SettingsBloc(
    this._appStorage,
    this._themeService,
  ) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateDarkMode>(_onUpdateDarkMode);
    on<UpdateLanguage>(_onUpdateLanguage);
    on<UpdateNotificationPreference>(_onUpdateNotificationPreference);
  }

  FVoid _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(state: state.loading, event: event));

      // Load theme
      final themeValue = _themeService.themeListener.value;
      final isDarkMode = themeValue == AppTheme.dark;

      // Load language
      final langCode = _appStorage.lang();
      final language = AppLanguage.fromString(langCode);

      // Load notification preferences
      final pushNotifStr = _appStorage.pushNotifications();
      final emailNotifStr = _appStorage.emailNotifications();
      final pushNotifications = pushNotifStr != 'false';
      final emailNotifications = emailNotifStr != 'false';

      Log.d("Settings loaded: darkMode=$isDarkMode, language=${language.code}, "
          "push=$pushNotifications, email=$emailNotifications");

      emit(state.copyWith(
        state: state.success,
        isDarkMode: isDarkMode,
        language: language,
        pushNotifications: pushNotifications,
        emailNotifications: emailNotifications,
      ));
    } catch (e) {
      Log.e("Error loading settings: $e");
      emit(state.copyWith(state: state.failed, error: e.toString()));
    }
  }

  FVoid _onUpdateDarkMode(
    UpdateDarkMode event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final newTheme = event.enabled ? AppTheme.dark : AppTheme.light;
      await _themeService.updateTheme(newTheme);
      Log.d("Dark mode updated: ${event.enabled}");
      emit(state.copyWith(
        state: state.success,
        event: event,
        isDarkMode: event.enabled,
      ));
    } catch (e) {
      Log.e("Error updating dark mode: $e");
      emit(state.copyWith(state: state.failed, error: e.toString()));
    }
  }

  FVoid _onUpdateLanguage(
    UpdateLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _appStorage.lang.write(event.language.code);
      MyAppListener.service.update(locale: event.language.code);
      Log.d("Language updated: ${event.language.code}");
      emit(state.copyWith(
        state: state.success,
        event: event,
        language: event.language,
      ));
    } catch (e) {
      Log.e("Error updating language: $e");
      emit(state.copyWith(state: state.failed, error: e.toString()));
    }
  }

  FVoid _onUpdateNotificationPreference(
    UpdateNotificationPreference event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      bool pushNotifications = state.pushNotifications;
      bool emailNotifications = state.emailNotifications;

      if (event.type == NotificationType.push) {
        pushNotifications = event.enabled;
        await _appStorage.pushNotifications.write(
          event.enabled.toString(),
        );
      } else {
        emailNotifications = event.enabled;
        await _appStorage.emailNotifications.write(
          event.enabled.toString(),
        );
      }

      Log.d("Notification preference updated: ${event.type.name}=${event.enabled}");
      emit(state.copyWith(
        state: state.success,
        event: event,
        pushNotifications: pushNotifications,
        emailNotifications: emailNotifications,
      ));
    } catch (e) {
      Log.e("Error updating notification preference: $e");
      emit(state.copyWith(state: state.failed, error: e.toString()));
    }
  }
}
