

import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/parent/widgets/child_attendance.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/parent/widgets/child_performance.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/parent/widgets/upcoming_events.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/section_title.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/parent/widgets/quick_actions.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/safety_dashboard.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/recent_activity.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';
import '../../../../../../generated/generated_images.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.bg3),
            fit: BoxFit.cover,
          ),
        ),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: SafeArea(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Header with Glass Effect
                        GlassyBackground(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${L!.welcomeBack}, Parent',
                                style: AppStyles.large28.extraBold.white,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Here\'s what\'s happening with your child',
                                style: AppStyles.medium.normal.white,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Child Attendance
                        const SectionTitle(title: 'Child Attendance'),
                        const SizedBox(height: 12),
                        const ChildAttendance(),
                        const SizedBox(height: 24),

                        // Child Performance
                        const SectionTitle(title: 'Performance Overview'),
                        const SizedBox(height: 12),
                        const ChildPerformance(),
                        const SizedBox(height: 24),

                        // Upcoming Events
                        const SectionTitle(title: 'Upcoming Events'),
                        const SizedBox(height: 12),
                        const UpcomingEvents(),
                        const SizedBox(height: 24),

                        // Quick Actions
                        const SectionTitle(title: 'Quick Actions'),
                        const SizedBox(height: 12),
                        const ParentQuickActions(),
                        const SizedBox(height: 24),

                        // Recent Activity
                        const SectionTitle(title: 'Recent Activity'),
                        const SizedBox(height: 12),
                        const RecentActivity(),
                        const SizedBox(height: 24),

                        // Safety & Compliance
                        const SafetyDashboard(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
