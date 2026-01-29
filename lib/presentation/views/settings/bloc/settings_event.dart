part of 'settings_bloc.dart';

class SettingsEvent extends BlocEvent {
  const SettingsEvent();
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class UpdateDarkMode extends SettingsEvent {
  final bool enabled;
  const UpdateDarkMode(this.enabled);
}

class UpdateLanguage extends SettingsEvent {
  final AppLanguage language;
  const UpdateLanguage(this.language);
}

enum NotificationType { push, email }

class UpdateNotificationPreference extends SettingsEvent {
  final NotificationType type;
  final bool enabled;
  const UpdateNotificationPreference({
    required this.type,
    required this.enabled,
  });
}
