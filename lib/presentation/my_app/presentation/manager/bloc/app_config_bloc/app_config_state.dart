part of 'app_config_bloc.dart';

class AppConfigState extends BlocEventState<ConfigResponse>{
  final TenantSettingsResponse? tenantSettings;

  const AppConfigState({
    super.data,
    super.error,
    super.event,
    super.state,
    super.statusCode,
    this.tenantSettings,
  });

  @override
  AppConfigState clear() => AppConfigState();

  @override
  AppConfigState copyWith({
    BlocState? state,
    BlocEvent? event,
    int? statusCode,
    ConfigResponse? data,
    String? error,
    TenantSettingsResponse? tenantSettings,
  }){
    return AppConfigState(
      state: state ?? this.state,
      event: event ?? this.event,
      data: data ?? this.data,
      error: error ?? this.error,
      statusCode: statusCode ?? this.statusCode,
      tenantSettings: tenantSettings ?? this.tenantSettings,
    );
  }

  /// Check if a feature is enabled based on tenant settings
  bool isFeatureEnabled(String feature) {
    return tenantSettings?.isFeatureEnabled(feature) ?? true;
  }
}
