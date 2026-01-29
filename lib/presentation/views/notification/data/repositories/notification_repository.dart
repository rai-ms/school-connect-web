import 'package:injectable/injectable.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import '../models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationResponse>> getMyNotifications({int page, int size});
  Future<List<NotificationResponse>> getUnreadNotifications();
  Future<int> getUnreadCount();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<NotificationResponse> sendNotification(SendNotificationRequest request);
}

@Singleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final ApiDispatcher _apiDispatcher;

  NotificationRepositoryImpl(this._apiDispatcher);

  @override
  Future<List<NotificationResponse>> getMyNotifications(
      {int page = 0, int size = 20}) async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/notifications/user?page=$page&size=$size',
    );
    final data = response.data is Map
        ? (response.data['content'] ?? [])
        : response.data is List
            ? response.data
            : [];
    return (data as List)
        .map((e) => NotificationResponse.fromJson(e))
        .toList();
  }

  @override
  Future<List<NotificationResponse>> getUnreadNotifications() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/notifications/user/unread',
    );
    final data = response.data is List ? response.data : [];
    return (data as List)
        .map((e) => NotificationResponse.fromJson(e))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _apiDispatcher.call(
      type: RequestType.get,
      endPoint: 'api/notifications/user/unread/count',
    );
    return (response.data['unreadCount'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/notifications/$notificationId/read',
    );
  }

  @override
  Future<void> markAllAsRead() async {
    await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/notifications/read-all',
    );
  }

  @override
  Future<NotificationResponse> sendNotification(
      SendNotificationRequest request) async {
    final response = await _apiDispatcher.call(
      type: RequestType.post,
      endPoint: 'api/notifications/send',
      body: request.toJson(),
    );
    return NotificationResponse.fromJson(response.data);
  }
}
