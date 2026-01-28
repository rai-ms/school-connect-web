import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';

import '../../base/base_service/base_service.dart';
import '../../base/logger/app_logger_impl.dart';
import '../route_service/app_routing.dart';
import '../route_service/route_names.dart';

/// Deep link types for routing
enum DeepLinkType {
  /// Open home
  home,

  /// Open a specific school
  school,

  /// Open a specific class
  classRoom,

  /// Open a specific student
  student,

  /// Open attendance
  attendance,

  /// Open fees
  fees,

  /// Open announcements
  announcements,

  /// Open notifications
  notifications,

  /// Open settings
  settings,

  /// Open profile
  profile,

  /// Unknown link type
  unknown,
}

/// Notification types for routing
enum NotificationType {
  /// Announcement notification
  announcement,

  /// Attendance notification
  attendance,

  /// Fee reminder
  feeReminder,

  /// Exam result
  examResult,

  /// Homework notification
  homework,

  /// Event notification
  event,

  /// System notification
  system,

  /// Unknown notification type
  unknown,
}

/// Navigation source for analytics
enum NavigationSource {
  deeplink,
  notification,
  inApp,
}

/// Deep link data model
class DeepLinkData {
  final DeepLinkType type;
  final NavigationSource source;
  final Map<String, dynamic> params;
  final String? rawLink;
  final DateTime timestamp;

  DeepLinkData({
    required this.type,
    this.source = NavigationSource.deeplink,
    this.params = const {},
    this.rawLink,
  }) : timestamp = DateTime.now();

  /// Get parameter by key
  T? getParam<T>(String key) => params[key] as T?;

  /// Check if has parameter
  bool hasParam(String key) => params.containsKey(key);
}

/// Notification data model
class NotificationData {
  final NotificationType type;
  final NavigationSource source;
  final String? title;
  final String? body;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  NotificationData({
    required this.type,
    this.source = NavigationSource.notification,
    this.title,
    this.body,
    this.data = const {},
  }) : timestamp = DateTime.now();

  /// Get data by key
  T? getData<T>(String key) => data[key] as T?;

  /// Check if has data
  bool hasData(String key) => data.containsKey(key);
}

/// Centralized service for handling deep links and notification routing
@lazySingleton
class DeepLinkService extends BaseService<Future<void>, void> {
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _linkSubscription;

  /// Pending deep link to process after app initialization
  DeepLinkData? _pendingDeepLink;

  /// Pending notification to process after app initialization
  NotificationData? _pendingNotification;

  /// Whether navigator is ready
  bool _isNavigatorReady = false;

  /// Stream controller for navigation events (for UI to listen)
  final _navigationStreamController =
      StreamController<DeepLinkData>.broadcast();

  /// Stream of navigation events
  Stream<DeepLinkData> get navigationStream =>
      _navigationStreamController.stream;

  @override
  Future<void> init({void param}) async {
    Log.d('DeepLinkService initializing...');

    // Handle initial link (app opened via deeplink)
    await _handleInitialLink();

    // Listen for incoming links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleIncomingLink,
      onError: (error) {
        Log.e('Deep link stream error', error: error);
      },
    );

    Log.d('DeepLinkService initialized');
  }

  /// Handle initial link when app is opened via deeplink
  Future<void> _handleInitialLink() async {
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        Log.d('Initial deep link: $initialLink');
        handleDeepLink(initialLink.toString(), delayIfNotReady: true);
      }
    } catch (e) {
      Log.e('Failed to get initial deep link', error: e);
    }
  }

  /// Handle incoming link while app is running
  void _handleIncomingLink(Uri uri) {
    Log.d('Incoming deep link: $uri');
    handleDeepLink(uri.toString(), delayIfNotReady: true);
  }

  /// Mark navigator as ready and process pending navigation
  void markNavigatorReady() {
    _isNavigatorReady = true;
    Log.d('Navigator marked as ready');
    processPendingNavigation();
  }

  // ============ Deep Link Handling ============

  /// Parse deep link URL and return DeepLinkData
  DeepLinkData parseDeepLink(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      if (pathSegments.isEmpty) {
        return DeepLinkData(type: DeepLinkType.home, rawLink: url);
      }

      final firstSegment = pathSegments.first.toLowerCase();
      final params = Map<String, dynamic>.from(uri.queryParameters);

      // Add path parameters
      if (pathSegments.length > 1) {
        params['id'] = pathSegments[1];
      }

      switch (firstSegment) {
        case 'school':
        case 'schools':
          return DeepLinkData(
            type: DeepLinkType.school,
            params: params,
            rawLink: url,
          );
        case 'class':
        case 'classes':
          return DeepLinkData(
            type: DeepLinkType.classRoom,
            params: params,
            rawLink: url,
          );
        case 'student':
        case 'students':
          return DeepLinkData(
            type: DeepLinkType.student,
            params: params,
            rawLink: url,
          );
        case 'attendance':
          return DeepLinkData(
            type: DeepLinkType.attendance,
            params: params,
            rawLink: url,
          );
        case 'fees':
        case 'fee':
          return DeepLinkData(
            type: DeepLinkType.fees,
            params: params,
            rawLink: url,
          );
        case 'announcements':
        case 'announcement':
          return DeepLinkData(
            type: DeepLinkType.announcements,
            params: params,
            rawLink: url,
          );
        case 'notifications':
          return DeepLinkData(
            type: DeepLinkType.notifications,
            params: params,
            rawLink: url,
          );
        case 'settings':
          return DeepLinkData(
            type: DeepLinkType.settings,
            params: params,
            rawLink: url,
          );
        case 'profile':
          return DeepLinkData(
            type: DeepLinkType.profile,
            params: params,
            rawLink: url,
          );
        case 'home':
          return DeepLinkData(
            type: DeepLinkType.home,
            params: params,
            rawLink: url,
          );
        default:
          return DeepLinkData(
            type: DeepLinkType.unknown,
            params: params,
            rawLink: url,
          );
      }
    } catch (e) {
      Log.e('Failed to parse deep link: $url', error: e);
      return DeepLinkData(type: DeepLinkType.unknown, rawLink: url);
    }
  }

  /// Handle incoming deep link
  void handleDeepLink(String url, {bool delayIfNotReady = true}) {
    final deepLinkData = parseDeepLink(url);
    Log.d('Handling deep link: ${deepLinkData.type} - $url');

    // Check if navigator is ready
    if (!_isNavigatorReady) {
      if (delayIfNotReady) {
        _pendingDeepLink = deepLinkData;
        Log.d('Deep link queued for later processing');
      }
      return;
    }

    _navigateFromDeepLink(deepLinkData);
  }

  /// Navigate based on deep link data
  void _navigateFromDeepLink(DeepLinkData data) {
    final routeService = RouteService.routeService;

    // Emit to stream for UI awareness
    _navigationStreamController.add(data);

    switch (data.type) {
      case DeepLinkType.school:
        // Navigate to home for now (school detail route not yet defined)
        Log.d('School deep link - navigating to home');
        routeService.goRouter.go(RoutesName.home);
      case DeepLinkType.classRoom:
        // Navigate to home for now (class detail route not yet defined)
        Log.d('Class deep link - navigating to home');
        routeService.goRouter.go(RoutesName.home);
      case DeepLinkType.student:
        // Navigate to home for now (student detail route not yet defined)
        Log.d('Student deep link - navigating to home');
        routeService.goRouter.go(RoutesName.home);
      case DeepLinkType.attendance:
        Log.d('Attendance deep link - navigating to home');
        routeService.goRouter.go(RoutesName.home);
      case DeepLinkType.fees:
        Log.d('Fees deep link - navigating to home');
        routeService.goRouter.go(RoutesName.home);
      case DeepLinkType.announcements:
        Log.d('Announcements deep link - navigating to home');
        routeService.goRouter.go(RoutesName.home);
      case DeepLinkType.notifications:
        Log.d('Notifications deep link - navigating to home');
        routeService.goRouter.go(RoutesName.home);
      case DeepLinkType.settings:
        Log.d('Settings deep link - navigating to home');
        routeService.goRouter.go(RoutesName.home);
      case DeepLinkType.profile:
        Log.d('Profile deep link - navigating to home');
        routeService.goRouter.go(RoutesName.home);
      case DeepLinkType.home:
        routeService.goRouter.go(RoutesName.home);
      case DeepLinkType.unknown:
        Log.w('Unknown deep link type: ${data.rawLink}');
        routeService.goRouter.go(RoutesName.home);
    }
  }

  /// Process pending deep link if any
  void processPendingDeepLink() {
    if (_pendingDeepLink != null) {
      Log.d('Processing pending deep link');
      _navigateFromDeepLink(_pendingDeepLink!);
      _pendingDeepLink = null;
    }
  }

  // ============ Notification Routing ============

  /// Parse notification data and return NotificationData
  NotificationData parseNotification(Map<String, dynamic> data) {
    final typeString = data['type'] as String? ?? '';
    final type = _parseNotificationType(typeString);

    return NotificationData(
      type: type,
      title: data['title'] as String?,
      body: data['body'] as String?,
      data: data,
    );
  }

  NotificationType _parseNotificationType(String type) {
    switch (type.toLowerCase()) {
      case 'announcement':
        return NotificationType.announcement;
      case 'attendance':
        return NotificationType.attendance;
      case 'fee_reminder':
      case 'feereminder':
        return NotificationType.feeReminder;
      case 'exam_result':
      case 'examresult':
        return NotificationType.examResult;
      case 'homework':
        return NotificationType.homework;
      case 'event':
        return NotificationType.event;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.unknown;
    }
  }

  /// Handle notification tap and navigate
  void handleNotificationTap(
    Map<String, dynamic> data, {
    bool delayIfNotReady = true,
  }) {
    final notificationData = parseNotification(data);
    Log.d('Handling notification tap: ${notificationData.type}');

    // Check if navigator is ready
    if (!_isNavigatorReady) {
      if (delayIfNotReady) {
        _pendingNotification = notificationData;
        Log.d('Notification tap queued for later processing');
      }
      return;
    }

    _navigateFromNotification(notificationData);
  }

  /// Navigate based on notification data
  void _navigateFromNotification(NotificationData data) {
    final routeService = RouteService.routeService;

    // Emit to navigation stream
    final deepLinkData = DeepLinkData(
      type: _notificationTypeToDeepLinkType(data.type),
      source: NavigationSource.notification,
      params: data.data,
    );
    _navigationStreamController.add(deepLinkData);

    // Navigate to home for all notification types (specific screens not yet defined)
    Log.d('Notification tap: ${data.type} - navigating to home');
    routeService.goRouter.go(RoutesName.home);
  }

  DeepLinkType _notificationTypeToDeepLinkType(NotificationType type) {
    switch (type) {
      case NotificationType.announcement:
        return DeepLinkType.announcements;
      case NotificationType.attendance:
        return DeepLinkType.attendance;
      case NotificationType.feeReminder:
        return DeepLinkType.fees;
      case NotificationType.examResult:
      case NotificationType.homework:
      case NotificationType.event:
        return DeepLinkType.notifications;
      case NotificationType.system:
      case NotificationType.unknown:
        return DeepLinkType.notifications;
    }
  }

  /// Process pending notification if any
  void processPendingNotification() {
    if (_pendingNotification != null) {
      Log.d('Processing pending notification');
      _navigateFromNotification(_pendingNotification!);
      _pendingNotification = null;
    }
  }

  /// Process all pending navigation (deep links and notifications)
  void processPendingNavigation() {
    processPendingDeepLink();
    processPendingNotification();
  }

  // ============ Utility Methods ============

  /// Check if has pending navigation
  bool get hasPendingNavigation =>
      _pendingDeepLink != null || _pendingNotification != null;

  /// Clear all pending navigation
  void clearPendingNavigation() {
    _pendingDeepLink = null;
    _pendingNotification = null;
  }

  /// Check if navigator is ready
  bool get isNavigatorReady => _isNavigatorReady;

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _navigationStreamController.close();
    super.dispose();
  }
}
