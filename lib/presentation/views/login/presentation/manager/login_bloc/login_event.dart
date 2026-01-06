part of 'login_bloc.dart';

class LoginEvent extends BlocEvent {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginButtonPressed({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}

class LogoutRequested extends LoginEvent {
  const LogoutRequested();
}
