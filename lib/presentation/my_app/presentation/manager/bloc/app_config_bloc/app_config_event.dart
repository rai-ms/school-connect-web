part of 'app_config_bloc.dart';

class AppConfigEvent extends BlocEvent{}

class InitAppConfig extends AppConfigEvent{}

class ReloadAppConfig extends AppConfigEvent{}

class FetchTenantSettings extends AppConfigEvent{}

class UpdateTenantSettings extends AppConfigEvent{
  final Map<String, dynamic> settings;
  UpdateTenantSettings(this.settings);
}
