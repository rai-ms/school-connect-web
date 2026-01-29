import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/core/services/storage_service/storage_contract/storage_contract.dart';
import 'package:student_management/core/services/storage_service/storage_repo/auth_storage_repo.dart';
import 'package:student_management/presentation/views/dashboard/domain/entities/user_role.dart';
import 'package:student_management/presentation/views/dashboard/domain/use_cases/profile_fetch_use_case.dart';
import 'package:student_management/presentation/views/dashboard/domain/use_cases/profile_update_use_case.dart';
import 'package:student_management/presentation/views/dashboard/presentation/manager/profile_management_bloc/profile_management_bloc.dart';

@GenerateMocks([ProfileFetchUseCase, ProfileUpdateUseCase, StorageStrategy])
import 'profile_management_bloc_test.mocks.dart';

/// Helper to build a test JWT token from a payload map.
String _buildTestJwt(Map<String, dynamic> payload) {
  final headerStr = base64Url
      .encode(utf8.encode('{"alg":"HS256","typ":"JWT"}'))
      .replaceAll('=', '');
  final bodyStr = base64Url
      .encode(utf8.encode(jsonEncode(payload)))
      .replaceAll('=', '');
  const signatureStr = 'test-signature';
  return '$headerStr.$bodyStr.$signatureStr';
}

void main() {
  late ProfileManageBloc bloc;
  late MockStorageStrategy mockStorageStrategy;
  late AuthStorageRepository authStorageRepository;
  late MockProfileFetchUseCase mockProfileFetchUseCase;
  late MockProfileUpdateUseCase mockProfileUpdateUseCase;
  late StateRequestHandler handler;

  final testProfileJson = <String, dynamic>{
    'id': 'user-1',
    'username': 'testuser',
    'email': 'test@example.com',
    'firstName': 'Test',
    'lastName': 'User',
    'fullName': 'Test User',
    'phone': '1234567890',
    'avatarUrl': null,
    'primaryRole': 'ADMIN',
    'roles': ['ADMIN'],
    'status': 'ACTIVE',
    'emailVerified': true,
    'mfaEnabled': false,
    'lastLoginAt': null,
    'createdAt': null,
    'updatedAt': null,
  };

  // A valid JWT token with payload containing role, tenantId, sub, iat, exp
  final testToken = _buildTestJwt({
    'role': 'ADMIN',
    'tenantId': 'tenant-1',
    'sub': 'user-1',
    'iat': 1700000000,
    'exp': 1700003600,
  });

  setUp(() {
    mockStorageStrategy = MockStorageStrategy();
    authStorageRepository = AuthStorageRepository(mockStorageStrategy);
    mockProfileFetchUseCase = MockProfileFetchUseCase();
    mockProfileUpdateUseCase = MockProfileUpdateUseCase();
    handler = StateRequestHandler();

    // Default stubs for storage operations
    when(mockStorageStrategy.write(any, any)).thenAnswer((_) async {});
    when(mockStorageStrategy.delete(any)).thenAnswer((_) async {});
    when(mockStorageStrategy.readSync<String>(any)).thenReturn(null);
    when(mockStorageStrategy.readSync<bool>(any)).thenReturn(null);

    bloc = ProfileManageBloc(
      handler,
      authStorageRepository,
      mockProfileFetchUseCase,
      mockProfileUpdateUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ProfileManageBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.state, equals(BlocState.none));
      expect(bloc.state.data, isNull);
      expect(bloc.state.role, isNull);
      expect(bloc.state.profile, isNull);
      expect(bloc.state.isProfileLoaded, isFalse);
      expect(bloc.state.isTokenNotFound, isFalse);
      expect(bloc.state.isNone, isTrue);
    });

    group('LoadUserProfile', () {
      blocTest<ProfileManageBloc, ProfileManageState>(
        'emits loading then success with profile data when load succeeds',
        build: () {
          when(mockStorageStrategy.readSync<String>('ACCESS_TOKEN'))
              .thenReturn(testToken);
          when(mockStorageStrategy.readSync<String>('USER_ID'))
              .thenReturn('user-1');
          when(mockProfileFetchUseCase(params: anyNamed('params')))
              .thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/profile'),
              data: testProfileJson,
              statusCode: 200,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadUserProfile()),
        expect: () => [
          isA<ProfileManageState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<ProfileManageState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.data, 'data', isNotNull)
              .having((s) => s.data?.role, 'tokenRole', 'ADMIN')
              .having((s) => s.role, 'role', UserRole.schoolAdmin)
              .having((s) => s.profile?.firstName, 'firstName', 'Test')
              .having((s) => s.profile?.fullName, 'fullName', 'Test User')
              .having((s) => s.isProfileLoaded, 'isProfileLoaded', true),
        ],
        verify: (_) {
          verify(mockProfileFetchUseCase(params: anyNamed('params'))).called(1);
        },
      );

      blocTest<ProfileManageBloc, ProfileManageState>(
        'emits failed with isTokenNotFound when token is null',
        build: () {
          when(mockStorageStrategy.readSync<String>('ACCESS_TOKEN'))
              .thenReturn(null);
          when(mockStorageStrategy.readSync<String>('USER_ID'))
              .thenReturn('user-1');
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadUserProfile()),
        expect: () => [
          isA<ProfileManageState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<ProfileManageState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.isTokenNotFound, 'isTokenNotFound', true),
        ],
      );

      blocTest<ProfileManageBloc, ProfileManageState>(
        'emits failed with isTokenNotFound when token is empty',
        build: () {
          when(mockStorageStrategy.readSync<String>('ACCESS_TOKEN'))
              .thenReturn('');
          when(mockStorageStrategy.readSync<String>('USER_ID'))
              .thenReturn('user-1');
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadUserProfile()),
        expect: () => [
          isA<ProfileManageState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<ProfileManageState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.isTokenNotFound, 'isTokenNotFound', true),
        ],
      );

      blocTest<ProfileManageBloc, ProfileManageState>(
        'emits failed with isTokenNotFound when userId is null',
        build: () {
          when(mockStorageStrategy.readSync<String>('ACCESS_TOKEN'))
              .thenReturn(testToken);
          when(mockStorageStrategy.readSync<String>('USER_ID'))
              .thenReturn(null);
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadUserProfile()),
        expect: () => [
          isA<ProfileManageState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<ProfileManageState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.isTokenNotFound, 'isTokenNotFound', true),
        ],
      );

      blocTest<ProfileManageBloc, ProfileManageState>(
        'emits failed with isTokenNotFound when userId is empty',
        build: () {
          when(mockStorageStrategy.readSync<String>('ACCESS_TOKEN'))
              .thenReturn(testToken);
          when(mockStorageStrategy.readSync<String>('USER_ID'))
              .thenReturn('');
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadUserProfile()),
        expect: () => [
          isA<ProfileManageState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<ProfileManageState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.isTokenNotFound, 'isTokenNotFound', true),
        ],
      );

      blocTest<ProfileManageBloc, ProfileManageState>(
        'emits loading then failed when profile fetch throws exception',
        build: () {
          when(mockStorageStrategy.readSync<String>('ACCESS_TOKEN'))
              .thenReturn(testToken);
          when(mockStorageStrategy.readSync<String>('USER_ID'))
              .thenReturn('user-1');
          when(mockProfileFetchUseCase(params: anyNamed('params')))
              .thenThrow(Exception('Failed to fetch profile'));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadUserProfile()),
        expect: () => [
          isA<ProfileManageState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<ProfileManageState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.error, 'error', isNotNull),
        ],
      );

      blocTest<ProfileManageBloc, ProfileManageState>(
        'emits loading then failed when DioException occurs and clears auth',
        build: () {
          when(mockStorageStrategy.readSync<String>('ACCESS_TOKEN'))
              .thenReturn(testToken);
          when(mockStorageStrategy.readSync<String>('USER_ID'))
              .thenReturn('user-1');
          when(mockProfileFetchUseCase(params: anyNamed('params')))
              .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/profile'),
            message: 'Unauthorized',
            response: Response(
              requestOptions: RequestOptions(path: '/profile'),
              statusCode: 401,
            ),
          ));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadUserProfile()),
        expect: () => [
          isA<ProfileManageState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<ProfileManageState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.statusCode, 'statusCode', 401),
        ],
        verify: (_) {
          // clearAuthData deletes access_token, refresh_token, user_id
          verify(mockStorageStrategy.delete(any)).called(3);
        },
      );
    });

    group('UpdateUserProfile', () {
      blocTest<ProfileManageBloc, ProfileManageState>(
        'emits loading when update is triggered',
        build: () {
          return bloc;
        },
        act: (bloc) => bloc.add(const UpdateUserProfile({'role': 'ADMIN'})),
        expect: () => [
          isA<ProfileManageState>()
              .having((s) => s.isLoading, 'isLoading', true),
        ],
      );
    });

    group('ClearProfileData', () {
      blocTest<ProfileManageBloc, ProfileManageState>(
        'emits fresh initial state when clear is triggered',
        build: () {
          return bloc;
        },
        act: (bloc) => bloc.add(const ClearProfileData()),
        expect: () => [
          isA<ProfileManageState>()
              .having((s) => s.isNone, 'isNone', true)
              .having((s) => s.data, 'data', isNull)
              .having((s) => s.role, 'role', isNull)
              .having((s) => s.profile, 'profile', isNull)
              .having((s) => s.isProfileLoaded, 'isProfileLoaded', false)
              .having((s) => s.isTokenNotFound, 'isTokenNotFound', false),
        ],
      );
    });

    group('LogOutEvent', () {
      blocTest<ProfileManageBloc, ProfileManageState>(
        'emits loading then success with cleared state on logout',
        build: () {
          return bloc;
        },
        act: (bloc) => bloc.add(const LogOutEvent()),
        expect: () => [
          isA<ProfileManageState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<ProfileManageState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.event, 'event', isA<LogOutEvent>())
              .having((s) => s.data, 'data', isNull)
              .having((s) => s.role, 'role', isNull)
              .having((s) => s.profile, 'profile', isNull),
        ],
        verify: (_) {
          // clearAuthData deletes access_token, refresh_token, user_id
          verify(mockStorageStrategy.delete(any)).called(3);
        },
      );

      blocTest<ProfileManageBloc, ProfileManageState>(
        'emits loading then success even when clearAuthData throws (exception swallowed internally)',
        build: () {
          when(mockStorageStrategy.delete(any))
              .thenThrow(Exception('Storage error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const LogOutEvent()),
        expect: () => [
          isA<ProfileManageState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<ProfileManageState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.event, 'event', isA<LogOutEvent>()),
        ],
      );
    });

    group('CheckFeatureAccess', () {
      blocTest<ProfileManageBloc, ProfileManageState>(
        'does not emit new state (no-op)',
        build: () => bloc,
        act: (bloc) => bloc.add(const CheckFeatureAccess('attendance')),
        expect: () => <ProfileManageState>[],
      );
    });

    group('UpdateUserFeatures', () {
      blocTest<ProfileManageBloc, ProfileManageState>(
        'does not emit new state (no-op)',
        build: () => bloc,
        act: (bloc) =>
            bloc.add(const UpdateUserFeatures(['attendance', 'fees'])),
        expect: () => <ProfileManageState>[],
      );
    });
  });
}
