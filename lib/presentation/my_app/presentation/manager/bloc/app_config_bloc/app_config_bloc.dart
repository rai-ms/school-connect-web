import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/my_app/data/model/response/config_response.dart';
import 'package:student_management/presentation/my_app/domain/use_case/get_app_config_use_case.dart';

import '../../../../../../core/base/base_client/no_param.dart';

part 'app_config_event.dart';
part 'app_config_state.dart';

@injectable
class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final FetchAppConfigUseCase _appConfigUseCase;
  final StateRequestHandler _handler;

  AppConfigBloc(this._appConfigUseCase, this._handler)
    : super(AppConfigState()) {
    on<InitAppConfig>(_initConfig);
    on<ReloadAppConfig>(_reloadConfig);
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
}
