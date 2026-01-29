import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/views/dashboard/data/models/res/profile_response.dart';
import 'package:student_management/presentation/views/dashboard/presentation/manager/profile_management_bloc/profile_management_bloc.dart';
import 'package:student_management/presentation/widgets/customs/toast.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _avatarUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileManageBloc>().state.profile;
    if (profile != null) {
      _firstNameController.text = profile.firstName ?? '';
      _lastNameController.text = profile.lastName ?? '';
      _phoneController.text = profile.phone ?? '';
      _avatarUrlController.text = profile.avatarUrl?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final payload = <String, dynamic>{
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'phone': _phoneController.text.trim(),
    };

    final avatarUrl = _avatarUrlController.text.trim();
    if (avatarUrl.isNotEmpty) {
      payload['avatarUrl'] = avatarUrl;
    }

    context.read<ProfileManageBloc>().add(UpdateProfileDetails(payload));
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppStyles.semiMedium.regular.greyColor,
      prefixIcon: Icon(icon, color: AppColors.greenCyan, size: 20),
      filled: true,
      fillColor: AppColors.whiteColor.withValues(alpha: 0.08),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.whiteColor.withValues(alpha: 0.2),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.whiteColor.withValues(alpha: 0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.greenCyan),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.safetyRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.safetyRed),
      ),
      errorStyle: AppStyles.small.regular.copyWith(color: AppColors.safetyRed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Edit Profile', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        elevation: 0,
      ),
      body: BlocConsumer<ProfileManageBloc, ProfileManageState>(
        listenWhen: (previous, current) =>
            current.event is UpdateProfileDetails,
        listener: (context, state) {
          if (state.isSuccess && state.profileUpdateMessage != null) {
            context.snackBar(
              message: state.profileUpdateMessage!,
              backgroundColor: AppColors.greenCyan,
            );
            context.pop();
          } else if (state.isFailed && state.error != null) {
            context.snackBar(message: state.error!);
          }
        },
        builder: (context, state) {
          final isLoading =
              state.isLoading && state.event is UpdateProfileDetails;

          return SingleChildScrollView(
            padding: AppPadding.padA16,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Header
                  _buildProfileAvatar(state.profile),
                  Space.h24,

                  // Form Fields
                  GlassyBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: AppStyles.semiMedium.bold.white,
                        ),
                        Space.h16,
                        TextFormField(
                          controller: _firstNameController,
                          style: AppStyles.semiMedium.medium.white,
                          decoration: _inputDecoration(
                            label: 'First Name',
                            icon: Icons.person_outline,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'First name is required';
                            }
                            if (value.trim().length > 100) {
                              return 'First name must be 100 characters or less';
                            }
                            return null;
                          },
                        ),
                        Space.h16,
                        TextFormField(
                          controller: _lastNameController,
                          style: AppStyles.semiMedium.medium.white,
                          decoration: _inputDecoration(
                            label: 'Last Name',
                            icon: Icons.person_outline,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Last name is required';
                            }
                            if (value.trim().length > 100) {
                              return 'Last name must be 100 characters or less';
                            }
                            return null;
                          },
                        ),
                        Space.h16,
                        TextFormField(
                          controller: _phoneController,
                          style: AppStyles.semiMedium.medium.white,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration(
                            label: 'Phone Number',
                            icon: Icons.phone_outlined,
                          ),
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
                              if (!phoneRegex.hasMatch(value.trim())) {
                                return 'Enter a valid phone number (10-15 digits)';
                              }
                            }
                            return null;
                          },
                        ),
                        Space.h16,
                        TextFormField(
                          controller: _avatarUrlController,
                          style: AppStyles.semiMedium.medium.white,
                          keyboardType: TextInputType.url,
                          decoration: _inputDecoration(
                            label: 'Avatar URL',
                            icon: Icons.image_outlined,
                          ),
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              final uri = Uri.tryParse(value.trim());
                              if (uri == null || !uri.hasScheme) {
                                return 'Enter a valid URL';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Space.h24,

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenCyan,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor:
                            AppColors.greenCyan.withValues(alpha: 0.5),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.whiteColor,
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: AppStyles.semiMedium.semiBold.white,
                            ),
                    ),
                  ),
                  Space.h12,

                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isLoading ? null : () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: AppColors.whiteColor.withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppStyles.semiMedium.medium.greyColor,
                      ),
                    ),
                  ),
                  Space.h30,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(ProfileResponse? profile) {
    final displayName = profile?.fullName ??
        '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}'.trim();
    final initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: AppColors.myrtleGreen,
          child: Text(
            initial,
            style: AppStyles.large32.bold.white,
          ),
        ),
        Space.h12,
        Text(
          'Update your profile information',
          style: AppStyles.semiMedium.regular.greyColor,
        ),
      ],
    );
  }
}
