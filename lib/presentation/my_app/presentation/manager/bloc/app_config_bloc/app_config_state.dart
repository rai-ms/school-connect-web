part of 'app_config_bloc.dart';

class AppConfigState extends BlocEventState<ConfigResponse>{

  const AppConfigState({super.data, super.error, super.event, super.state, super.statusCode});

  @override
  AppConfigState clear() => AppConfigState();

  @override
  AppConfigState copyWith({
    BlocState? state,
    BlocEvent? event,
    int? statusCode,
    ConfigResponse? data,
    String? error,
  }){
    return AppConfigState(
      state: state ?? this.state,
      event: event ?? this.event,
      data: data ?? this.data,
      error: error ?? this.error,
      statusCode: statusCode ?? this.statusCode
    );
  }

}

