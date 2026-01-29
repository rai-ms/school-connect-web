part of 'notification_bloc.dart';

class NotificationState extends BlocEventState<List<NotificationResponse>> {
  final List<NotificationResponse> notifications;
  final List<NotificationResponse> unreadNotifications;
  final int unreadCount;

  const NotificationState({
    super.state,
    super.data,
    super.error,
    super.event,
    super.statusCode,
    this.notifications = const [],
    this.unreadNotifications = const [],
    this.unreadCount = 0,
  });

  @override
  NotificationState copyWith({
    BlocState? state,
    List<NotificationResponse>? data,
    String? error,
    BlocEvent? event,
    int? statusCode,
    List<NotificationResponse>? notifications,
    List<NotificationResponse>? unreadNotifications,
    int? unreadCount,
  }) {
    return NotificationState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
      event: event ?? this.event,
      statusCode: statusCode ?? this.statusCode,
      notifications: notifications ?? this.notifications,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  NotificationState clear({BlocState? state, BlocEvent? event}) =>
      NotificationState(state: state ?? super.state, event: event);
}
