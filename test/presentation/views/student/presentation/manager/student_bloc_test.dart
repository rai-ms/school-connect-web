import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/student/data/models/student_model.dart';
import 'package:student_management/presentation/views/student/data/repositories/student_repository.dart';
import 'package:student_management/presentation/views/student/presentation/manager/student_bloc/student_bloc.dart';

@GenerateMocks([StudentRepository])
import 'student_bloc_test.mocks.dart';

void main() {
  late StudentBloc bloc;
  late MockStudentRepository mockRepository;
  late StateRequestHandler handler;

  final testStudents = [
    StudentResponse(
      id: '1',
      rollNumber: 'R001',
      firstName: 'Rahul',
      lastName: 'Sharma',
      fullName: 'Rahul Sharma',
      gender: 'MALE',
      status: 'ACTIVE',
    ),
    StudentResponse(
      id: '2',
      rollNumber: 'R002',
      firstName: 'Priya',
      lastName: 'Patel',
      fullName: 'Priya Patel',
      gender: 'FEMALE',
      status: 'ACTIVE',
    ),
  ];

  setUp(() {
    mockRepository = MockStudentRepository();
    handler = StateRequestHandler();
    bloc = StudentBloc(mockRepository, handler);
  });

  tearDown(() {
    bloc.close();
  });

  group('StudentBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.students, isEmpty);
      expect(bloc.state.selectedStudent, isNull);
      expect(bloc.state.statistics, isNull);
      expect(bloc.state.actionCompleted, isFalse);
      expect(bloc.state.isNone, isTrue);
    });

    group('FetchStudents', () {
      blocTest<StudentBloc, StudentState>(
        'emits loading then success with students when fetch succeeds',
        build: () {
          when(mockRepository.getAllStudents()).thenAnswer(
            (_) async => testStudents,
          );
          return bloc;
        },
        act: (bloc) => bloc.add(FetchStudents()),
        expect: () => [
          isA<StudentState>().having((s) => s.isLoading, 'isLoading', true),
          isA<StudentState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.students.length, 'students.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getAllStudents()).called(1);
        },
      );

      blocTest<StudentBloc, StudentState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getAllStudents())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(FetchStudents()),
        expect: () => [
          isA<StudentState>().having((s) => s.isLoading, 'isLoading', true),
          isA<StudentState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getAllStudents()).called(1);
        },
      );
    });

    group('FetchStudentById', () {
      blocTest<StudentBloc, StudentState>(
        'emits loading then success with selected student',
        build: () {
          when(mockRepository.getStudentById('1')).thenAnswer(
            (_) async => testStudents[0],
          );
          return bloc;
        },
        act: (bloc) => bloc.add(FetchStudentById('1')),
        expect: () => [
          isA<StudentState>().having((s) => s.isLoading, 'isLoading', true),
          isA<StudentState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.selectedStudent?.firstName, 'firstName', 'Rahul'),
        ],
        verify: (_) {
          verify(mockRepository.getStudentById('1')).called(1);
        },
      );
    });

    group('SearchStudents', () {
      blocTest<StudentBloc, StudentState>(
        'emits students matching search query',
        build: () {
          when(mockRepository.searchStudents('Rahul')).thenAnswer(
            (_) async => [testStudents[0]],
          );
          return bloc;
        },
        act: (bloc) => bloc.add(SearchStudents('Rahul')),
        expect: () => [
          isA<StudentState>().having((s) => s.isLoading, 'isLoading', true),
          isA<StudentState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.students.length, 'students.length', 1)
              .having(
                  (s) => s.students.first.firstName, 'firstName', 'Rahul'),
        ],
      );
    });

    group('CreateStudent', () {
      final request = CreateStudentRequest(
        rollNumber: 'R003',
        firstName: 'Amit',
        lastName: 'Kumar',
        dateOfBirth: '2010-08-10',
        gender: 'MALE',
        currentClassId: 'class-1',
        currentSectionId: 'sec-1',
        admissionDate: '2024-04-01',
      );

      blocTest<StudentBloc, StudentState>(
        'emits actionCompleted true on successful create',
        build: () {
          when(mockRepository.createStudent(request)).thenAnswer(
            (_) async => StudentResponse(
              id: '3',
              rollNumber: 'R003',
              firstName: 'Amit',
              lastName: 'Kumar',
              fullName: 'Amit Kumar',
              gender: 'MALE',
              status: 'ACTIVE',
            ),
          );
          when(mockRepository.getAllStudents()).thenAnswer(
            (_) async => [...testStudents],
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CreateStudent(request)),
        expect: () => [
          isA<StudentState>().having((s) => s.isLoading, 'isLoading', true),
          isA<StudentState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.actionCompleted, 'actionCompleted', true),
        ],
      );
    });

    group('DeleteStudent', () {
      blocTest<StudentBloc, StudentState>(
        'emits actionCompleted true on successful delete',
        build: () {
          when(mockRepository.deleteStudent('1')).thenAnswer(
            (_) async {},
          );
          when(mockRepository.getAllStudents()).thenAnswer(
            (_) async => [testStudents[1]],
          );
          return bloc;
        },
        act: (bloc) => bloc.add(DeleteStudent('1')),
        expect: () => [
          isA<StudentState>().having((s) => s.isLoading, 'isLoading', true),
          isA<StudentState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.actionCompleted, 'actionCompleted', true)
              .having((s) => s.students.length, 'students.length', 1),
        ],
      );
    });

    group('FetchStudentStatistics', () {
      blocTest<StudentBloc, StudentState>(
        'fetches student statistics successfully',
        build: () {
          when(mockRepository.getStatistics()).thenAnswer(
            (_) async => StudentStatistics(
              totalStudents: 100,
              activeStudents: 95,
              inactiveStudents: 5,
              byGender: {'MALE': 55, 'FEMALE': 45},
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(FetchStudentStatistics()),
        expect: () => [
          isA<StudentState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.statistics?.totalStudents, 'totalStudents', 100),
        ],
      );
    });
  });
}
