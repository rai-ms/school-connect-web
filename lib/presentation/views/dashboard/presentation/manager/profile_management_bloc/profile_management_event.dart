
part of 'profile_management_bloc.dart';

class ProfileManageEvent extends BlocEvent {

  const ProfileManageEvent();
}

class LoadUserProfile extends ProfileManageEvent {
  const LoadUserProfile();
}

class UpdateUserProfile extends ProfileManageEvent {
  final Map<String, dynamic> userData;

  const UpdateUserProfile(this.userData);
}

class UpdateUserFeatures extends ProfileManageEvent {
  final List<String> features;

  const UpdateUserFeatures(this.features);
}

class ClearProfileData extends ProfileManageEvent {
  const ClearProfileData();
}

class CheckFeatureAccess extends ProfileManageEvent {
  final String featureName;

  const CheckFeatureAccess(this.featureName);
}

class LogOutEvent extends ProfileManageEvent {
  const LogOutEvent();
}

class UpdateProfileDetails extends ProfileManageEvent {
  final Map<String, dynamic> payload;

  const UpdateProfileDetails(this.payload);
}