import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
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

  static final List<Map<String, dynamic>> _schools = [
    {
      'name': 'Global Academy',
      'students': 1250,
      'teachers': 85,
      'status': 'Active',
      'plan': 'Enterprise',
      'renewal': '2024-12-31',
    },
    {
      'name': 'Sunrise Public School',
      'students': 980,
      'teachers': 65,
      'status': 'Active',
      'plan': 'Pro',
      'renewal': '2024-11-15',
    },
    {
      'name': 'Central High School',
      'students': 750,
      'teachers': 45,
      'status': 'Trial',
      'plan': 'Basic',
      'renewal': '2024-10-01',
    },
  ];

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

  final List<Map<String, dynamic>> _recentActivities = [
    {
      'title': 'New School Registered',
      'description': 'Sunshine International School has been registered',
      'time': '2 hours ago',
      'icon': Icons.school,
      'color': AppColors.greenCyan,
      'action': () {},
    },
    {
      'title': 'Plan Upgraded',
      'description': 'Global Academy upgraded to Enterprise plan',
      'time': '1 day ago',
      'icon': Icons.upgrade,
      'color': AppColors.selectiveYellow,
      'action': () {},
    },
    {
      'title': 'Payment Received',
      'description': 'Payment received from Central High School',
      'time': '2 days ago',
      'icon': Icons.payment,
      'color': AppColors.kuCrimson,
      'action': () {},
    },
    {
      'title': 'New Admin Added',
      'description': 'John Doe added as admin to Central High School',
      'time': '3 days ago',
      'icon': Icons.person_add,
      'color': AppColors.blueColor,
      'action': () {},
    },
    {
      'title': 'Security Alert',
      'description': 'Unusual login attempt detected',
      'time': '1 week ago',
      'icon': Icons.security,
      'color': AppColors.safetyRed,
      'action': () {},
    },
  ];

  // Analytics data
  final Map<String, dynamic> _analyticsData = {
    'totalRevenue': 45230,
    'activeUsers': 3245,
    'newSignups': 128,
    'activeSchools': _schools.where((s) => s['status'] == 'Active').length,
    'trialSchools': _schools.where((s) => s['status'] == 'Trial').length,
    'revenueData': [12000, 19000, 15000, 25000, 22000, 30000, 45230],
    'userGrowth': [500, 800, 1200, 1500, 2000, 2500, 3245],
  };

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
    Log.d("TAPPPED");
    context.pushNamed(RoutesName.addSchool);
    // switch (action) {
    //   case 'Add School':
    //     context.pushNamed(RoutesName.addSchool);
    //     break;
    //   case 'Manage Admins':
    //     // TODO: Implement manage admins
    //     break;
    //   case 'Analytics':
    //     // TODO: Implement analytics
    //     break;
    //   case 'Billing':
    //     // TODO: Implement billing
    //     break;
    //   case 'Announcements':
    //     // TODO: Implement announcements
    //     break;
    //   case 'Security':
    //     // TODO: Implement security
    //     break;
    //   case 'API Keys':
    //     // TODO: Implement API keys
    //     break;
    //   case 'Settings':
    //     // TODO: Implement settings
    //     break;
    // }
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
    return ListView.separated(
      shrinkWrap: true,
      padding: AppPadding.z,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _schools.length,
      separatorBuilder: (_, __) => Space.h12,
      itemBuilder: (context, index) {
        final school = _schools[index];
        return _buildSchoolCard(school, theme);
      },
    );
  }

  Widget _buildSchoolCard(Map<String, dynamic> school, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        // Navigate to school details
        _showSchoolDetails(school);
      },
      child: GlassyBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  school['name'],
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.chineseBlack,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: school['status'] == 'Active'
                        ? AppColors.greenCyan.withValues(alpha: 0.1)
                        : AppColors.selectiveYellow.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    school['status'],
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: school['status'] == 'Active'
                          ? AppColors.greenCyan
                          : AppColors.selectiveYellow,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Space.h12,
            Row(
              children: [
                _buildSchoolStat(
                  '${school['students']}',
                  'Students',
                  Icons.people,
                  theme,
                ),
                Space.w20,
                _buildSchoolStat(
                  '${school['teachers']}',
                  'Teachers',
                  Icons.person,
                  theme,
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit School'),
                    ),
                    const PopupMenuItem(
                      value: 'manage',
                      child: Text('Manage Access'),
                    ),
                    const PopupMenuItem(
                      value: 'view',
                      child: Text('View Details'),
                    ),
                  ],
                  onSelected: (String value) {
                    // Handle menu item selection
                  },
                  child: const Icon(
                    Icons.more_vert,
                    color: AppColors.darkElectricBlue,
                  ),
                ),
              ],
            ),
            Space.h12,
            const Divider(color: AppColors.gainsboro),
            Space.h8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Plan: ${school['plan']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.darkElectricBlue,
                  ),
                ),
                Text(
                  'Renewal: ${school['renewal']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.darkElectricBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolStat(
    String value,
    String label,
    IconData icon,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.darkElectricBlue),
        Space.w4,
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.chineseBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        Space.w4,
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.darkElectricBlue,
          ),
        ),
      ],
    );
  }

  void _showSchoolDetails(Map<String, dynamic> school) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  school['name'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: school['status'] == 'Active'
                        ? AppColors.greenCyan.withValues(alpha: 0.1)
                        : AppColors.selectiveYellow.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    school['status'],
                    style: TextStyle(
                      color: school['status'] == 'Active'
                          ? AppColors.greenCyan
                          : AppColors.selectiveYellow,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Plan', school['plan']),
            const SizedBox(height: 12),
            _buildDetailRow('Renewal Date', school['renewal']),
            const SizedBox(height: 12),
            _buildDetailRow('Students', '${school['students']}'),
            const SizedBox(height: 12),
            _buildDetailRow('Teachers', '${school['teachers']}'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement edit functionality
                  Navigator.pop(context);
                  _showEditSchoolDialog(school);
                },
                child: const Text('Edit School'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  void _showEditSchoolDialog(Map<String, dynamic> school) {
    final nameController = TextEditingController(text: school['name']);
    final renewalController = TextEditingController(text: school['renewal']);
    String selectedPlan = school['plan'];
    String selectedStatus = school['status'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit School'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'School Name'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ['Active', 'Trial', 'Suspended']
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedPlan,
                  decoration: const InputDecoration(labelText: 'Plan'),
                  items: ['Basic', 'Pro', 'Enterprise']
                      .map(
                        (plan) =>
                            DropdownMenuItem(value: plan, child: Text(plan)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPlan = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: renewalController,
                  decoration: const InputDecoration(
                    labelText: 'Renewal Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      renewalController.text =
                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle delete
                Navigator.pop(context);
                _confirmDeleteSchool(school);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle save
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('School updated successfully')),
                );
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteSchool(Map<String, dynamic> school) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete School'),
        content: Text(
          'Are you sure you want to delete ${school['name']}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _schools.remove(school);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${school['name']} has been deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(ThemeData theme) {
    return GlassyBackground(
      child: Column(
        children: [
          for (var activity in _recentActivities) ...[
            _buildActivityItem(
              activity['title'],
              activity['description'],
              activity['time'],
              activity['icon'],
              activity['color'],
              theme,
            ),
            if (activity != _recentActivities.last) ...[
              Space.h8,
              Container(height: 1, color: AppColors.blackColor),
              Space.h8,
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
    ThemeData theme, {
    VoidCallback? onTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: AppPadding.padA8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        Space.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.chineseBlack,
                ),
              ),
              Space.h4,
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.darkElectricBlue,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.romanSilver,
          ),
        ),
      ],
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
        TextButton(
          onPressed: () {
            // Handle view all
            if (title == 'Recent Activities') {
              _showAllActivities(theme);
            } else if (title == 'Manage Schools') {
              // Navigate to schools list
            }
          },
          child: const Text('View All'),
        ),
      ],
    );
  }

  void _showAllActivities(ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Activities',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount:
                      _recentActivities.length + 5, // Add more items for demo
                  separatorBuilder: (_, __) => const Divider(height: 32),
                  itemBuilder: (context, index) {
                    final activity =
                        _recentActivities[index % _recentActivities.length];
                    return _buildActivityItem(
                      activity['title'],
                      activity['description'],
                      '${index + 1} day${index > 0 ? 's' : ''} ago',
                      activity['icon'],
                      activity['color'],
                      theme,
                      onTap: activity['action'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
