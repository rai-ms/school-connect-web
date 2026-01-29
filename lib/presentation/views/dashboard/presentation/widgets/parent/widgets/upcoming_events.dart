import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_style.dart';
import '../../../../../../widgets/gradient/glassy_background.dart';
import '../../../../../../views/notification/presentation/manager/notification_bloc/notification_bloc.dart';
import '../../../../../../views/notification/data/models/notification_model.dart';

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state.isLoading && state.notifications.isEmpty) {
          return GlassyBackground(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: CircularProgressIndicator(
                  color: AppColors.blueColor,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }

        if (state.isFailed && state.notifications.isEmpty) {
          return GlassyBackground(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.greyColor, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Could not load notifications',
                      style: AppStyles.regular.normal.greyColor,
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: [
                    const Icon(Icons.notifications_none,
                        color: AppColors.greyColor, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'No recent notifications',
                      style: AppStyles.regular.normal.greyColor,
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
            children: [
              for (int i = 0; i < recentNotifications.length; i++) ...[
                _buildEventItem(
                  recentNotifications[i],
                  context,
                ),
                if (i < recentNotifications.length - 1)
                  Container(
                    height: 2,
                    color: AppColors.greyColor,
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventItem(
      NotificationResponse notification, BuildContext context) {
    final typeInfo = _getTypeInfo(notification.notificationType);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: typeInfo.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(typeInfo.icon, color: typeInfo.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppStyles.large.medium.greyColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  notification.timeAgo,
                  style: AppStyles.semiMedium.medium.greyColor,
                ),
              ],
            ),
          ),
          if (!notification.isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.blueColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  _NotificationTypeInfo _getTypeInfo(String type) {
    switch (type) {
      case 'FEE_REMINDER':
        return _NotificationTypeInfo(Icons.payment, Colors.orange);
      case 'ATTENDANCE_ALERT':
        return _NotificationTypeInfo(Icons.fact_check, Colors.red);
      case 'EXAM_NOTICE':
        return _NotificationTypeInfo(Icons.school, Colors.blue);
      case 'ANNOUNCEMENT':
        return _NotificationTypeInfo(Icons.campaign, Colors.green);
      case 'LEAVE_STATUS':
        return _NotificationTypeInfo(Icons.event_available, Colors.teal);
      case 'TIMETABLE_CHANGE':
        return _NotificationTypeInfo(Icons.schedule, Colors.purple);
      case 'RESULT_PUBLISHED':
        return _NotificationTypeInfo(Icons.grade, Colors.amber);
      default:
        return _NotificationTypeInfo(Icons.notifications, Colors.blue);
    }
  }
}

class _NotificationTypeInfo {
  final IconData icon;
  final Color color;

  _NotificationTypeInfo(this.icon, this.color);
}
