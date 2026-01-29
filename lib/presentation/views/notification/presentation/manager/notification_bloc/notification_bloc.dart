import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:student_management/core/base/bloc_base/bloc_event.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;

import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;
  final StateRequestHandler _handler;

  NotificationBloc(this._repository, this._handler)
      : super(const NotificationState()) {
    on<FetchNotifications>(_onFetchNotifications);
    on<FetchUnreadNotifications>(_onFetchUnread);
    on<FetchUnreadCount>(_onFetchUnreadCount);
    on<MarkNotificationRead>(_onMarkRead);
    on<MarkAllNotificationsRead>(_onMarkAllRead);
    on<SendNotification>(_onSendNotification);
  }

  FVoid _onFetchNotifications(
      FetchNotifications event, Emitter<NotificationState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final notifications = await _repository.getMyNotifications();
        emit(state.copyWith(
            state: state.success, notifications: notifications));
      },
      dioError: (e) {
        Log.e('Error fetching notifications: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching notifications: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchUnread(
      FetchUnreadNotifications event, Emitter<NotificationState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        final unread = await _repository.getUnreadNotifications();
        emit(state.copyWith(
            state: state.success,
            unreadNotifications: unread,
            unreadCount: unread.length));
      },
      dioError: (e) {
        Log.e('Error fetching unread notifications: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error fetching unread notifications: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onFetchUnreadCount(
      FetchUnreadCount event, Emitter<NotificationState> emit) async {
    await _handler(
      apiCall: () async {
        final count = await _repository.getUnreadCount();
        emit(state.copyWith(state: state.success, unreadCount: count));
      },
      dioError: (e) {
        Log.e('Error fetching unread count: ${e.message}');
      },
      error: (e) {
        Log.e('Error fetching unread count: $e');
      },
    );
  }

  FVoid _onMarkRead(
      MarkNotificationRead event, Emitter<NotificationState> emit) async {
    await _handler(
      apiCall: () async {
        await _repository.markAsRead(event.notificationId);
        // Update local state
        final updated = state.notifications.map((n) {
          if (n.id == event.notificationId) {
            return NotificationResponse(
              id: n.id,
              title: n.title,
              body: n.body,
              notificationType: n.notificationType,
              recipientUserId: n.recipientUserId,
              senderName: n.senderName,
              status: n.status,
              isRead: true,
              dataPayload: n.dataPayload,
              createdAt: n.createdAt,
            );
          }
          return n;
        }).toList();
        emit(state.copyWith(
          state: state.success,
          notifications: updated,
          unreadCount:
              (state.unreadCount - 1).clamp(0, state.unreadCount),
        ));
      },
      dioError: (e) {
        Log.e('Error marking notification read: ${e.message}');
      },
      error: (e) {
        Log.e('Error marking notification read: $e');
      },
    );
  }

  FVoid _onMarkAllRead(
      MarkAllNotificationsRead event, Emitter<NotificationState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.markAllAsRead();
        // Update local state
        final updated = state.notifications.map((n) {
          return NotificationResponse(
            id: n.id,
            title: n.title,
            body: n.body,
            notificationType: n.notificationType,
            recipientUserId: n.recipientUserId,
            senderName: n.senderName,
            status: n.status,
            isRead: true,
            dataPayload: n.dataPayload,
            createdAt: n.createdAt,
          );
        }).toList();
        emit(state.copyWith(
          state: state.success,
          notifications: updated,
          unreadNotifications: [],
          unreadCount: 0,
        ));
      },
      dioError: (e) {
        Log.e('Error marking all read: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error marking all read: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }

  FVoid _onSendNotification(
      SendNotification event, Emitter<NotificationState> emit) async {
    await _handler(
      apiCall: () async {
        emit(state.copyWith(state: state.loading, event: event));
        await _repository.sendNotification(event.request);
        emit(state.copyWith(state: state.success));
      },
      dioError: (e) {
        Log.e('Error sending notification: ${e.message}');
        emit(state.copyWith(state: state.failed, error: e.message));
      },
      error: (e) {
        Log.e('Error sending notification: $e');
        emit(state.copyWith(state: state.failed, error: e.toString()));
      },
    );
  }
}
