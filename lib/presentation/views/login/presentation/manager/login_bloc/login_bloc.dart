import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/base_client/status_message.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart'
    show Log;
import 'package:student_management/core/handler/app_error/app_error.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/services/storage_service/storage_repo/auth_storage_repo.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;
import 'package:student_management/presentation/views/login/data/models/request/login_request.dart';
import 'package:student_management/presentation/views/login/data/models/response/login_response.dart';
import 'package:student_management/presentation/views/login/domain/repositories/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final StateRequestHandler _stateRequestHandler;
  final LoginRepository _loginRepository;
  final AuthStorageRepository _storageService;

  LoginBloc(
    this._stateRequestHandler,
    this._loginRepository,
    this._storageService,
  ) : super(const LoginState()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LogoutRequested>(_onLogoutRequested);
  }

  FVoid _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    await _stateRequestHandler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        var req = LoginRequest(
          password: event.password,
          username: event.email,
          rememberMe: event.rememberMe,
        );
        final result = await _loginRepository.login(payload: req);

        // Check if API returned an error
        if (result.data['status'] == 'ERROR') {
          final errorMessage = result.data['message'] ?? 'Login failed';
          throw Exception(errorMessage);
        }

        LoginResponse response = LoginResponse.fromJson(result.data);

        // Validate tokens before saving
        if (response.accessToken == null || response.accessToken!.isEmpty) {
          throw Exception('No access token received from server');
        }

        await Future.wait([
          _storageService.userIdRemember.write(req.username),
          _storageService.userPasswordRemember.write(req.password),
          _storageService.accessToken.write(response.accessToken ?? ""),
          _storageService.refreshToken.write(response.refreshToken ?? ""),
          _storageService.userId.write(response.user?.id ?? ""),
        ]);
        emit(state.copyWith(data: response, state: state.success));
      },
      dioError: (dioError) {
        Log.e("Login error: ${dioError.message}");
        emit(
          state.copyWith(
            state: state.failed,
            error: dioError.response?.statusCode.message,
          ),
        );
      },
      error: (Exception e) {
        Log.e("Login error: ${e.toString()}");
        emit(state.copyWith(state: state.failed, error: _errorMessage(e)));
      },
    );
  }

  String? _errorMessage(Exception e) {
    if (e is NetworkNotFoundException) {
      return e.message;
    }
    if (e is ServerException) {
      return e.message;
    }
    Log.e("Error $e");
    return null;
  }

  FVoid _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {}
}
