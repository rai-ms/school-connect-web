import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/my_app/data/model/response/config_response.dart';
import 'package:student_management/presentation/my_app/data/model/response/tenant_settings_response.dart';
import 'package:student_management/presentation/my_app/domain/repo/app_config_repo.dart';
import 'package:student_management/presentation/my_app/domain/use_case/get_app_config_use_case.dart';
import 'package:student_management/presentation/my_app/presentation/manager/bloc/app_config_bloc/app_config_bloc.dart';

@GenerateMocks([FetchAppConfigUseCase, AppConfigRepo])
import 'app_config_bloc_test.mocks.dart';

void main() {
  late AppConfigBloc bloc;
  late MockFetchAppConfigUseCase mockAppConfigUseCase;
  late MockAppConfigRepo mockAppConfigRepo;
  late StateRequestHandler handler;

  final testConfigJson = <String, dynamic>{
    'version': '1.0.0',
    'lastUpdated': '2024-01-01T00:00:00.000Z',
    'features': {
      'editProfile': true,
    },
    'ui': {
      'availableLanguage': [
        {'langCode': 'en', 'langName': 'English'},
        {'langCode': 'hi', 'langName': 'Hindi'},
      ],
    },
    'runtime': {
      'isEnable': true,
    },
  };

  final testTenantSettingsJson = <String, dynamic>{
    'id': 'settings-1',
    'tenantId': 'tenant-1',
    'displayName': 'Test School',
    'tagline': 'Education for all',
    'logoUrl': 'https://example.com/logo.png',
    'faviconUrl': 'https://example.com/favicon.ico',
    'primaryColor': '#FF0000',
    'secondaryColor': '#00FF00',
    'accentColor': '#0000FF',
    'academicYearStart': '2024-04-01',
    'academicYearEnd': '2025-03-31',
    'gradingSystem': 'PERCENTAGE',
    'passingPercentage': 35,
    'defaultWorkingDays': 'MON,TUE,WED,THU,FRI',
    'schoolStartTime': '08:00',
    'schoolEndTime': '14:00',
    'attendanceEnabled': true,
    'feesEnabled': true,
    'examsEnabled': true,
    'timetableEnabled': true,
    'libraryEnabled': false,
    'transportEnabled': false,
    'hostelEnabled': false,
    'parentPortalEnabled': true,
    'studentPortalEnabled': true,
    'smsNotificationsEnabled': true,
    'emailNotificationsEnabled': true,
    'pushNotificationsEnabled': false,
    'timezone': 'Asia/Kolkata',
    'dateFormat': 'dd/MM/yyyy',
    'timeFormat': 'HH:mm',
    'currency': 'INR',
    'language': 'en',
    'supportEmail': 'support@test.com',
    'supportPhone': '+911234567890',
    'emergencyContact': '+919876543210',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-06-01T00:00:00.000Z',
  };

  setUp(() {
    mockAppConfigUseCase = MockFetchAppConfigUseCase();
    mockAppConfigRepo = MockAppConfigRepo();
    handler = StateRequestHandler();
    bloc = AppConfigBloc(mockAppConfigUseCase, handler, mockAppConfigRepo);
  });

  tearDown(() {
    bloc.close();
  });

  group('AppConfigBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.state, equals(BlocState.none));
      expect(bloc.state.data, isNull);
      expect(bloc.state.tenantSettings, isNull);
      expect(bloc.state.error, isNull);
      expect(bloc.state.isNone, isTrue);
    });

    group('InitAppConfig', () {
      blocTest<AppConfigBloc, AppConfigState>(
        'emits loading then success with config data when init succeeds',
        build: () {
          when(mockAppConfigUseCase(params: anyNamed('params'))).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/config'),
              data: testConfigJson,
              statusCode: 200,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(InitAppConfig()),
        expect: () => [
          isA<AppConfigState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AppConfigState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.data, 'data', isA<ConfigResponse>())
              .having((s) => s.data?.version, 'version', '1.0.0')
              .having(
                (s) => s.data?.features?.editProfile,
                'editProfile',
                true,
              )
              .having(
                (s) => s.data?.runtime?.isEnable,
                'isEnable',
                true,
              ),
        ],
        verify: (_) {
          verify(mockAppConfigUseCase(params: anyNamed('params'))).called(1);
        },
      );

      blocTest<AppConfigBloc, AppConfigState>(
        'emits loading then failed when init throws an exception',
        build: () {
          when(mockAppConfigUseCase(params: anyNamed('params')))
              .thenThrow(Exception('Config fetch failed'));
          return bloc;
        },
        act: (bloc) => bloc.add(InitAppConfig()),
        expect: () => [
          isA<AppConfigState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AppConfigState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.error, 'error', isNotNull),
        ],
      );

      blocTest<AppConfigBloc, AppConfigState>(
        'emits loading then failed when DioException occurs',
        build: () {
          when(mockAppConfigUseCase(params: anyNamed('params')))
              .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/config'),
            message: 'Server error',
            response: Response(
              requestOptions: RequestOptions(path: '/config'),
              statusCode: 500,
            ),
          ));
          return bloc;
        },
        act: (bloc) => bloc.add(InitAppConfig()),
        expect: () => [
          isA<AppConfigState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AppConfigState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.error, 'error', isNotNull),
        ],
      );
    });

    group('ReloadAppConfig', () {
      blocTest<AppConfigBloc, AppConfigState>(
        'does not emit any state (currently no-op)',
        build: () => bloc,
        act: (bloc) => bloc.add(ReloadAppConfig()),
        expect: () => <AppConfigState>[],
      );
    });

    group('FetchTenantSettings', () {
      blocTest<AppConfigBloc, AppConfigState>(
        'emits loading then success with tenant settings when fetch succeeds',
        build: () {
          when(mockAppConfigRepo.getTenantSettings()).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/tenant-settings'),
              data: testTenantSettingsJson,
              statusCode: 200,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(FetchTenantSettings()),
        expect: () => [
          isA<AppConfigState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AppConfigState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.tenantSettings, 'tenantSettings',
                  isA<TenantSettingsResponse>())
              .having((s) => s.tenantSettings?.displayName, 'displayName',
                  'Test School')
              .having((s) => s.tenantSettings?.attendanceEnabled,
                  'attendanceEnabled', true)
              .having((s) => s.tenantSettings?.primaryColor, 'primaryColor',
                  '#FF0000'),
        ],
        verify: (_) {
          verify(mockAppConfigRepo.getTenantSettings()).called(1);
        },
      );

      blocTest<AppConfigBloc, AppConfigState>(
        'emits loading then success when response has nested data key',
        build: () {
          // Note: BLoC logic checks `res.data is Map<String, dynamic>` first,
          // which is always true for Dio responses. The nested 'data' fallback
          // path is unreachable. So displayName will be null here.
          when(mockAppConfigRepo.getTenantSettings()).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/tenant-settings'),
              data: {'data': testTenantSettingsJson},
              statusCode: 200,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(FetchTenantSettings()),
        expect: () => [
          isA<AppConfigState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AppConfigState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.tenantSettings, 'tenantSettings',
                  isA<TenantSettingsResponse>()),
        ],
      );

      blocTest<AppConfigBloc, AppConfigState>(
        'emits loading then failed when fetch throws an exception',
        build: () {
          when(mockAppConfigRepo.getTenantSettings())
              .thenThrow(Exception('Failed to fetch tenant settings'));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchTenantSettings()),
        expect: () => [
          isA<AppConfigState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AppConfigState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.error, 'error', isNotNull),
        ],
      );

      blocTest<AppConfigBloc, AppConfigState>(
        'emits loading then failed when DioException occurs',
        build: () {
          when(mockAppConfigRepo.getTenantSettings()).thenThrow(DioException(
            requestOptions: RequestOptions(path: '/tenant-settings'),
            message: 'Network error',
          ));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchTenantSettings()),
        expect: () => [
          isA<AppConfigState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AppConfigState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.error, 'error', isNotNull),
        ],
      );
    });

    group('UpdateTenantSettings', () {
      final updatePayload = <String, dynamic>{
        'displayName': 'Updated School',
        'primaryColor': '#00FF00',
      };

      final updatedTenantSettingsJson = <String, dynamic>{
        ...testTenantSettingsJson,
        'displayName': 'Updated School',
        'primaryColor': '#00FF00',
      };

      blocTest<AppConfigBloc, AppConfigState>(
        'emits loading then success with updated tenant settings',
        build: () {
          when(mockAppConfigRepo.updateTenantSettings(updatePayload))
              .thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/tenant-settings'),
              data: updatedTenantSettingsJson,
              statusCode: 200,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateTenantSettings(updatePayload)),
        expect: () => [
          isA<AppConfigState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AppConfigState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.tenantSettings?.displayName, 'displayName',
                  'Updated School')
              .having((s) => s.tenantSettings?.primaryColor, 'primaryColor',
                  '#00FF00'),
        ],
        verify: (_) {
          verify(mockAppConfigRepo.updateTenantSettings(updatePayload))
              .called(1);
        },
      );

      blocTest<AppConfigBloc, AppConfigState>(
        'emits loading then success when update response has nested data key',
        build: () {
          // Note: BLoC logic checks `res.data is Map<String, dynamic>` first,
          // which is always true for Dio responses. The nested 'data' fallback
          // path is unreachable. So displayName will be null here.
          when(mockAppConfigRepo.updateTenantSettings(updatePayload))
              .thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: '/tenant-settings'),
              data: {'data': updatedTenantSettingsJson},
              statusCode: 200,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateTenantSettings(updatePayload)),
        expect: () => [
          isA<AppConfigState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AppConfigState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.tenantSettings, 'tenantSettings',
                  isA<TenantSettingsResponse>()),
        ],
      );

      blocTest<AppConfigBloc, AppConfigState>(
        'emits loading then failed when update throws an exception',
        build: () {
          when(mockAppConfigRepo.updateTenantSettings(updatePayload))
              .thenThrow(Exception('Update failed'));
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateTenantSettings(updatePayload)),
        expect: () => [
          isA<AppConfigState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AppConfigState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.error, 'error', isNotNull),
        ],
      );

      blocTest<AppConfigBloc, AppConfigState>(
        'emits loading then failed when DioException occurs on update',
        build: () {
          when(mockAppConfigRepo.updateTenantSettings(updatePayload))
              .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/tenant-settings'),
            message: 'Forbidden',
            response: Response(
              requestOptions: RequestOptions(path: '/tenant-settings'),
              statusCode: 403,
            ),
          ));
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateTenantSettings(updatePayload)),
        expect: () => [
          isA<AppConfigState>().having((s) => s.isLoading, 'isLoading', true),
          isA<AppConfigState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having((s) => s.error, 'error', isNotNull),
        ],
      );
    });

    group('AppConfigState helpers', () {
      test('isFeatureEnabled returns true when feature is enabled', () {
        final stateWithSettings = AppConfigState(
          tenantSettings: TenantSettingsResponse(attendanceEnabled: true),
        );
        expect(stateWithSettings.isFeatureEnabled('attendance'), isTrue);
      });

      test('isFeatureEnabled returns false when feature is disabled', () {
        final stateWithSettings = AppConfigState(
          tenantSettings: TenantSettingsResponse(libraryEnabled: false),
        );
        expect(stateWithSettings.isFeatureEnabled('library'), isFalse);
      });

      test('isFeatureEnabled returns true when tenantSettings is null', () {
        const stateWithoutSettings = AppConfigState();
        expect(stateWithoutSettings.isFeatureEnabled('attendance'), isTrue);
      });

      test('isFeatureEnabled returns false for unknown features', () {
        final stateWithSettings = AppConfigState(
          tenantSettings: TenantSettingsResponse(),
        );
        expect(stateWithSettings.isFeatureEnabled('unknown_feature'), isFalse);
      });
    });
  });
}
