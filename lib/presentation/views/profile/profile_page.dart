import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/views/dashboard/data/models/res/profile_response.dart';
import 'package:student_management/presentation/views/dashboard/presentation/manager/profile_management_bloc/profile_management_bloc.dart';
import 'package:student_management/presentation/widgets/customs/toast.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('My Profile', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        elevation: 0,
      ),
      body: BlocBuilder<ProfileManageBloc, ProfileManageState>(
        builder: (context, state) {
          final profile = state.profile;
          final role = state.role;

          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.greenCyan,
              ),
            );
          }

          if (profile == null) {
            return Center(
              child: Text(
                'Profile data not available',
                style: AppStyles.medium.regular.greyColor,
              ),
            );
          }

          return SingleChildScrollView(
            padding: AppPadding.padA16,
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(profile, role),
                Space.h24,

                // Personal Info Section
                _buildSectionTitle('Personal Information'),
                Space.h12,
                _buildPersonalInfoCard(profile),
                Space.h24,

                // Account Info Section
                _buildSectionTitle('Account Information'),
                Space.h12,
                _buildAccountInfoCard(profile, role),
                Space.h30,

                // Action Buttons
                _buildActionButtons(context),
                Space.h30,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(ProfileResponse profile, dynamic role) {
    final displayName = profile.fullName ??
        '${profile.firstName ?? ''} ${profile.lastName ?? ''}'.trim();
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    final roleName = role?.toString() ?? 'User';

    return GlassyBackground(
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: AppColors.myrtleGreen,
            child: Text(
              initial,
              style: AppStyles.large32.bold.white,
            ),
          ),
          Space.h16,
          Text(
            displayName.isNotEmpty ? displayName : 'N/A',
            style: AppStyles.larger.bold.white,
          ),
          Space.h6,
          Text(
            profile.email ?? 'N/A',
            style: AppStyles.semiMedium.regular.greyColor,
          ),
          Space.h12,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.greenCyan.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.greenCyan.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              roleName,
              style: AppStyles.small.semiBold.greenCyan,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: AppStyles.semiMedium.bold.white),
    );
  }

  Widget _buildPersonalInfoCard(ProfileResponse profile) {
    final displayName = profile.fullName ??
        '${profile.firstName ?? ''} ${profile.lastName ?? ''}'.trim();

    return GlassyBackground(
      child: Column(
        children: [
          _buildInfoRow(Icons.person, 'Full Name', displayName.isNotEmpty ? displayName : 'N/A'),
          _buildDivider(),
          _buildInfoRow(Icons.email, 'Email', profile.email ?? 'N/A'),
          _buildDivider(),
          _buildInfoRow(Icons.phone, 'Phone', profile.phone ?? 'N/A'),
          _buildDivider(),
          _buildInfoRow(Icons.person_outline, 'Username', profile.username?.toString() ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildAccountInfoCard(ProfileResponse profile, dynamic role) {
    final roleName = role?.toString() ?? 'N/A';
    final statusText = profile.status ?? 'N/A';
    final emailVerified = profile.emailVerified == true ? 'Verified' : 'Not Verified';

    return GlassyBackground(
      child: Column(
        children: [
          _buildInfoRow(Icons.admin_panel_settings, 'Role', roleName),
          _buildDivider(),
          _buildInfoRow(Icons.fingerprint, 'User ID', profile.id ?? 'N/A'),
          _buildDivider(),
          _buildInfoRow(
            Icons.circle,
            'Account Status',
            statusText,
            valueColor: statusText.toLowerCase() == 'active'
                ? AppColors.safetyGreen
                : AppColors.safetyOrange,
          ),
          _buildDivider(),
          _buildInfoRow(
            Icons.verified_user,
            'Email Verified',
            emailVerified,
            valueColor: profile.emailVerified == true
                ? AppColors.safetyGreen
                : AppColors.safetyOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.whiteColor.withValues(alpha: 0.7), size: 20),
          Space.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyles.small.regular.copyWith(
                    color: AppColors.whiteColor.withValues(alpha: 0.6),
                  ),
                ),
                Space.h4,
                Text(
                  value,
                  style: valueColor != null
                      ? AppStyles.semiMedium.medium.copyWith(color: valueColor)
                      : AppStyles.semiMedium.medium.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.whiteColor.withValues(alpha: 0.1),
      height: 1,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Change Password Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.push(RoutesName.changePassword);
            },
            icon: const Icon(Icons.lock_outline, color: AppColors.whiteColor),
            label: Text('Change Password', style: AppStyles.semiMedium.semiBold.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.myrtleGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Space.h12,

        // Edit Profile Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              context.snackBar(message: 'Coming soon');
            },
            icon: Icon(Icons.edit, color: AppColors.greenCyan.withValues(alpha: 0.8)),
            label: Text(
              'Edit Profile',
              style: AppStyles.semiMedium.semiBold.greenCyan,
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(
                color: AppColors.greenCyan.withValues(alpha: 0.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
