import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/attendance/data/models/attendance_model.dart';
import 'package:student_management/presentation/views/attendance/data/repositories/attendance_repository.dart';
import 'package:student_management/presentation/views/attendance/presentation/manager/attendance_bloc/attendance_bloc.dart';

@GenerateMocks([AttendanceRepository])
import 'attendance_bloc_test.mocks.dart';

void main() {
  late AttendanceBloc bloc;
  late MockAttendanceRepository mockRepository;
  late StateRequestHandler handler;

  final testRecords = [
    AttendanceResponse(
      id: 'att-1',
      studentId: 'stu-1',
      studentName: 'Rahul Sharma',
      rollNumber: 'R001',
      classId: 'cls-1',
      attendanceDate: '2025-01-15',
      status: 'PRESENT',
      session: 'FULL_DAY',
    ),
    AttendanceResponse(
      id: 'att-2',
      studentId: 'stu-2',
      studentName: 'Priya Patel',
      rollNumber: 'R002',
      classId: 'cls-1',
      attendanceDate: '2025-01-15',
      status: 'ABSENT',
      session: 'FULL_DAY',
    ),
  ];

  final testPercentage = AttendancePercentage(
    percentage: 92.5,
    totalDays: 200,
    presentDays: 185,
    absentDays: 10,
    lateDays: 5,
  );

  final testMarkRequest = MarkAttendanceRequest(
    attendanceDate: '2025-01-15',
    classId: 'cls-1',
    session: 'FULL_DAY',
    studentAttendance: [
      StudentAttendanceRecord(studentId: 'stu-1', status: 'PRESENT'),
      StudentAttendanceRecord(studentId: 'stu-2', status: 'ABSENT'),
    ],
  );

  setUp(() {
    mockRepository = MockAttendanceRepository();
    handler = StateRequestHandler();
    bloc = AttendanceBloc(mockRepository, handler);
  });

  tearDown(() {
    bloc.close();
  });

  group('AttendanceBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.records, isEmpty);
      expect(bloc.state.percentage, isNull);
      expect(bloc.state.attendanceMarked, isFalse);
      expect(bloc.state.isNone, isTrue);
    });

    group('MarkBulkAttendance', () {
      blocTest<AttendanceBloc, AttendanceState>(
        'emits loading then success with attendanceMarked true when marking succeeds',
        build: () {
          when(mockRepository.markBulkAttendance(testMarkRequest))
              .thenAnswer((_) async {});
          return bloc;
        },
        act: (bloc) => bloc.add(MarkBulkAttendance(testMarkRequest)),
        expect: () => [
          isA<AttendanceState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<AttendanceState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.attendanceMarked, 'attendanceMarked', true),
        ],
        verify: (_) {
          verify(mockRepository.markBulkAttendance(testMarkRequest)).called(1);
        },
      );

      blocTest<AttendanceBloc, AttendanceState>(
        'emits loading then failed when marking throws',
        build: () {
          when(mockRepository.markBulkAttendance(testMarkRequest))
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(MarkBulkAttendance(testMarkRequest)),
        expect: () => [
          isA<AttendanceState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<AttendanceState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.markBulkAttendance(testMarkRequest)).called(1);
        },
      );
    });

    group('FetchClassAttendance', () {
      blocTest<AttendanceBloc, AttendanceState>(
        'emits loading then success with records when fetch succeeds',
        build: () {
          when(mockRepository.getAttendanceByClass('cls-1', '2025-01-15'))
              .thenAnswer((_) async => testRecords);
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchClassAttendance('cls-1', '2025-01-15')),
        expect: () => [
          isA<AttendanceState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<AttendanceState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.records.length, 'records.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getAttendanceByClass('cls-1', '2025-01-15'))
              .called(1);
        },
      );

      blocTest<AttendanceBloc, AttendanceState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getAttendanceByClass('cls-1', '2025-01-15'))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchClassAttendance('cls-1', '2025-01-15')),
        expect: () => [
          isA<AttendanceState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<AttendanceState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getAttendanceByClass('cls-1', '2025-01-15'))
              .called(1);
        },
      );
    });

    group('FetchStudentAttendance', () {
      blocTest<AttendanceBloc, AttendanceState>(
        'emits loading then success with records when fetch succeeds',
        build: () {
          when(mockRepository.getStudentAttendance('stu-1'))
              .thenAnswer((_) async => testRecords);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchStudentAttendance('stu-1')),
        expect: () => [
          isA<AttendanceState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<AttendanceState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.records.length, 'records.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getStudentAttendance('stu-1')).called(1);
        },
      );

      blocTest<AttendanceBloc, AttendanceState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getStudentAttendance('stu-1'))
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchStudentAttendance('stu-1')),
        expect: () => [
          isA<AttendanceState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<AttendanceState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getStudentAttendance('stu-1')).called(1);
        },
      );
    });

    group('FetchStudentAttendancePercentage', () {
      blocTest<AttendanceBloc, AttendanceState>(
        'emits success with percentage when fetch succeeds',
        build: () {
          when(mockRepository.getStudentAttendancePercentage('stu-1'))
              .thenAnswer((_) async => testPercentage);
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchStudentAttendancePercentage('stu-1')),
        expect: () => [
          isA<AttendanceState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.percentage?.percentage, 'percentage', 92.5)
              .having(
                  (s) => s.percentage?.totalDays, 'totalDays', 200)
              .having(
                  (s) => s.percentage?.presentDays, 'presentDays', 185),
        ],
        verify: (_) {
          verify(mockRepository.getStudentAttendancePercentage('stu-1'))
              .called(1);
        },
      );

      blocTest<AttendanceBloc, AttendanceState>(
        'does not emit failed state when fetch throws (no emit in error handler)',
        build: () {
          when(mockRepository.getStudentAttendancePercentage('stu-1'))
              .thenAnswer((_) async => throw Exception('Error'));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchStudentAttendancePercentage('stu-1')),
        expect: () => [],
        verify: (_) {
          verify(mockRepository.getStudentAttendancePercentage('stu-1'))
              .called(1);
        },
      );
    });

    group('FetchAttendanceByDate', () {
      blocTest<AttendanceBloc, AttendanceState>(
        'emits loading then success with records when fetch succeeds',
        build: () {
          when(mockRepository.getAttendanceByDate('2025-01-15'))
              .thenAnswer((_) async => testRecords);
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchAttendanceByDate('2025-01-15')),
        expect: () => [
          isA<AttendanceState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<AttendanceState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.records.length, 'records.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getAttendanceByDate('2025-01-15')).called(1);
        },
      );

      blocTest<AttendanceBloc, AttendanceState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getAttendanceByDate('2025-01-15'))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchAttendanceByDate('2025-01-15')),
        expect: () => [
          isA<AttendanceState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<AttendanceState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getAttendanceByDate('2025-01-15')).called(1);
        },
      );
    });
  });
}
