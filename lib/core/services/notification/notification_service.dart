import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../../base/base_service/base_service.dart';
import '../../base/logger/app_logger_impl.dart';
import '../../constants/app_constants.dart';
import '../deep_link_service/deep_link_service.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Log.d('Background notification received: ${message.data}');
  Log.d('Notification Title: ${message.notification?.title}');
  Log.d('Notification Body: ${message.notification?.body}');
}

/// Notification service for handling push notifications
@lazySingleton
class NotificationService extends BaseService<Future<void>, void> {
  final DeepLinkService _deepLinkService;

  NotificationService(this._deepLinkService);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final StreamController<Map<String, dynamic>> _notificationStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// Stream of notification data
  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationStreamController.stream;

  String? _fcmToken;

  /// Get FCM token
  String? get fcmToken => _fcmToken;

  @override
  Future<void> init({void param}) async {
    await _requestPermissions();
    await _initializeLocalNotifications();
    await _setupFirebaseMessaging();
    await _getFCMToken();
    Log.d('NotificationService initialized');
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    Log.d('Notification permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      Log.d('User granted notification permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Log.d('User granted provisional notification permission');
    } else {
      Log.w('User declined notification permission');
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  /// Create Android notification channel
  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDescription,
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Setup Firebase Messaging listeners
  Future<void> _setupFirebaseMessaging() async {
    // Set foreground notification presentation options
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle initial message (app opened from terminated state)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    Log.d('Foreground notification received');
    Log.d('Title: ${message.notification?.title}');
    Log.d('Body: ${message.notification?.body}');
    Log.d('Data: ${message.data}');

    // Show local notification
    _showLocalNotification(message);

    // Emit to stream
    _notificationStreamController.add({
      'title': message.notification?.title,
      'body': message.notification?.body,
      'data': message.data,
      'type': 'foreground',
    });
  }

  /// Handle message when app is opened from notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    Log.d('App opened from notification');
    Log.d('Data: ${message.data}');

    _notificationStreamController.add({
      'title': message.notification?.title,
      'body': message.notification?.body,
      'data': message.data,
      'type': 'opened',
    });

    // Use DeepLinkService for navigation
    _deepLinkService.handleNotificationTap(message.data);
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    Log.d('Notification tapped: ${response.payload}');

    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        // Use DeepLinkService for navigation
        _deepLinkService.handleNotificationTap(data);
      } catch (e) {
        Log.e('Failed to parse notification payload', error: e);
      }
    }
  }

  /// Get FCM token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      Log.d('FCM Token: $_fcmToken');

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((token) {
        _fcmToken = token;
        Log.d('FCM Token refreshed: $token');
        // TODO: Send new token to server
      });
    } catch (e) {
      Log.e('Failed to get FCM token', error: e);
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    Log.d('Subscribed to topic: $topic');
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    Log.d('Unsubscribed from topic: $topic');
  }

  /// Subscribe to user-specific topic
  Future<void> subscribeToUserTopic(String userId) async {
    await subscribeToTopic('${FirebaseMsgConst.userTopicPrefix}$userId');
  }

  /// Unsubscribe from user-specific topic
  Future<void> unsubscribeFromUserTopic(String userId) async {
    await unsubscribeFromTopic('${FirebaseMsgConst.userTopicPrefix}$userId');
  }

  /// Subscribe to app topic
  Future<void> subscribeToAppTopic() async {
    await subscribeToTopic(FirebaseMsgConst.schoolConnectTopic);
  }

  @override
  void dispose() {
    _notificationStreamController.close();
    super.dispose();
  }
}
