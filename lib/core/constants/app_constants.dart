/// Application constants
class AppConstants {
  const AppConstants._();

  // App Info
  static const String appName = 'School Connect';
  static const String appVersion = '1.0.0';

  // Deep Link Schemes
  static const String deepLinkScheme = 'schoolconnect';
  static const String deepLinkHost = 'schoolconnect.app';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Notification
  static const String notificationChannelId = 'school_connect_notifications';
  static const String notificationChannelName = 'School Connect Notifications';
  static const String notificationChannelDescription =
      'Notifications for school updates, announcements, and alerts';
}

/// Firebase Messaging Constants
class FirebaseMsgConst {
  const FirebaseMsgConst._();

  static const String topicSubscribed = 'topic_subscribed';
  static const String topicUnSubscribed = 'topic_unsubscribed';
  static const String userTopicPrefix = 'user_';
  static const String schoolConnectTopic = 'school_connect_app';
  static const String additionalDataKey = 'additional_data';
  static const String notificationGroupKey = 'notification_group';
  static const String notificationChannelIdKey = 'notification';
  static const String notificationChannelNameKey = 'Notification';
  static const String deepLinkKey = 'deep_link';
  static const String typeKey = 'type';
  static const String schoolIdKey = 'school_id';
  static const String studentIdKey = 'student_id';
  static const String classIdKey = 'class_id';
}

/// Notification Types
class NotificationTypes {
  const NotificationTypes._();

  static const String announcement = 'announcement';
  static const String attendance = 'attendance';
  static const String feeReminder = 'fee_reminder';
  static const String examResult = 'exam_result';
  static const String homework = 'homework';
  static const String event = 'event';
  static const String general = 'general';
}
