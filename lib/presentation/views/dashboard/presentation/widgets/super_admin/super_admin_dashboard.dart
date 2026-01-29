import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_enum.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/core/utils/toast.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/super_admin/bloc/dashboard_bloc/super_admin_bloc.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../../../../../core/utils/app_style.dart';
import '../../manager/profile_management_bloc/profile_management_bloc.dart';
import 'build_stat_item.dart';

part 'super_admin_mixins.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key, required this.profileState});
  final ProfileManageState profileState;

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard>
    with _SuperAdminMixin<SuperAdminDashboard> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _quickActions = [
    {
      'icon': Icons.add_business,
      'label': 'Add School',
      'color': AppColors.greenCyan,
    },
    {
      'icon': Icons.people,
      'label': 'Manage Admins',
      'color': AppColors.kuCrimson,
    },
    {
      'icon': Icons.analytics,
      'label': 'Analytics',
      'color': AppColors.selectiveYellow,
    },
    {
      'icon': Icons.monetization_on,
      'label': 'Billing',
      'color': AppColors.purple,
    },
    {
      'icon': Icons.notifications,
      'label': 'Announcements',
      'color': AppColors.orange,
    },
    {'icon': Icons.security, 'label': 'Security', 'color': AppColors.safetyRed},
    {'icon': Icons.api, 'label': 'API Keys', 'color': AppColors.blueColor},
    {
      'icon': Icons.settings,
      'label': 'Settings',
      'color': AppColors.myrtleGreen,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    var profile = widget.profileState.profile;

    return BlocListener<ProfileManageBloc, ProfileManageState>(
      listener: _profileListner,
      child: Scaffold(
        backgroundColor: AppColors.ghostWhite,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: size.height * 0.18,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.darkGunMetal, AppColors.myrtleGreen],
                    ),
                  ),
                  padding: AppPadding.padSH24.copyWith(top: 16.v, bottom: 16.v),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GlassyBackground(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                                child: Text(
                                  '${profile?.primaryRole}',
                                  style: AppStyles.semiMedium.medium.white,
                                ),
                              ),
                              Text(
                                '${L!.welcomeBack}, ${profile?.firstName}',
                                style: AppStyles.large28.medium.white,
                              ),
                              Space.h4,
                              Text(
                                'Manage your schools and platform settings',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.whiteColor.withValues(
                                    alpha: 0.9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.read<ProfileManageBloc>().add(
                              LogOutEvent(),
                            );
                          },
                          child: GlassyBackground(
                            child: Icon(FontAwesomeIcons.arrowRightFromBracket),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: AppPadding.padA16,
                child:
                    BlocBuilder<
                      SuperAdminDashboardBloc,
                      SuperAdminDashboardState
                    >(
                      builder:
                          (
                            ctx,
                            SuperAdminDashboardState superAdminDashboardState,
                          ) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Quick Stats
                                _buildQuickStats(superAdminDashboardState),
                                Space.h24,

                                // Quick Actions
                                _buildSectionHeader('Quick Actions', theme),
                                _buildQuickActions(theme),
                                Space.h24,

                                // Schools List
                                _buildSectionHeader('Manage Schools', theme),
                                Space.h12,
                                _buildSchoolsList(theme),
                                Space.h24,

                                // Recent Activities
                                _buildSectionHeader('Recent Activities', theme),
                                Space.h12,
                                _buildRecentActivities(theme),
                                Space.h24,
                              ],
                            );
                          },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(SuperAdminDashboardState superAdminState) {
    final int totalOthers = superAdminState.totalOthers?.length ?? 0;
    final int totalStudents = superAdminState.totalStudents?.length ?? 0;
    final int totalTeachers = superAdminState.totalTeachers?.length ?? 0;
    final int totalUsers =
        superAdminState.allUsersResponse?.content?.length ?? 0;

    return GlassyBackground(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BuildStatItem(
            studentCount: totalStudents.toString(),
            label: 'Students',
            icon: Icons.people,
            color: AppColors.greenCyan,
          ),
          BuildStatItem(
            studentCount: totalTeachers.toString(),
            label: 'Teachers',
            icon: Icons.person,
            color: AppColors.selectiveYellow,
          ),
          BuildStatItem(
            studentCount: totalOthers.toString(),
            label: 'Others',
            icon: Icons.school,
            color: AppColors.kuCrimson,
          ),
          BuildStatItem(
            studentCount: totalUsers.toString(),
            label: 'Users',
            icon: Icons.person,
            color: AppColors.universityOfCaliforniaGold,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: _quickActions
          .map(
            (action) => _buildActionItem(
              action['icon'] as IconData,
              action['label'] as String,
              action['color'] as Color,
              theme,
              onTap: () => _handleQuickAction(action['label'] as String),
            ),
          )
          .toList(),
    );
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'Add School':
        context.pushNamed(RoutesName.addSchool);
        break;
      case 'Manage Admins':
        context.push(RoutesName.teacherList);
        break;
      case 'Analytics':
        context.push(RoutesName.reports);
        break;
      case 'Billing':
        context.push(RoutesName.feeDashboard);
        break;
      case 'Announcements':
        context.push(RoutesName.notifications);
        break;
      case 'Security':
        context.push(RoutesName.safetyLog);
        break;
      case 'Settings':
        context.push('/app-settings');
        break;
      default:
        break;
    }
  }

  Widget _buildActionItem(
    IconData icon,
    String label,
    Color color,
    ThemeData theme, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 170,
        width: 170,
        padding: AppPadding.padA12,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppPadding.padA12,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            Space.h8,
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.darkElectricBlue,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolsList(ThemeData theme) {
    // School/tenant list API is not yet available in the BLoC.
    // Show an empty state prompting to add a school.
    return GlassyBackground(
      child: Column(
        children: [
          Icon(
            Icons.school_outlined,
            size: 48,
            color: AppColors.darkElectricBlue.withValues(alpha: 0.5),
          ),
          Space.h12,
          Text(
            'No schools loaded',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.chineseBlack,
            ),
          ),
          Space.h4,
          Text(
            'School data will appear here once the tenant API is connected.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.darkElectricBlue,
            ),
          ),
          Space.h12,
          ElevatedButton.icon(
            onPressed: () => context.pushNamed(RoutesName.addSchool),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add School'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenCyan,
              foregroundColor: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildRecentActivities(ThemeData theme) {
    // Activity feed API is not yet available in the BLoC.
    // Show an empty state.
    return GlassyBackground(
      child: Column(
        children: [
          Icon(
            Icons.history_outlined,
            size: 48,
            color: AppColors.darkElectricBlue.withValues(alpha: 0.5),
          ),
          Space.h12,
          Text(
            'No recent activities',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.chineseBlack,
            ),
          ),
          Space.h4,
          Text(
            'Activity logs will appear here once available.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.darkElectricBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.chineseBlack,
          ),
        ),
      ],
    );
  }
}
