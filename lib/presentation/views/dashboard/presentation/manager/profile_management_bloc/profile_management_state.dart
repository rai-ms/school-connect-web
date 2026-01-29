part of 'profile_management_bloc.dart';

class ProfileManageState extends BlocEventState<TokenData> {
  final bool isProfileLoaded;
  final UserRole? role;
  final ProfileResponse? profile;
  final bool isTokenNotFound;
  final String? profileUpdateMessage;

  const ProfileManageState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.isProfileLoaded = false,
    this.isTokenNotFound = false,
    this.role,
    this.profile,
    this.profileUpdateMessage,
  });

  @override
  ProfileManageState copyWith({
    BlocState? state,
    TokenData? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    bool? isProfileLoaded,
    bool? isTokenNotFound,
    UserRole? role,
    ProfileResponse? profile,
    String? profileUpdateMessage,
  }) {
    return ProfileManageState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      isTokenNotFound: isTokenNotFound ?? this.isTokenNotFound,
      isProfileLoaded: isProfileLoaded ?? data != null,
      role: role ?? this.role,
      profile: profile ?? this.profile,
      profileUpdateMessage: profileUpdateMessage,
    );
  }

  @override
  ProfileManageState clear({BlocState? state, BlocEvent? event}) => ProfileManageState(state: state ?? super.state, event: event);
}
