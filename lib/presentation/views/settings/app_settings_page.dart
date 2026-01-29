import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/services/theme_service/theme_service.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_enum.dart' show AppTheme;
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/views/dashboard/presentation/manager/profile_management_bloc/profile_management_bloc.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  late ThemeService _themeService;

  @override
  void initState() {
    super.initState();
    _themeService = InjectorService.service.inject<ThemeService>();
  }

  bool get _isDarkMode => _themeService.themeListener.value == AppTheme.dark;

  void _toggleDarkMode(bool value) {
    final newTheme = value ? AppTheme.dark : AppTheme.light;
    _themeService.updateTheme(newTheme);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Settings', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        elevation: 0,
      ),
      body: ListView(
        padding: AppPadding.padA16,
        children: [
          // Section 1 - Account
          _buildSectionHeader('Account'),
          Space.h8,
          GlassyBackground(
            child: Column(
              children: [
                _buildListTile(
                  icon: Icons.person,
                  title: 'My Profile',
                  onTap: () => context.push(RoutesName.profile),
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  onTap: () => context.push(RoutesName.changePassword),
                ),
              ],
            ),
          ),
          Space.h24,

          // Section 2 - Preferences
          _buildSectionHeader('Preferences'),
          Space.h8,
          GlassyBackground(
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  value: _isDarkMode,
                  onChanged: _toggleDarkMode,
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.language,
                  title: 'Language',
                  trailing: Text(
                    'English',
                    style: AppStyles.small.regular.greyColor,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Space.h24,

          // Section 3 - Notifications
          _buildSectionHeader('Notifications'),
          Space.h8,
          GlassyBackground(
            child: Column(
              children: [
                _buildSwitchTile(
                  icon: Icons.notifications,
                  title: 'Push Notifications',
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.email,
                  title: 'Email Notifications',
                  value: _emailNotifications,
                  onChanged: (val) => setState(() => _emailNotifications = val),
                ),
              ],
            ),
          ),
          Space.h24,

          // Section 4 - About
          _buildSectionHeader('About'),
          Space.h8,
          GlassyBackground(
            child: Column(
              children: [
                _buildListTile(
                  icon: Icons.info_outline,
                  title: 'App Version',
                  trailing: Text(
                    '1.0.0',
                    style: AppStyles.small.regular.greyColor,
                  ),
                  onTap: () {},
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.description,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
              ],
            ),
          ),
          Space.h24,

          // Section 5 - Danger Zone
          _buildSectionHeader('Danger Zone'),
          Space.h8,
          GlassyBackground(
            borderColor: AppColors.safetyRed.withValues(alpha: 0.3),
            child: _buildListTile(
              icon: Icons.logout,
              title: 'Logout',
              iconColor: AppColors.safetyRed,
              titleColor: AppColors.safetyRed,
              showChevron: false,
              onTap: () => _showLogoutDialog(context),
            ),
          ),
          Space.h30,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: AppStyles.semiMedium.bold.white),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    Color? iconColor,
    Color? titleColor,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.whiteColor.withValues(alpha: 0.7),
              size: 22,
            ),
            Space.w12,
            Expanded(
              child: Text(
                title,
                style: titleColor != null
                    ? AppStyles.semiMedium.medium.copyWith(color: titleColor)
                    : AppStyles.semiMedium.medium.white,
              ),
            ),
            if (trailing != null) trailing,
            if (showChevron)
              Icon(
                Icons.chevron_right,
                color: AppColors.whiteColor.withValues(alpha: 0.4),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.whiteColor.withValues(alpha: 0.7),
            size: 22,
          ),
          Space.w12,
          Expanded(
            child: Text(
              title,
              style: AppStyles.semiMedium.medium.white,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.greenCyan,
            inactiveThumbColor: AppColors.romanSilver,
            inactiveTrackColor: AppColors.whiteColor.withValues(alpha: 0.2),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.darkGunMetal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.whiteColor.withValues(alpha: 0.2),
          ),
        ),
        title: Text(
          'Logout',
          style: AppStyles.large.bold.white,
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppStyles.semiMedium.regular.greyColor,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: AppStyles.semiMedium.medium.greyColor,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ProfileManageBloc>().add(const LogOutEvent());
              context.go(RoutesName.loginScreen);
            },
            child: Text(
              'Logout',
              style: AppStyles.semiMedium.semiBold.copyWith(
                color: AppColors.safetyRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
