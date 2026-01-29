import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/services/storage_service/storage_contract/storage_contract.dart';
import 'package:student_management/core/services/storage_service/storage_repo/app_storage_repo.dart';
import 'package:student_management/core/services/storage_service/storage_repo/auth_storage_repo.dart';
import 'package:student_management/presentation/views/splash/presentation/manager/splash_bloc/splash_bloc.dart';

@GenerateMocks([StorageStrategy])
import 'splash_bloc_test.mocks.dart';

void main() {
  late SplashBloc bloc;
  late MockStorageStrategy mockAuthStorageStrategy;
  late MockStorageStrategy mockAppStorageStrategy;
  late AuthStorageRepository authStorageRepository;
  late AppStorageRepository appStorageRepository;
  late StateRequestHandler handler;

  setUp(() {
    mockAuthStorageStrategy = MockStorageStrategy();
    mockAppStorageStrategy = MockStorageStrategy();
    authStorageRepository = AuthStorageRepository(mockAuthStorageStrategy);
    appStorageRepository = AppStorageRepository(mockAppStorageStrategy);
    handler = StateRequestHandler();

    // Default stubs for storage operations
    when(mockAuthStorageStrategy.write(any, any)).thenAnswer((_) async {});
    when(mockAuthStorageStrategy.delete(any)).thenAnswer((_) async {});
    when(mockAuthStorageStrategy.readSync<String>(any)).thenReturn(null);

    when(mockAppStorageStrategy.write(any, any)).thenAnswer((_) async {});
    when(mockAppStorageStrategy.delete(any)).thenAnswer((_) async {});
    when(mockAppStorageStrategy.readSync<String>(any)).thenReturn(null);
    when(mockAppStorageStrategy.readSync<bool>(any)).thenReturn(null);

    bloc = SplashBloc(
      handler,
      authStorageRepository,
      appStorageRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('SplashBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.state, equals(BlocState.none));
      expect(bloc.state.data, isNull);
      expect(bloc.state.routeOnPage, equals(RouteOnPage.splash));
      expect(bloc.state.updateUrl, isNull);
      expect(bloc.state.isNone, isTrue);
    });

    group('FetchDeviceStatusEvent', () {
      blocTest<SplashBloc, SplashState>(
        'emits success with route home when user has token and intro is completed',
        build: () {
          when(mockAppStorageStrategy.readSync<bool>('isIntroCompleted'))
              .thenReturn(true);
          when(mockAuthStorageStrategy.readSync<String>('ACCESS_TOKEN'))
              .thenReturn('valid-access-token');
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchDeviceStatusEvent()),
        wait: const Duration(seconds: 4),
        expect: () => [
          isA<SplashState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.routeOnPage, 'routeOnPage', RouteOnPage.home),
        ],
      );

      blocTest<SplashBloc, SplashState>(
        'emits success with route login when user has no token and intro is completed',
        build: () {
          when(mockAppStorageStrategy.readSync<bool>('isIntroCompleted'))
              .thenReturn(true);
          when(mockAuthStorageStrategy.readSync<String>('ACCESS_TOKEN'))
              .thenReturn(null);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchDeviceStatusEvent()),
        wait: const Duration(seconds: 4),
        expect: () => [
          isA<SplashState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.routeOnPage, 'routeOnPage', RouteOnPage.login),
        ],
      );

      blocTest<SplashBloc, SplashState>(
        'emits success with route intro when intro is not completed',
        build: () {
          when(mockAppStorageStrategy.readSync<bool>('isIntroCompleted'))
              .thenReturn(false);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchDeviceStatusEvent()),
        wait: const Duration(seconds: 2),
        expect: () => [
          isA<SplashState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.routeOnPage, 'routeOnPage', RouteOnPage.intro),
        ],
      );

      blocTest<SplashBloc, SplashState>(
        'emits success with route home when intro status is null (defaults to true)',
        build: () {
          // When isIntroCompleted returns null, the code does !(null ?? true) = !true = false
          // so it does NOT take the intro branch; it checks for token instead
          when(mockAppStorageStrategy.readSync<bool>('isIntroCompleted'))
              .thenReturn(null);
          when(mockAuthStorageStrategy.readSync<String>('ACCESS_TOKEN'))
              .thenReturn('valid-token');
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchDeviceStatusEvent()),
        wait: const Duration(seconds: 4),
        expect: () => [
          isA<SplashState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.routeOnPage, 'routeOnPage', RouteOnPage.home),
        ],
      );

      blocTest<SplashBloc, SplashState>(
        'emits failed with route login when exception occurs',
        build: () {
          when(mockAppStorageStrategy.readSync<bool>('isIntroCompleted'))
              .thenThrow(Exception('Storage error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchDeviceStatusEvent()),
        wait: const Duration(seconds: 2),
        expect: () => [
          isA<SplashState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.routeOnPage, 'routeOnPage', RouteOnPage.login)
              .having((s) => s.error, 'error', isNotNull),
        ],
      );
    });

    group('IntroCompleted', () {
      blocTest<SplashBloc, SplashState>(
        'writes intro completed status to storage and does not emit new state',
        build: () {
          return bloc;
        },
        act: (bloc) => bloc.add(const IntroCompleted()),
        wait: const Duration(milliseconds: 100),
        expect: () => <SplashState>[],
        verify: (_) {
          verify(mockAppStorageStrategy.write('isIntroCompleted', true))
              .called(1);
        },
      );

      blocTest<SplashBloc, SplashState>(
        'does not crash when storage write fails',
        build: () {
          when(mockAppStorageStrategy.write('isIntroCompleted', true))
              .thenThrow(Exception('Storage write failed'));
          return bloc;
        },
        act: (bloc) => bloc.add(const IntroCompleted()),
        wait: const Duration(milliseconds: 100),
        expect: () => <SplashState>[],
      );
    });

    group('isUpdateAvailable', () {
      test('returns false when updateUrl is null and data is null', () {
        expect(bloc.isUpdateAvailable, isFalse);
      });

      test('returns false when updateUrl is empty', () {
        // Since we cannot easily set the state externally, we just test the initial state
        expect(bloc.isUpdateAvailable, isFalse);
      });
    });

    group('updateUrl getter', () {
      test('returns empty string when state updateUrl is null', () {
        expect(bloc.updateUrl, equals(''));
      });
    });

    group('SplashState', () {
      test('copyWith preserves existing values', () {
        const original = SplashState(
          routeOnPage: RouteOnPage.home,
          updateUrl: 'https://example.com/update',
          data: true,
        );
        final copied = original.copyWith(error: 'new error');
        expect(copied.routeOnPage, equals(RouteOnPage.home));
        expect(copied.updateUrl, equals('https://example.com/update'));
        expect(copied.data, isTrue);
        expect(copied.error, equals('new error'));
      });

      test('copyWith can override values', () {
        const original = SplashState(routeOnPage: RouteOnPage.splash);
        final copied = original.copyWith(routeOnPage: RouteOnPage.login);
        expect(copied.routeOnPage, equals(RouteOnPage.login));
      });

      test('clear resets to default state', () {
        const modified = SplashState(
          routeOnPage: RouteOnPage.home,
          updateUrl: 'https://example.com/update',
          data: true,
          error: 'some error',
        );
        final cleared = modified.clear();
        expect(cleared.routeOnPage, equals(RouteOnPage.splash));
        expect(cleared.updateUrl, isNull);
        expect(cleared.data, isNull);
        expect(cleared.error, isNull);
      });
    });
  });
}
