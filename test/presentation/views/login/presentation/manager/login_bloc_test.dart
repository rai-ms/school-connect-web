import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/services/storage_service/storage_contract/storage_contract.dart';
import 'package:student_management/core/services/storage_service/storage_repo/auth_storage_repo.dart';
import 'package:student_management/presentation/views/login/domain/repositories/login_repository.dart';
import 'package:student_management/presentation/views/login/presentation/manager/login_bloc/login_bloc.dart';

@GenerateMocks([LoginRepository, StorageStrategy])
import 'login_bloc_test.mocks.dart';

void main() {
  late LoginBloc bloc;
  late MockLoginRepository mockLoginRepository;
  late MockStorageStrategy mockStorageStrategy;
  late AuthStorageRepository authStorageRepository;
  late StateRequestHandler handler;

  final testLoginResponseJson = <String, dynamic>{
    'accessToken': 'test-access-token',
    'refreshToken': 'test-refresh-token',
    'tokenType': 'Bearer',
    'expiresIn': 3600,
    'user': {
      'id': 'user-1',
      'email': 'test@example.com',
      'firstName': 'Test',
      'lastName': 'User',
      'role': 'ADMIN',
      'tenantId': 'tenant-1',
      'emailVerified': true,
      'mfaEnabled': false,
    },
  };

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    mockStorageStrategy = MockStorageStrategy();
    authStorageRepository = AuthStorageRepository(mockStorageStrategy);
    handler = StateRequestHandler();

    // Default stubs for storage writes and deletes
    when(mockStorageStrategy.write(any, any)).thenAnswer((_) async {});
    when(mockStorageStrategy.delete(any)).thenAnswer((_) async {});
    when(mockStorageStrategy.readSync<String>(any)).thenReturn(null);

    bloc = LoginBloc(
      handler,
      mockLoginRepository,
      authStorageRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('LoginBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.state, equals(BlocState.none));
      expect(bloc.state.data, isNull);
      expect(bloc.state.error, isNull);
      expect(bloc.state.isNone, isTrue);
    });

    group('LoginButtonPressed', () {
      blocTest<LoginBloc, LoginState>(
        'emits loading then success when login succeeds',
        build: () {
          when(mockLoginRepository.login(
            payload: anyNamed('payload'),
          )).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/login'),
              data: testLoginResponseJson,
              statusCode: 200,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoginButtonPressed(
          email: 'test@example.com',
          password: 'password123',
          rememberMe: true,
        )),
        expect: () => [
          isA<LoginState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LoginState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                (s) => s.data?.accessToken,
                'accessToken',
                'test-access-token',
              ),
        ],
        verify: (_) {
          verify(mockLoginRepository.login(payload: anyNamed('payload')))
              .called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits loading then failed when API returns ERROR status',
        build: () {
          when(mockLoginRepository.login(
            payload: anyNamed('payload'),
          )).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/login'),
              data: <String, dynamic>{
                'status': 'ERROR',
                'message': 'Invalid credentials',
              },
              statusCode: 200,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoginButtonPressed(
          email: 'test@example.com',
          password: 'wrong-password',
          rememberMe: false,
        )),
        expect: () => [
          isA<LoginState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LoginState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockLoginRepository.login(payload: anyNamed('payload')))
              .called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits loading then failed when login response has empty access token',
        build: () {
          when(mockLoginRepository.login(
            payload: anyNamed('payload'),
          )).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/login'),
              data: <String, dynamic>{
                'accessToken': '',
                'refreshToken': 'some-refresh-token',
              },
              statusCode: 200,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoginButtonPressed(
          email: 'test@example.com',
          password: 'password123',
          rememberMe: false,
        )),
        expect: () => [
          isA<LoginState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LoginState>().having((s) => s.isFailed, 'isFailed', true),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits loading then failed when login response has null access token',
        build: () {
          when(mockLoginRepository.login(
            payload: anyNamed('payload'),
          )).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/login'),
              data: <String, dynamic>{
                'accessToken': null,
                'refreshToken': null,
              },
              statusCode: 200,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoginButtonPressed(
          email: 'test@example.com',
          password: 'password123',
          rememberMe: false,
        )),
        expect: () => [
          isA<LoginState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LoginState>().having((s) => s.isFailed, 'isFailed', true),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits loading then failed when login throws a generic exception',
        build: () {
          when(mockLoginRepository.login(
            payload: anyNamed('payload'),
          )).thenThrow(Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoginButtonPressed(
          email: 'test@example.com',
          password: 'password123',
          rememberMe: false,
        )),
        expect: () => [
          isA<LoginState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LoginState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockLoginRepository.login(payload: anyNamed('payload')))
              .called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits loading then failed when DioException occurs',
        build: () {
          when(mockLoginRepository.login(
            payload: anyNamed('payload'),
          )).thenThrow(DioException(
            requestOptions: RequestOptions(path: '/login'),
            message: 'Connection timeout',
            response: Response(
              requestOptions: RequestOptions(path: '/login'),
              statusCode: 408,
            ),
          ));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoginButtonPressed(
          email: 'test@example.com',
          password: 'password123',
          rememberMe: false,
        )),
        expect: () => [
          isA<LoginState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LoginState>().having((s) => s.isFailed, 'isFailed', true),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'stores tokens and user data on successful login',
        build: () {
          when(mockLoginRepository.login(
            payload: anyNamed('payload'),
          )).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/login'),
              data: testLoginResponseJson,
              statusCode: 200,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoginButtonPressed(
          email: 'test@example.com',
          password: 'password123',
          rememberMe: true,
        )),
        expect: () => [
          isA<LoginState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LoginState>().having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          // Verify storage writes were called with correct keys
          verify(mockStorageStrategy.write('USER_ID_REMEMBER_ME', 'test@example.com'))
              .called(1);
          verify(mockStorageStrategy.write('USER_PASSWORD_REMEMBER_ME', 'password123'))
              .called(1);
          verify(mockStorageStrategy.write('ACCESS_TOKEN', 'test-access-token'))
              .called(1);
          verify(mockStorageStrategy.write('REFRESH_TOKEN', 'test-refresh-token'))
              .called(1);
          verify(mockStorageStrategy.write('USER_ID', 'user-1'))
              .called(1);
        },
      );
    });

    group('LogoutRequested', () {
      blocTest<LoginBloc, LoginState>(
        'emits success state after clearing auth data',
        build: () {
          return bloc;
        },
        act: (bloc) => bloc.add(const LogoutRequested()),
        expect: () => [
          isA<LoginState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.event, 'event', isA<LogoutRequested>()),
        ],
        verify: (_) {
          // clearAuthData deletes access_token, refresh_token, user_id
          verify(mockStorageStrategy.delete(any)).called(3);
        },
      );
    });
  });
}
