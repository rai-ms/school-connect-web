import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/services/storage_service/storage_repo/auth_storage_repo.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;
import 'package:student_management/core/utils/jwt/jwt_util.dart';
import 'package:student_management/presentation/views/dashboard/data/models/req/profile_fetch_req.dart';
import 'package:student_management/presentation/views/dashboard/domain/entities/token_data.dart';
import 'package:student_management/presentation/views/dashboard/domain/entities/user_role.dart';

import '../../../data/models/res/profile_response.dart';
import '../../../domain/use_cases/profile_fetch_use_case.dart';

part 'profile_management_event.dart';
part 'profile_management_state.dart';

@injectable
class ProfileManageBloc extends Bloc<ProfileManageEvent, ProfileManageState> {
  final StateRequestHandler _stateRequestHandler;
  final AuthStorageRepository _storageService;
  final ProfileFetchUseCase _profileFetchUseCase;

  ProfileManageBloc(
    this._stateRequestHandler,
    this._storageService,
    this._profileFetchUseCase,
  ) : super(const ProfileManageState()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateUserFeatures>(_onUpdateUserFeatures);
    on<ClearProfileData>(_onClearProfileData);
    on<CheckFeatureAccess>(_onCheckFeatureAccess);
    on<LogOutEvent>(_logout);
  }

  FVoid _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileManageState> emit,
  ) async {
    await _stateRequestHandler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        String? token = _storageService.accessToken();
        String? userId = _storageService.userId();
        if ((token?.isEmpty ?? true) || (userId?.isEmpty ?? true)) {
          emit(state.copyWith(isTokenNotFound: true, state: state.failed));
        }
        var decodedData = JwtUtils.decode(token!);
        Log.d("Decoded JWT data: $decodedData");
        TokenData data = TokenData.fromJson(decodedData);
        UserRole role = UserRole.fromValue(data.role);
        var res = await _profileFetchUseCase(
          params: ProfileFetchRequest(userId: userId!, token: token),
        );
        Log.d("User profile loaded: ${data.toJson()} with role: ${role.name}");
        ProfileResponse profRes = ProfileResponse.fromJson(res.data);
        emit(
          state.copyWith(
            state: state.success,
            data: data,
            role: role,
            profile: profRes,
          ),
        );
      },
      dioError: (dioError) {
        Log.e("DIOError loading user profile: ${dioError.toString()}");
        _clearAuth();
        emit(
          state.copyWith(
            state: state.failed,
            error: dioError.message,
            statusCode: dioError.response?.statusCode,
          ),
        );
      },
      error: (error) {
        Log.e("Error loading user profile: ${error.toString()}");
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }

  Future _clearAuth() async {
    try {
      await _storageService.clearAuthData();
    } catch (e) {
      Log.e("Error clearing auth session $e");
    }
  }

  FVoid _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileManageState> emit,
  ) async {
    await _stateRequestHandler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        // Here you would typically update user data in storage
        // final features = _getFeaturesForRole(event.userData['role']?.toString() ?? 'student');

        // emit(state.copyWith(
        //   state: state.success,
        //   data: SchoolResponse.fromJson(event.userData),
        //   availableFeatures: features,
        // ));
      },
      dioError: (dioError) {
        emit(state.copyWith(state: state.failed, error: dioError.message));
      },
      error: (error) {
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }

  void _onUpdateUserFeatures(
    UpdateUserFeatures event,
    Emitter<ProfileManageState> emit,
  ) {}

  Future<void> _onClearProfileData(
    ClearProfileData event,
    Emitter<ProfileManageState> emit,
  ) async {
    emit(const ProfileManageState());
  }

  void _onCheckFeatureAccess(
    CheckFeatureAccess event,
    Emitter<ProfileManageState> emit,
  ) {
    // This is a no-op in the bloc as it's just for checking access
    // The UI can check state.availableFeatures directly
  }

  FVoid _logout(LogOutEvent event, Emitter<ProfileManageState> emit) async {
    await _stateRequestHandler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading));
        await _clearAuth();
        emit(state.clear(state: state.success, event: event));
      },
      dioError: (dioError) {
        Log.e("Logout error: ${dioError.message}");
        emit(state.copyWith(state: state.failed, error: dioError.message));
      },
      error: (error) {
        Log.e("Logout error: ${error.toString()}");
        emit(state.copyWith(state: state.failed, error: error.toString()));
      },
    );
  }
}
