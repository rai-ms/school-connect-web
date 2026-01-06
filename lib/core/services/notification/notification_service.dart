import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../base/logger/app_logger_impl.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Firebase Messaging instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Stream controller for notification stream
  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();

  // Getter for message stream
  Stream<RemoteMessage> get onMessageStream => _messageStreamController.stream;

  // Notification channel key
  static const String channelKey = 'basic_channel';
  static const String channelName = 'Basic notifications';
  static const String channelDescription =
      'Notification channel for basic tests';

  /// Initialize the notification service
  static Future<void> initialize() async {
    try {
      await _initializeAwesomeNotifications();
      await _initializeFirebaseMessaging();
    } catch (e) {
      Log.e('Error initializing notification service: $e');
      rethrow;
    }
  }

  /// Initialize Awesome Notifications
  static Future<void> _initializeAwesomeNotifications() async {
    try {
      await AwesomeNotifications().initialize(
        null, // Use default icon if null
        [
          NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: channelKey,
            channelName: channelName,
            channelDescription: channelDescription,
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            onlyAlertOnce: true,
            playSound: true,
            criticalAlerts: true,
          ),
        ],
        channelGroups: [
          NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group',
          ),
        ],
        debug: kDebugMode,
      );

      // Request notification permissions
      await AwesomeNotifications().isNotificationAllowed().then((
        isAllowed,
      ) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
    } catch (e) {
      Log.e('Error initializing Awesome Notifications: $e');
      rethrow;
    }
  }

  /// Initialize Firebase Messaging
  static Future<void> _initializeFirebaseMessaging() async {
    try {
      // Request notification permissions
      await _requestNotificationPermissions();

      // Get FCM token
      // final fcmToken = await FirebaseMessaging.instance.getToken();
      // Log.d('FCM Token: $fcmToken');

      // Handle token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        Log.d('FCM Token refreshed: $newToken');
        // TODO: Send the new token to your server
      });

      // Listen for FCM messages when the app is in the foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        Log.d('Got a message whilst in the foreground!');
        Log.d('Message data: ${message.data}');
        _instance._messageStreamController.add(message);
        _handleFcmMessage(message);
      });

      // Handle when the app is in the background but opened from a notification
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        Log.d('Message opened from background: ${message.messageId}');
        _instance._messageStreamController.add(message);
      });

      // Handle initial message when the app is opened from a terminated state
      RemoteMessage? initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        Log.d(
          'App opened from terminated state with message: ${initialMessage.messageId}',
        );
        _instance._messageStreamController.add(initialMessage);
      }
    } catch (e) {
      Log.e('Error initializing Firebase Messaging: $e');
      rethrow;
    }
  }

  /// Request notification permissions
  static Future<void> _requestNotificationPermissions() async {
    try {
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: true,
            provisional: false,
            sound: true,
          );

      Log.d('User granted permission: ${settings.authorizationStatus}');
    } catch (e) {
      Log.e('Error requesting notification permissions: $e');
      rethrow;
    }
  }

  /// Handle incoming FCM messages
  static Future<void> _handleFcmMessage(RemoteMessage message) async {
    try {
      Log.d('Message data: ${message.toMap()}');

      if (message.notification != null) {
        await _showNotification(
          title: message.notification?.title ?? 'New Notification',
          body: message.notification?.body ?? '',
          payload: message.data,
          notification: message.notification,
        );
      }
    } catch (e) {
      Log.e('Error handling FCM message: $e');
      rethrow;
    }
  }

  static Future<void> _showNotification({
    required String title,
    required String body,
    RemoteNotification? notification,
    Map<String, dynamic>? payload,
  }) async {
    try {
      Log.d("Notification payload is $payload");
      Log.d("Notification body is $body");
      Log.d("Notification title is $title");

      // Create a unique ID for the notification
      final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Extract image URL from payload if available
      String? imageUrl =
          notification?.android?.imageUrl ?? notification?.apple?.imageUrl;
      Log.d("Image content is $imageUrl");
      // Create notification content
      final notificationContent = NotificationContent(
        id: notificationId,
        channelKey: channelKey,
        title: title,
        body: body,
        payload: payload?.map((key, value) => MapEntry(key, value.toString())),
        notificationLayout: imageUrl != null
            ? NotificationLayout.BigPicture
            : NotificationLayout.Default,
        bigPicture: imageUrl,
        actionType: ActionType.KeepOnTop,
        category: NotificationCategory.Reminder,
        displayOnBackground: true,
        displayOnForeground: true,
        wakeUpScreen: true,
        autoDismissible: true,
        backgroundColor: const Color(0xFF9D50DD),
        color: Colors.white,
        roundedBigPicture: true,
        largeIcon: imageUrl,
      );

      // Show the notification
      await AwesomeNotifications().createNotification(
        content: notificationContent,
      );

      Log.d('Notification shown: $title - $body');
    } catch (e) {
      Log.e('Error showing notification: $e');
    }
  }

  /// Get the FCM token
  static Future<String?> getFcmToken() async {
    return null;

    // return await FirebaseMessaging.instance.getToken();
  }

  /// Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _instance._firebaseMessaging.subscribeToTopic(topic);
      Log.d('Subscribed to topic: $topic');
    } catch (e) {
      Log.e('Error subscribing to topic $topic: $e');
      rethrow;
    }
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _instance._firebaseMessaging.unsubscribeFromTopic(topic);
      Log.d('Unsubscribed from topic: $topic');
    } catch (e) {
      Log.e('Error unsubscribing from topic $topic: $e');
      rethrow;
    }
  }

  /// Delete the FCM token
  static Future<void> deleteFcmToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      await _instance._firebaseMessaging.deleteToken();
      Log.d('FCM token deleted');
    } catch (e) {
      Log.e('Error deleting FCM token: $e');
      rethrow;
    }
  }
}
