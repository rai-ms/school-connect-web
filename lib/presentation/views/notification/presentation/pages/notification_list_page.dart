import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';

import '../../data/models/notification_model.dart';
import '../manager/notification_bloc/notification_bloc.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const FetchNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundImageColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundImageColor,
        title: Text('Notifications', style: AppStyles.large.bold.white),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state.unreadCount > 0) {
                return TextButton(
                  onPressed: () => context
                      .read<NotificationBloc>()
                      .add(const MarkAllNotificationsRead()),
                  child: Text('Mark all read',
                      style: AppStyles.extraSmall.semiBold
                          .colored(AppColors.safetyBlue)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.isLoading && state.notifications.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.safetyBlue),
            );
          }

          if (state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 64,
                      color: AppColors.greyColor.withValues(alpha: 0.5)),
                  Space.h16,
                  Text('No notifications',
                      style: AppStyles.medium.regular.greyColor),
                  Space.h4,
                  Text("You're all caught up!",
                      style: AppStyles.small.regular
                          .colored(AppColors.safetyGreen)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<NotificationBloc>()
                  .add(const FetchNotifications());
            },
            child: ListView.builder(
              padding: AppPadding.padA16,
              itemCount: state.notifications.length,
              itemBuilder: (context, index) =>
                  _buildNotificationCard(state.notifications[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationResponse notification) {
    final typeInfo = _getTypeInfo(notification.notificationType);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            context
                .read<NotificationBloc>()
                .add(MarkNotificationRead(notification.id));
          }
        },
        child: GlassyBackground(
          borderColor: notification.isRead
              ? AppColors.whiteColor.withValues(alpha: 0.05)
              : typeInfo.color.withValues(alpha: 0.3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: typeInfo.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(typeInfo.icon,
                    size: 20, color: typeInfo.color),
              ),
              Space.w12,
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: notification.isRead
                                ? AppStyles.semiMedium.regular.greyColor
                                : AppStyles.semiMedium.semiBold.white,
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                              color: AppColors.safetyBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    Space.h4,
                    Text(
                      notification.body,
                      style: AppStyles.small.regular.greyColor,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Space.h8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (notification.senderName != null)
                          Row(
                            children: [
                              Icon(Icons.person_outline,
                                  size: 12, color: AppColors.safetyLightBlue),
                              Space.w4,
                              Text(notification.senderName!,
                                  style: AppStyles.extraSmall.regular
                                      .colored(AppColors.safetyLightBlue)),
                            ],
                          ),
                        Text(
                          notification.timeAgo,
                          style: AppStyles.extraSmall.regular.greyColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _NotificationTypeInfo _getTypeInfo(String type) {
    switch (type) {
      case 'FEE_REMINDER':
        return _NotificationTypeInfo(
            Icons.payment, AppColors.safetyOrange);
      case 'ATTENDANCE_ALERT':
        return _NotificationTypeInfo(
            Icons.fact_check, AppColors.safetyLightRed);
      case 'EXAM_NOTICE':
        return _NotificationTypeInfo(
            Icons.school, AppColors.safetyBlue);
      case 'ANNOUNCEMENT':
        return _NotificationTypeInfo(
            Icons.campaign, AppColors.safetyGreen);
      case 'LEAVE_STATUS':
        return _NotificationTypeInfo(
            Icons.event_available, AppColors.verdigris);
      case 'TIMETABLE_CHANGE':
        return _NotificationTypeInfo(
            Icons.schedule, AppColors.purple);
      case 'RESULT_PUBLISHED':
        return _NotificationTypeInfo(
            Icons.grade, AppColors.selectiveYellow);
      default:
        return _NotificationTypeInfo(
            Icons.notifications, AppColors.safetyBlue);
    }
  }
}

class _NotificationTypeInfo {
  final IconData icon;
  final Color color;

  _NotificationTypeInfo(this.icon, this.color);
}
