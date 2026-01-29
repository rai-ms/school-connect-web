import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/my_app/data/model/response/tenant_settings_response.dart';
import 'package:student_management/presentation/my_app/presentation/manager/bloc/app_config_bloc/app_config_bloc.dart';
import 'package:student_management/presentation/widgets/customs/toast.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

class SchoolSettingsScreen extends StatefulWidget {
  const SchoolSettingsScreen({super.key});

  @override
  State<SchoolSettingsScreen> createState() => _SchoolSettingsScreenState();
}

class _SchoolSettingsScreenState extends State<SchoolSettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AppConfigBloc>().add(FetchTenantSettings());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('School Settings'),
        backgroundColor: AppColors.darkGunMetal,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
      ),
      backgroundColor: AppColors.ghostWhite,
      body: BlocConsumer<AppConfigBloc, AppConfigState>(
        listener: (context, state) {
          if (state.event is UpdateTenantSettings && state.state == state.success) {
            context.snackBar(
              message: 'Settings updated successfully',
              backgroundColor: AppColors.greenCyan,
            );
          }
        },
        builder: (context, state) {
          final settings = state.tenantSettings;

          if (settings == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: AppPadding.padA16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Branding Section
                _buildSectionTitle('Branding', theme),
                Space.h12,
                _buildBrandingSection(settings, theme),
                Space.h24,

                // Academic Settings
                _buildSectionTitle('Academic Settings', theme),
                Space.h12,
                _buildAcademicSection(settings, theme),
                Space.h24,

                // Feature Flags
                _buildSectionTitle('Modules & Features', theme),
                Space.h12,
                _buildFeatureFlagsSection(settings, theme),
                Space.h24,

                // Notification Settings
                _buildSectionTitle('Notifications', theme),
                Space.h12,
                _buildNotificationSection(settings, theme),
                Space.h24,

                // Locale Settings
                _buildSectionTitle('Locale & Format', theme),
                Space.h12,
                _buildLocaleSection(settings, theme),
                Space.h24,

                // Contact Settings
                _buildSectionTitle('Contact Information', theme),
                Space.h12,
                _buildContactSection(settings, theme),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.chineseBlack,
      ),
    );
  }

  Widget _buildBrandingSection(TenantSettingsResponse settings, ThemeData theme) {
    return GlassyBackground(
      child: Column(
        children: [
          _buildInfoTile(
            'School Name',
            settings.displayName ?? 'Not Set',
            Icons.school,
            theme,
          ),
          _buildDivider(),
          _buildInfoTile(
            'Tagline',
            settings.tagline ?? 'Not Set',
            Icons.format_quote,
            theme,
          ),
          _buildDivider(),
          _buildColorTile('Primary Color', settings.primaryColor ?? '#1E3A5F', theme),
          _buildDivider(),
          _buildColorTile('Secondary Color', settings.secondaryColor ?? '#4CAF50', theme),
          _buildDivider(),
          _buildColorTile('Accent Color', settings.accentColor ?? '#FFC107', theme),
        ],
      ),
    );
  }

  Widget _buildAcademicSection(TenantSettingsResponse settings, ThemeData theme) {
    return GlassyBackground(
      child: Column(
        children: [
          _buildInfoTile(
            'Grading System',
            settings.gradingSystem ?? 'PERCENTAGE',
            Icons.grade,
            theme,
          ),
          _buildDivider(),
          _buildInfoTile(
            'Passing Percentage',
            '${settings.passingPercentage ?? 33}%',
            Icons.check_circle,
            theme,
          ),
          _buildDivider(),
          _buildInfoTile(
            'Working Days',
            settings.defaultWorkingDays ?? 'MON-FRI',
            Icons.calendar_today,
            theme,
          ),
          _buildDivider(),
          _buildInfoTile(
            'School Hours',
            '${settings.schoolStartTime ?? "08:00"} - ${settings.schoolEndTime ?? "14:00"}',
            Icons.access_time,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureFlagsSection(TenantSettingsResponse settings, ThemeData theme) {
    return GlassyBackground(
      child: Column(
        children: [
          _buildToggleTile('Attendance', settings.attendanceEnabled ?? true, Icons.how_to_reg, theme,
              onChanged: (val) => _updateFeature('attendanceEnabled', val)),
          _buildDivider(),
          _buildToggleTile('Fee Management', settings.feesEnabled ?? true, Icons.payment, theme,
              onChanged: (val) => _updateFeature('feesEnabled', val)),
          _buildDivider(),
          _buildToggleTile('Exams & Grades', settings.examsEnabled ?? true, Icons.quiz, theme,
              onChanged: (val) => _updateFeature('examsEnabled', val)),
          _buildDivider(),
          _buildToggleTile('Timetable', settings.timetableEnabled ?? true, Icons.schedule, theme,
              onChanged: (val) => _updateFeature('timetableEnabled', val)),
          _buildDivider(),
          _buildToggleTile('Library', settings.libraryEnabled ?? false, Icons.local_library, theme,
              onChanged: (val) => _updateFeature('libraryEnabled', val)),
          _buildDivider(),
          _buildToggleTile('Transport', settings.transportEnabled ?? false, Icons.directions_bus, theme,
              onChanged: (val) => _updateFeature('transportEnabled', val)),
          _buildDivider(),
          _buildToggleTile('Hostel', settings.hostelEnabled ?? false, Icons.hotel, theme,
              onChanged: (val) => _updateFeature('hostelEnabled', val)),
          _buildDivider(),
          _buildToggleTile('Parent Portal', settings.parentPortalEnabled ?? true, Icons.family_restroom, theme,
              onChanged: (val) => _updateFeature('parentPortalEnabled', val)),
          _buildDivider(),
          _buildToggleTile('Student Portal', settings.studentPortalEnabled ?? true, Icons.person, theme,
              onChanged: (val) => _updateFeature('studentPortalEnabled', val)),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(TenantSettingsResponse settings, ThemeData theme) {
    return GlassyBackground(
      child: Column(
        children: [
          _buildToggleTile('Push Notifications', settings.pushNotificationsEnabled ?? true,
              Icons.notifications, theme,
              onChanged: (val) => _updateFeature('pushNotificationsEnabled', val)),
          _buildDivider(),
          _buildToggleTile('Email Notifications', settings.emailNotificationsEnabled ?? true,
              Icons.email, theme,
              onChanged: (val) => _updateFeature('emailNotificationsEnabled', val)),
          _buildDivider(),
          _buildToggleTile('SMS Notifications', settings.smsNotificationsEnabled ?? false,
              Icons.sms, theme,
              onChanged: (val) => _updateFeature('smsNotificationsEnabled', val)),
        ],
      ),
    );
  }

  Widget _buildLocaleSection(TenantSettingsResponse settings, ThemeData theme) {
    return GlassyBackground(
      child: Column(
        children: [
          _buildInfoTile(
            'Timezone',
            settings.timezone ?? 'Asia/Kolkata',
            Icons.language,
            theme,
          ),
          _buildDivider(),
          _buildInfoTile(
            'Date Format',
            settings.dateFormat ?? 'dd/MM/yyyy',
            Icons.date_range,
            theme,
          ),
          _buildDivider(),
          _buildInfoTile(
            'Currency',
            settings.currency ?? 'INR',
            Icons.currency_rupee,
            theme,
          ),
          _buildDivider(),
          _buildInfoTile(
            'Language',
            settings.language ?? 'en',
            Icons.translate,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(TenantSettingsResponse settings, ThemeData theme) {
    return GlassyBackground(
      child: Column(
        children: [
          _buildInfoTile(
            'Support Email',
            settings.supportEmail ?? 'Not Set',
            Icons.email,
            theme,
          ),
          _buildDivider(),
          _buildInfoTile(
            'Support Phone',
            settings.supportPhone ?? 'Not Set',
            Icons.phone,
            theme,
          ),
          _buildDivider(),
          _buildInfoTile(
            'Emergency Contact',
            settings.emergencyContact ?? 'Not Set',
            Icons.emergency,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.whiteColor, size: 20),
          Space.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.small.regular.copyWith(
                    color: AppColors.whiteColor.withValues(alpha: 0.7),
                  ),
                ),
                Space.h4,
                Text(
                  value,
                  style: AppStyles.medium.medium.white,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.whiteColor.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildColorTile(String title, String hexColor, ThemeData theme) {
    Color color;
    try {
      color = Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (_) {
      color = AppColors.blueColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.whiteColor, width: 2),
            ),
          ),
          Space.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.small.regular.copyWith(
                    color: AppColors.whiteColor.withValues(alpha: 0.7),
                  ),
                ),
                Space.h4,
                Text(
                  hexColor,
                  style: AppStyles.medium.medium.white,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.whiteColor.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile(
    String title,
    bool value,
    IconData icon,
    ThemeData theme, {
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.whiteColor, size: 20),
          Space.w12,
          Expanded(
            child: Text(
              title,
              style: AppStyles.medium.medium.white,
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

  void _updateFeature(String key, bool value) {
    context.read<AppConfigBloc>().add(
      UpdateTenantSettings({key: value}),
    );
  }
}
