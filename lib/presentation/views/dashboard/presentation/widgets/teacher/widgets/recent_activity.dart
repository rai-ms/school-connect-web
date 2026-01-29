import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/presentation/views/notification/presentation/manager/notification_bloc/notification_bloc.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';
import 'activity_item.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state.isLoading) {
          return GlassyBackground(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }

        if (state.isFailed) {
          return GlassyBackground(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,
                        color: AppColors.whiteColor, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load activity',
                      style: AppStyles.semiMedium.regular.white,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final notifications = state.notifications;

        if (notifications.isEmpty) {
          return GlassyBackground(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_outlined,
                        color: AppColors.whiteColor.withValues(alpha: 0.7),
                        size: 32),
                    const SizedBox(height: 8),
                    Text(
                      L?.noRecentActivity ?? 'No recent activity',
                      style: AppStyles.semiMedium.regular.white,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Show up to 5 most recent notifications
        final recentNotifications = notifications.take(5).toList();

        return GlassyBackground(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: recentNotifications.asMap().entries.map((entry) {
              final notification = entry.value;
              return ActivityItem(
                title: notification.title,
                time: notification.timeAgo,
                isLast: entry.key == recentNotifications.length - 1,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
