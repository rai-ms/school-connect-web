import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/notification/data/models/notification_model.dart';
import 'package:student_management/presentation/views/notification/data/repositories/notification_repository.dart';
import 'package:student_management/presentation/views/notification/presentation/manager/notification_bloc/notification_bloc.dart';

@GenerateMocks([NotificationRepository])
import 'notification_bloc_test.mocks.dart';

void main() {
  late NotificationBloc bloc;
  late MockNotificationRepository mockRepository;
  late StateRequestHandler handler;

  final testNotifications = [
    NotificationResponse(
      id: 'notif-1',
      title: 'Exam Schedule',
      body: 'Final exams start next week',
      notificationType: 'ANNOUNCEMENT',
      recipientUserId: 'user-1',
      senderName: 'Admin',
      status: 'SENT',
      isRead: false,
      createdAt: DateTime(2025, 1, 15),
    ),
    NotificationResponse(
      id: 'notif-2',
      title: 'Fee Reminder',
      body: 'Please pay your fees by January 31',
      notificationType: 'REMINDER',
      recipientUserId: 'user-1',
      senderName: 'Accounts',
      status: 'SENT',
      isRead: true,
      createdAt: DateTime(2025, 1, 10),
    ),
  ];

  final testUnreadNotifications = [
    testNotifications[0],
  ];

  final testSendRequest = SendNotificationRequest(
    title: 'Holiday Notice',
    body: 'School will remain closed on Monday',
    notificationType: 'ANNOUNCEMENT',
    recipientRole: 'STUDENT',
  );

  setUp(() {
    mockRepository = MockNotificationRepository();
    handler = StateRequestHandler();
    bloc = NotificationBloc(mockRepository, handler);
  });

  tearDown(() {
    bloc.close();
  });

  group('NotificationBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.notifications, isEmpty);
      expect(bloc.state.unreadNotifications, isEmpty);
      expect(bloc.state.unreadCount, 0);
      expect(bloc.state.isNone, isTrue);
    });

    group('FetchNotifications', () {
      blocTest<NotificationBloc, NotificationState>(
        'emits loading then success with notifications when fetch succeeds',
        build: () {
          when(mockRepository.getMyNotifications())
              .thenAnswer((_) async => testNotifications);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchNotifications()),
        expect: () => [
          isA<NotificationState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<NotificationState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.notifications.length,
                  'notifications.length', 2)
              .having((s) => s.notifications.first.title, 'first title',
                  'Exam Schedule'),
        ],
        verify: (_) {
          verify(mockRepository.getMyNotifications()).called(1);
        },
      );

      blocTest<NotificationBloc, NotificationState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getMyNotifications())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchNotifications()),
        expect: () => [
          isA<NotificationState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<NotificationState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getMyNotifications()).called(1);
        },
      );
    });

    group('FetchUnreadNotifications', () {
      blocTest<NotificationBloc, NotificationState>(
        'emits loading then success with unread notifications and count',
        build: () {
          when(mockRepository.getUnreadNotifications())
              .thenAnswer((_) async => testUnreadNotifications);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchUnreadNotifications()),
        expect: () => [
          isA<NotificationState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<NotificationState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.unreadNotifications.length,
                  'unreadNotifications.length', 1)
              .having((s) => s.unreadCount, 'unreadCount', 1),
        ],
        verify: (_) {
          verify(mockRepository.getUnreadNotifications()).called(1);
        },
      );

      blocTest<NotificationBloc, NotificationState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getUnreadNotifications())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchUnreadNotifications()),
        expect: () => [
          isA<NotificationState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<NotificationState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getUnreadNotifications()).called(1);
        },
      );
    });

    group('FetchUnreadCount', () {
      blocTest<NotificationBloc, NotificationState>(
        'emits success with unreadCount when fetch succeeds',
        build: () {
          when(mockRepository.getUnreadCount())
              .thenAnswer((_) async => 5);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchUnreadCount()),
        expect: () => [
          isA<NotificationState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.unreadCount, 'unreadCount', 5),
        ],
        verify: (_) {
          verify(mockRepository.getUnreadCount()).called(1);
        },
      );

      blocTest<NotificationBloc, NotificationState>(
        'does not emit failed state when fetch throws (no emit in error handler)',
        build: () {
          when(mockRepository.getUnreadCount())
              .thenAnswer((_) async => throw Exception('Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchUnreadCount()),
        expect: () => [],
        verify: (_) {
          verify(mockRepository.getUnreadCount()).called(1);
        },
      );
    });

    group('MarkNotificationRead', () {
      blocTest<NotificationBloc, NotificationState>(
        'emits success with updated notification marked as read',
        seed: () => NotificationState(
          notifications: testNotifications,
          unreadCount: 1,
        ),
        build: () {
          when(mockRepository.markAsRead('notif-1'))
              .thenAnswer((_) async {});
          return bloc;
        },
        act: (bloc) => bloc.add(const MarkNotificationRead('notif-1')),
        expect: () => [
          isA<NotificationState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                (s) => s.notifications
                    .firstWhere((n) => n.id == 'notif-1')
                    .isRead,
                'notif-1 isRead',
                true,
              )
              .having((s) => s.unreadCount, 'unreadCount', 0),
        ],
        verify: (_) {
          verify(mockRepository.markAsRead('notif-1')).called(1);
        },
      );

      blocTest<NotificationBloc, NotificationState>(
        'does not emit failed state when mark read throws (no emit in error handler)',
        seed: () => NotificationState(
          notifications: testNotifications,
          unreadCount: 1,
        ),
        build: () {
          when(mockRepository.markAsRead('notif-1'))
              .thenAnswer((_) async => throw Exception('Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const MarkNotificationRead('notif-1')),
        expect: () => [],
        verify: (_) {
          verify(mockRepository.markAsRead('notif-1')).called(1);
        },
      );
    });

    group('MarkAllNotificationsRead', () {
      blocTest<NotificationBloc, NotificationState>(
        'emits loading then success with all notifications marked as read',
        seed: () => NotificationState(
          notifications: testNotifications,
          unreadNotifications: testUnreadNotifications,
          unreadCount: 1,
        ),
        build: () {
          when(mockRepository.markAllAsRead())
              .thenAnswer((_) async {});
          return bloc;
        },
        act: (bloc) => bloc.add(const MarkAllNotificationsRead()),
        expect: () => [
          isA<NotificationState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<NotificationState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                (s) => s.notifications.every((n) => n.isRead),
                'all isRead',
                true,
              )
              .having(
                  (s) => s.unreadNotifications, 'unreadNotifications', isEmpty)
              .having((s) => s.unreadCount, 'unreadCount', 0),
        ],
        verify: (_) {
          verify(mockRepository.markAllAsRead()).called(1);
        },
      );

      blocTest<NotificationBloc, NotificationState>(
        'emits loading then failed when mark all read throws',
        seed: () => NotificationState(
          notifications: testNotifications,
          unreadCount: 1,
        ),
        build: () {
          when(mockRepository.markAllAsRead())
              .thenAnswer((_) async => throw Exception('Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const MarkAllNotificationsRead()),
        expect: () => [
          isA<NotificationState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<NotificationState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.markAllAsRead()).called(1);
        },
      );
    });

    group('SendNotification', () {
      blocTest<NotificationBloc, NotificationState>(
        'emits loading then success when send succeeds',
        build: () {
          when(mockRepository.sendNotification(testSendRequest)).thenAnswer(
            (_) async => NotificationResponse(
              id: 'notif-3',
              title: 'Holiday Notice',
              body: 'School will remain closed on Monday',
              notificationType: 'ANNOUNCEMENT',
              status: 'SENT',
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(SendNotification(testSendRequest)),
        expect: () => [
          isA<NotificationState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<NotificationState>()
              .having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.sendNotification(testSendRequest)).called(1);
        },
      );

      blocTest<NotificationBloc, NotificationState>(
        'emits loading then failed when send throws',
        build: () {
          when(mockRepository.sendNotification(testSendRequest))
              .thenAnswer((_) async => throw Exception('Send error'));
          return bloc;
        },
        act: (bloc) => bloc.add(SendNotification(testSendRequest)),
        expect: () => [
          isA<NotificationState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<NotificationState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.sendNotification(testSendRequest)).called(1);
        },
      );
    });
  });
}
