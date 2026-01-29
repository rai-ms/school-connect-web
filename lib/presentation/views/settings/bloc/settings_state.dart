part of 'settings_bloc.dart';

class SettingsState extends BlocEventState<void> {
  final bool isDarkMode;
  final AppLanguage language;
  final bool pushNotifications;
  final bool emailNotifications;

  const SettingsState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.isDarkMode = false,
    this.language = AppLanguage.english,
    this.pushNotifications = true,
    this.emailNotifications = true,
  });

  @override
  SettingsState copyWith({
    BlocState? state,
    void data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    bool? isDarkMode,
    AppLanguage? language,
    bool? pushNotifications,
    bool? emailNotifications,
  }) {
    return SettingsState(
      state: state ?? this.state,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
    );
  }

  @override
  SettingsState clear({BlocState? state, BlocEvent? event}) =>
      SettingsState(state: state ?? super.state, event: event);
}
