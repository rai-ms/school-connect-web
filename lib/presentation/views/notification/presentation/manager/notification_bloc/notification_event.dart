part of 'notification_bloc.dart';

class NotificationEvent extends BlocEvent {
  const NotificationEvent();
}

class FetchNotifications extends NotificationEvent {
  const FetchNotifications();
}

class FetchUnreadNotifications extends NotificationEvent {
  const FetchUnreadNotifications();
}

class FetchUnreadCount extends NotificationEvent {
  const FetchUnreadCount();
}

class MarkNotificationRead extends NotificationEvent {
  final String notificationId;
  const MarkNotificationRead(this.notificationId);
}

class MarkAllNotificationsRead extends NotificationEvent {
  const MarkAllNotificationsRead();
}

class SendNotification extends NotificationEvent {
  final SendNotificationRequest request;
  const SendNotification(this.request);
}
