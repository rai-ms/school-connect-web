import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/dashboard/data/models/res/school_admin/dashboard_stats_model.dart';
import 'package:student_management/presentation/views/dashboard/data/repositories/school_admin_dashboard_repository.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/school_admin/bloc/school_admin_dashboard_bloc/school_admin_dashboard_bloc.dart';
import 'package:student_management/presentation/views/fee/data/models/fee_payment_model.dart';

@GenerateMocks([SchoolAdminDashboardRepository])
import 'school_admin_dashboard_bloc_test.mocks.dart';

void main() {
  late SchoolAdminDashboardBloc bloc;
  late MockSchoolAdminDashboardRepository mockRepository;
  late StateRequestHandler handler;

  final testStats = TenantStatistics(
    totalStudents: 500,
    totalTeachers: 30,
    totalParents: 400,
    activeUsers: 950,
    totalClasses: 20,
    attendancePercentage: 92.5,
    storageUsedMb: 256,
    studentsByClass: {'Class 10': 50, 'Class 9': 48},
  );

  final testFeeReport = CollectionReport(
    totalCollected: 2500000.0,
    totalPending: 750000.0,
    overdueCount: 15,
    monthlyCollection: 350000.0,
  );

  setUp(() {
    mockRepository = MockSchoolAdminDashboardRepository();
    handler = StateRequestHandler();
    bloc = SchoolAdminDashboardBloc(handler, mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('SchoolAdminDashboardBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.tenantStats, isNull);
      expect(bloc.state.feeReport, isNull);
      expect(bloc.state.pendingLeaveCount, 0);
      expect(bloc.state.isNone, isTrue);
    });

    group('FetchDashboardStats', () {
      blocTest<SchoolAdminDashboardBloc, SchoolAdminDashboardState>(
        'emits loading then success with tenant stats',
        build: () {
          when(mockRepository.getTenantStatistics()).thenAnswer(
            (_) async => testStats,
          );
          return bloc;
        },
        act: (bloc) => bloc.add(FetchDashboardStats()),
        expect: () => [
          isA<SchoolAdminDashboardState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<SchoolAdminDashboardState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.tenantStats?.totalStudents, 'totalStudents', 500)
              .having(
                  (s) => s.tenantStats?.totalTeachers, 'totalTeachers', 30)
              .having((s) => s.tenantStats?.attendancePercentage,
                  'attendance', 92.5),
        ],
      );
    });

    group('FetchFeeReport', () {
      blocTest<SchoolAdminDashboardBloc, SchoolAdminDashboardState>(
        'emits loading then success with fee report',
        build: () {
          when(mockRepository.getFeeCollectionReport()).thenAnswer(
            (_) async => testFeeReport,
          );
          return bloc;
        },
        act: (bloc) => bloc.add(FetchFeeReport()),
        expect: () => [
          isA<SchoolAdminDashboardState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<SchoolAdminDashboardState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.feeReport?.totalCollected, 'collected',
                  2500000.0)
              .having(
                  (s) => s.feeReport?.overdueCount, 'overdueCount', 15),
        ],
      );
    });

    group('FetchPendingLeaves', () {
      blocTest<SchoolAdminDashboardBloc, SchoolAdminDashboardState>(
        'emits loading then success with pending leave count',
        build: () {
          when(mockRepository.getPendingLeaveCount()).thenAnswer(
            (_) async => 7,
          );
          return bloc;
        },
        act: (bloc) => bloc.add(FetchPendingLeaves()),
        expect: () => [
          isA<SchoolAdminDashboardState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<SchoolAdminDashboardState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.pendingLeaveCount, 'pendingLeaves', 7),
        ],
      );
    });

    group('RefreshDashboard', () {
      blocTest<SchoolAdminDashboardBloc, SchoolAdminDashboardState>(
        'fetches all data in parallel on refresh',
        build: () {
          when(mockRepository.getTenantStatistics()).thenAnswer(
            (_) async => testStats,
          );
          when(mockRepository.getFeeCollectionReport()).thenAnswer(
            (_) async => testFeeReport,
          );
          when(mockRepository.getPendingLeaveCount()).thenAnswer(
            (_) async => 3,
          );
          return bloc;
        },
        act: (bloc) => bloc.add(RefreshDashboard()),
        expect: () => [
          isA<SchoolAdminDashboardState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<SchoolAdminDashboardState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.tenantStats?.totalStudents, 'students', 500)
              .having((s) => s.feeReport?.totalCollected, 'collected',
                  2500000.0)
              .having((s) => s.pendingLeaveCount, 'leaves', 3),
        ],
        verify: (_) {
          verify(mockRepository.getTenantStatistics()).called(1);
          verify(mockRepository.getFeeCollectionReport()).called(1);
          verify(mockRepository.getPendingLeaveCount()).called(1);
        },
      );

      blocTest<SchoolAdminDashboardBloc, SchoolAdminDashboardState>(
        'emits failed state when refresh throws',
        build: () {
          when(mockRepository.getTenantStatistics())
              .thenThrow(Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(RefreshDashboard()),
        expect: () => [
          isA<SchoolAdminDashboardState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<SchoolAdminDashboardState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
      );
    });
  });

  group('TenantStatistics model', () {
    test('fromJson parses correctly', () {
      final json = {
        'totalStudents': 500,
        'totalTeachers': 30,
        'totalParents': 400,
        'activeUsers': 950,
        'totalClasses': 20,
        'attendancePercentage': 92.5,
        'storageUsedMb': 256,
        'usersByRole': {'STUDENT': 500, 'TEACHER': 30},
        'studentsByClass': {'Class 10': 50},
      };

      final stats = TenantStatistics.fromJson(json);
      expect(stats.totalStudents, 500);
      expect(stats.totalTeachers, 30);
      expect(stats.attendancePercentage, 92.5);
      expect(stats.totalClasses, 20);
      expect(stats.studentsByClass['Class 10'], 50);
    });

    test('fromJson handles missing fields with defaults', () {
      final stats = TenantStatistics.fromJson({});
      expect(stats.totalStudents, 0);
      expect(stats.totalTeachers, 0);
      expect(stats.attendancePercentage, 0.0);
      expect(stats.studentsByClass, isEmpty);
    });

    test('totalStaff calculated correctly', () {
      final stats = TenantStatistics(
        activeUsers: 100,
        totalStudents: 60,
        totalTeachers: 20,
        totalParents: 10,
      );
      expect(stats.totalStaff, 10);
    });
  });

  group('CollectionReport model', () {
    test('fromJson parses correctly', () {
      final json = {
        'totalCollected': 2500000.0,
        'totalPending': 750000.0,
        'overdueCount': 15,
        'monthlyCollection': 350000.0,
      };

      final report = CollectionReport.fromJson(json);
      expect(report.totalCollected, 2500000.0);
      expect(report.totalPending, 750000.0);
      expect(report.overdueCount, 15);
      expect(report.monthlyCollection, 350000.0);
    });

    test('fromJson handles missing fields with defaults', () {
      final report = CollectionReport.fromJson({});
      expect(report.totalCollected, 0.0);
      expect(report.totalPending, 0.0);
      expect(report.overdueCount, 0);
    });
  });
}
