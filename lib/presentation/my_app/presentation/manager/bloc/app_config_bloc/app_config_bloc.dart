import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/my_app/data/model/response/config_response.dart';
import 'package:student_management/presentation/my_app/data/model/response/tenant_settings_response.dart';
import 'package:student_management/presentation/my_app/domain/repo/app_config_repo.dart';
import 'package:student_management/presentation/my_app/domain/use_case/get_app_config_use_case.dart';

import '../../../../../../core/base/base_client/no_param.dart';

part 'app_config_event.dart';
part 'app_config_state.dart';

@injectable
class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final FetchAppConfigUseCase _appConfigUseCase;
  final StateRequestHandler _handler;
  final AppConfigRepo _appConfigRepo;

  AppConfigBloc(this._appConfigUseCase, this._handler, this._appConfigRepo)
    : super(AppConfigState()) {
    on<InitAppConfig>(_initConfig);
    on<ReloadAppConfig>(_reloadConfig);
    on<FetchTenantSettings>(_fetchTenantSettings);
    on<UpdateTenantSettings>(_updateTenantSettings);
  }

  FutureOr<void> _initConfig(
    InitAppConfig event,
    Emitter<AppConfigState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        Log.d("Calling Init");
        emit(state.copyWith(event: event, state: state.loading));
        var res = await _appConfigUseCase(params: NoParam());
        Log.d("Received response is ${res.data}");
        ConfigResponse configResponse = ConfigResponse.fromJson(res.data);
        emit(state.copyWith(data: configResponse, state: state.success));
      },
      dioError: (dioError) {
        Log.e("Error in api calling $dioError");
        emit(state.copyWith(state: state.failed, error: dioError.toString()));
      },
      error: (error) {
        Log.e("Error in _initConfig $error");
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }

  FutureOr<void> _reloadConfig(
    ReloadAppConfig event,
    Emitter<AppConfigState> emit,
  ) async {}

  FutureOr<void> _fetchTenantSettings(
    FetchTenantSettings event,
    Emitter<AppConfigState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        Log.d("Fetching tenant settings");
        emit(state.copyWith(event: event, state: state.loading));
        var res = await _appConfigRepo.getTenantSettings();
        final data = res.data is Map<String, dynamic>
            ? res.data
            : (res.data['data'] ?? res.data);
        TenantSettingsResponse tenantSettings =
            TenantSettingsResponse.fromJson(data);
        Log.d("Tenant settings loaded: ${tenantSettings.displayName}");
        emit(state.copyWith(
          tenantSettings: tenantSettings,
          state: state.success,
        ));
      },
      dioError: (dioError) {
        Log.e("Error fetching tenant settings: $dioError");
        emit(state.copyWith(state: state.failed, error: dioError.toString()));
      },
      error: (error) {
        Log.e("Error in _fetchTenantSettings: $error");
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }

  FutureOr<void> _updateTenantSettings(
    UpdateTenantSettings event,
    Emitter<AppConfigState> emit,
  ) async {
    await _handler(
      apiCall: () async {
        Log.d("Updating tenant settings");
        emit(state.copyWith(event: event, state: state.loading));
        var res = await _appConfigRepo.updateTenantSettings(event.settings);
        final data = res.data is Map<String, dynamic>
            ? res.data
            : (res.data['data'] ?? res.data);
        TenantSettingsResponse tenantSettings =
            TenantSettingsResponse.fromJson(data);
        Log.d("Tenant settings updated successfully");
        emit(state.copyWith(
          tenantSettings: tenantSettings,
          state: state.success,
        ));
      },
      dioError: (dioError) {
        Log.e("Error updating tenant settings: $dioError");
        emit(state.copyWith(state: state.failed, error: dioError.toString()));
      },
      error: (error) {
        Log.e("Error in _updateTenantSettings: $error");
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }
}
