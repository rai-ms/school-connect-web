import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/services/route_service/route_names.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/teacher/widgets/safety_card.dart';
import '../../../../../../../core/utils/app_global.dart';
import 'section_title.dart';

class SafetyItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const SafetyItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class SafetyDashboard extends StatelessWidget {
  const SafetyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = L;
    
    final safetyItems = [
      SafetyItem(
        title: s?.incidentReport ?? 'Incident Report',
        subtitle: s?.reportSafetyIncidents ?? 'Report safety incidents',
        icon: Icons.report_problem,
        color: AppColors.safetyOrange,
        route: RoutesName.incidentReport,
      ),
      SafetyItem(
        title: s?.counseling ?? 'Counseling',
        subtitle: s?.studentReferrals ?? 'Student referrals',
        icon: Icons.psychology,
        color: AppColors.safetyBlue,
        route: RoutesName.counselingReferral,
      ),
      SafetyItem(
        title: s?.emergencyAlert ?? 'Emergency Alert',
        subtitle: s?.sosImmediateHelp ?? 'SOS - Immediate help',
        icon: Icons.emergency,
        color: AppColors.safetyRed,
        route: RoutesName.emergencyAlerts,
      ),
      SafetyItem(
        title: s?.safetyLog ?? 'Safety Log',
        subtitle: s?.viewAllReports ?? 'View all reports',
        icon: Icons.security,
        color: AppColors.safetyGreen,
        route: RoutesName.safetyLog,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: s?.safetyAndCompliance ?? 'Safety & Compliance'),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
          children: safetyItems
            .map(
              (item) => SafetyCard(
                icon: item.icon,
                title: item.title,
                subtitle: item.subtitle,
                color: item.color,
                onTap: () {
                  context.pushNamed(item.route);
                },
              ),
            )
            .toList(),
        ),
      ],
    );
  }
}
