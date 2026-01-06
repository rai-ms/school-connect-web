part of 'login_bloc.dart';

class LoginState extends BlocEventState<LoginResponse> {

  const LoginState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
  });

  @override
  LoginState copyWith({
    String? error,
    BlocEvent? event,
    int? statusCode,
    BlocState? state,
    LoginResponse? data
  }) {
    return LoginState(
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      state: state ?? this.state,
    );
  }

  @override
  LoginState clear() => const LoginState();
}
