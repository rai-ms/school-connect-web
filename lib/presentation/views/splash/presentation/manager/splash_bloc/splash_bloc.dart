import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart'
    show BlocEventState, BlocState;
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/services/storage_service/storage_repo/app_storage_repo.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../../../../core/base/logger/app_logger_impl.dart';
import '../../../../../../core/services/storage_service/storage_repo/auth_storage_repo.dart';

part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final StateRequestHandler _stateRequestHandler;
  final AuthStorageRepository _authStorageRepo;
  final AppStorageRepository _appStorageRepo;

  SplashBloc(
    this._stateRequestHandler,
    this._authStorageRepo,
    this._appStorageRepo,
  ) : super(const SplashState()) {
    on<SplashEvent>((event, emit) {});
    on<FetchDeviceStatusEvent>(_fetchDeviceStatus);
    on<IntroCompleted>(_introCompleted);
  }

  FVoid _fetchDeviceStatus(
    FetchDeviceStatusEvent event,
    Emitter<SplashState> emit,
  ) async {
    await _stateRequestHandler(
      apiCall: () async {
        // Check if user is authenticated
        await Future.delayed(const Duration(seconds: 1));
        final isIntroCompleted = _appStorageRepo.isIntroCompleted();
        Log.d("Intro completed: $isIntroCompleted");
        if (!(isIntroCompleted ?? true)) {
          emit(
            state.copyWith(
              state: state.success,
              routeOnPage: RouteOnPage.intro,
              error: "",
            ),
          );
          return;
        }
        Log.d("Checking authentication status...");
        final hasToken = _authStorageRepo.accessToken() != null;

        // Add a small delay for the splash screen
        await Future.delayed(const Duration(seconds: 2));

        emit(
          state.copyWith(
            state: state.success,
            routeOnPage: hasToken ? RouteOnPage.home : RouteOnPage.login,
            error: "",
          ),
        );
      },
      dioError: (dioError) {
        Log.e("Error in the splash ${dioError.response?.data}");
        emit(
          state.copyWith(
            state: state.failed,
            routeOnPage: RouteOnPage.login, // Default to login on error
            error: dioError.message ?? "Unknown error occurred",
          ),
        );
      },
      error: (error) {
        emit(
          state.copyWith(
            state: state.failed,
            routeOnPage: RouteOnPage.login, // Default to login on error
            error: error.toString(),
          ),
        );
      },
    );
  }

  void _introCompleted(IntroCompleted event, Emitter<SplashState> emit) async {
    try {
      await _appStorageRepo.isIntroCompleted.write(true);
    } catch (e) {
      Log.e("Error saving intro completed status: $e");
    }
  }

  bool get isUpdateAvailable {
    return state.updateUrl != null &&
        state.updateUrl!.isNotEmpty &&
        state.data == true;
  }

  String get updateUrl {
    return state.updateUrl ?? "";
  }
}
