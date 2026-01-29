import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/timetable/data/models/period_model.dart';
import 'package:student_management/presentation/views/timetable/data/models/timetable_entry_model.dart';
import 'package:student_management/presentation/views/timetable/data/repositories/timetable_repository.dart';
import 'package:student_management/presentation/views/timetable/presentation/manager/timetable_bloc/timetable_bloc.dart';

@GenerateMocks([TimetableRepository])
import 'timetable_bloc_test.mocks.dart';

void main() {
  late TimetableBloc bloc;
  late MockTimetableRepository mockRepository;
  late StateRequestHandler handler;

  final testPeriods = [
    PeriodResponse(
      id: 'per-1',
      periodNumber: 1,
      name: 'Period 1',
      startTime: '08:00',
      endTime: '08:45',
      isBreak: false,
      isActive: true,
    ),
    PeriodResponse(
      id: 'per-2',
      periodNumber: 2,
      name: 'Period 2',
      startTime: '08:45',
      endTime: '09:30',
      isBreak: false,
      isActive: true,
    ),
  ];

  final testEntries = [
    TimetableEntryResponse(
      id: 'entry-1',
      dayOfWeek: 'MONDAY',
      period: testPeriods[0],
      classId: 'cls-1',
      subjectName: 'Mathematics',
      teacherName: 'Mr. Kumar',
      room: 'Room 101',
    ),
    TimetableEntryResponse(
      id: 'entry-2',
      dayOfWeek: 'MONDAY',
      period: testPeriods[1],
      classId: 'cls-1',
      subjectName: 'Science',
      teacherName: 'Ms. Sharma',
      room: 'Lab 1',
    ),
  ];

  final testWeeklyTimetable = <String, List<TimetableEntryResponse>>{
    'MONDAY': testEntries,
    'TUESDAY': [testEntries[0]],
  };

  final testPeriodRequest = PeriodRequest(
    periodNumber: 3,
    name: 'Period 3',
    startTime: '09:30',
    endTime: '10:15',
  );

  final testEntryRequest = TimetableEntryRequest(
    dayOfWeek: 'WEDNESDAY',
    periodId: 'per-1',
    classId: 'cls-1',
    subjectName: 'English',
    teacherName: 'Mrs. Patel',
    room: 'Room 203',
  );

  setUp(() {
    mockRepository = MockTimetableRepository();
    handler = StateRequestHandler();
    bloc = TimetableBloc(mockRepository, handler);
  });

  tearDown(() {
    bloc.close();
  });

  group('TimetableBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.periods, isEmpty);
      expect(bloc.state.entries, isEmpty);
      expect(bloc.state.weeklyTimetable, isEmpty);
      expect(bloc.state.isNone, isTrue);
    });

    group('FetchPeriods', () {
      blocTest<TimetableBloc, TimetableState>(
        'emits loading then success with periods when fetch succeeds',
        build: () {
          when(mockRepository.getActivePeriods())
              .thenAnswer((_) async => testPeriods);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPeriods()),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.periods.length, 'periods.length', 2)
              .having(
                  (s) => s.periods.first.name, 'first period name', 'Period 1'),
        ],
        verify: (_) {
          verify(mockRepository.getActivePeriods()).called(1);
        },
      );

      blocTest<TimetableBloc, TimetableState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getActivePeriods())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPeriods()),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getActivePeriods()).called(1);
        },
      );
    });

    group('FetchClassTimetable', () {
      blocTest<TimetableBloc, TimetableState>(
        'emits loading then success with entries when fetch succeeds',
        build: () {
          when(mockRepository.getClassTimetable('cls-1'))
              .thenAnswer((_) async => testEntries);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchClassTimetable('cls-1')),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.entries.length, 'entries.length', 2)
              .having((s) => s.entries.first.subjectName, 'first subject',
                  'Mathematics'),
        ],
        verify: (_) {
          verify(mockRepository.getClassTimetable('cls-1')).called(1);
        },
      );

      blocTest<TimetableBloc, TimetableState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getClassTimetable('cls-1'))
              .thenAnswer((_) async => throw Exception('Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchClassTimetable('cls-1')),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getClassTimetable('cls-1')).called(1);
        },
      );
    });

    group('FetchTeacherTimetable', () {
      blocTest<TimetableBloc, TimetableState>(
        'emits loading then success with entries when fetch succeeds',
        build: () {
          when(mockRepository.getTeacherTimetable('tch-1'))
              .thenAnswer((_) async => testEntries);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTeacherTimetable('tch-1')),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.entries.length, 'entries.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getTeacherTimetable('tch-1')).called(1);
        },
      );

      blocTest<TimetableBloc, TimetableState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getTeacherTimetable('tch-1'))
              .thenAnswer((_) async => throw Exception('Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTeacherTimetable('tch-1')),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getTeacherTimetable('tch-1')).called(1);
        },
      );
    });

    group('FetchClassWeeklyTimetable', () {
      blocTest<TimetableBloc, TimetableState>(
        'emits loading then success with weeklyTimetable when fetch succeeds',
        build: () {
          when(mockRepository.getClassWeeklyTimetable('cls-1'))
              .thenAnswer((_) async => testWeeklyTimetable);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchClassWeeklyTimetable('cls-1')),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.weeklyTimetable.length,
                  'weeklyTimetable.length', 2)
              .having((s) => s.weeklyTimetable.containsKey('MONDAY'),
                  'has MONDAY', true)
              .having((s) => s.weeklyTimetable.containsKey('TUESDAY'),
                  'has TUESDAY', true),
        ],
        verify: (_) {
          verify(mockRepository.getClassWeeklyTimetable('cls-1')).called(1);
        },
      );

      blocTest<TimetableBloc, TimetableState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getClassWeeklyTimetable('cls-1'))
              .thenAnswer((_) async => throw Exception('Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchClassWeeklyTimetable('cls-1')),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getClassWeeklyTimetable('cls-1')).called(1);
        },
      );
    });

    group('FetchTeacherWeeklyTimetable', () {
      blocTest<TimetableBloc, TimetableState>(
        'emits loading then success with weeklyTimetable when fetch succeeds',
        build: () {
          when(mockRepository.getTeacherWeeklyTimetable('tch-1'))
              .thenAnswer((_) async => testWeeklyTimetable);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTeacherWeeklyTimetable('tch-1')),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.weeklyTimetable.length,
                  'weeklyTimetable.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getTeacherWeeklyTimetable('tch-1')).called(1);
        },
      );

      blocTest<TimetableBloc, TimetableState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getTeacherWeeklyTimetable('tch-1'))
              .thenAnswer((_) async => throw Exception('Error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTeacherWeeklyTimetable('tch-1')),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getTeacherWeeklyTimetable('tch-1')).called(1);
        },
      );
    });

    group('CreatePeriod', () {
      blocTest<TimetableBloc, TimetableState>(
        'emits loading then success when create succeeds',
        build: () {
          when(mockRepository.createPeriod(testPeriodRequest)).thenAnswer(
            (_) async => PeriodResponse(
              id: 'per-3',
              periodNumber: 3,
              name: 'Period 3',
              startTime: '09:30',
              endTime: '10:15',
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CreatePeriod(testPeriodRequest)),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.createPeriod(testPeriodRequest)).called(1);
        },
      );

      blocTest<TimetableBloc, TimetableState>(
        'emits loading then failed when create throws',
        build: () {
          when(mockRepository.createPeriod(testPeriodRequest))
              .thenAnswer((_) async => throw Exception('Create error'));
          return bloc;
        },
        act: (bloc) => bloc.add(CreatePeriod(testPeriodRequest)),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.createPeriod(testPeriodRequest)).called(1);
        },
      );
    });

    group('CreateTimetableEntry', () {
      blocTest<TimetableBloc, TimetableState>(
        'emits loading then success when create succeeds',
        build: () {
          when(mockRepository.createEntry(testEntryRequest)).thenAnswer(
            (_) async => TimetableEntryResponse(
              id: 'entry-3',
              dayOfWeek: 'WEDNESDAY',
              subjectName: 'English',
              teacherName: 'Mrs. Patel',
              room: 'Room 203',
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CreateTimetableEntry(testEntryRequest)),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.createEntry(testEntryRequest)).called(1);
        },
      );

      blocTest<TimetableBloc, TimetableState>(
        'emits loading then failed when create throws',
        build: () {
          when(mockRepository.createEntry(testEntryRequest))
              .thenAnswer((_) async => throw Exception('Create error'));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateTimetableEntry(testEntryRequest)),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.createEntry(testEntryRequest)).called(1);
        },
      );
    });

    group('UpdateTimetableEntry', () {
      blocTest<TimetableBloc, TimetableState>(
        'emits loading then success when update succeeds',
        build: () {
          when(mockRepository.updateEntry('entry-1', testEntryRequest))
              .thenAnswer(
            (_) async => TimetableEntryResponse(
              id: 'entry-1',
              dayOfWeek: 'WEDNESDAY',
              subjectName: 'English',
              teacherName: 'Mrs. Patel',
              room: 'Room 203',
            ),
          );
          return bloc;
        },
        act: (bloc) =>
            bloc.add(UpdateTimetableEntry('entry-1', testEntryRequest)),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.updateEntry('entry-1', testEntryRequest))
              .called(1);
        },
      );

      blocTest<TimetableBloc, TimetableState>(
        'emits loading then failed when update throws',
        build: () {
          when(mockRepository.updateEntry('entry-1', testEntryRequest))
              .thenAnswer((_) async => throw Exception('Update error'));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(UpdateTimetableEntry('entry-1', testEntryRequest)),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.updateEntry('entry-1', testEntryRequest))
              .called(1);
        },
      );
    });

    group('DeleteTimetableEntry', () {
      blocTest<TimetableBloc, TimetableState>(
        'emits loading then success when delete succeeds',
        build: () {
          when(mockRepository.deleteEntry('entry-1'))
              .thenAnswer((_) async {});
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteTimetableEntry('entry-1')),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.deleteEntry('entry-1')).called(1);
        },
      );

      blocTest<TimetableBloc, TimetableState>(
        'emits loading then failed when delete throws',
        build: () {
          when(mockRepository.deleteEntry('entry-1'))
              .thenAnswer((_) async => throw Exception('Delete error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteTimetableEntry('entry-1')),
        expect: () => [
          isA<TimetableState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TimetableState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.deleteEntry('entry-1')).called(1);
        },
      );
    });
  });
}
