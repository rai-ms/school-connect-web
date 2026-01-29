import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/base/paginated_response.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/teacher/data/models/teacher_model.dart';
import 'package:student_management/presentation/views/teacher/data/repositories/teacher_repository.dart';
import 'package:student_management/presentation/views/teacher/presentation/manager/teacher_bloc/teacher_bloc.dart';

@GenerateMocks([TeacherRepository])
import 'teacher_bloc_test.mocks.dart';

void main() {
  late TeacherBloc bloc;
  late MockTeacherRepository mockRepository;
  late StateRequestHandler handler;

  final testTeachers = [
    TeacherResponse(
      id: '1',
      employeeId: 'EMP001',
      firstName: 'Rajesh',
      lastName: 'Kumar',
      fullName: 'Rajesh Kumar',
      gender: 'MALE',
      email: 'rajesh@school.com',
      phone: '9876543210',
      designation: 'Senior Teacher',
      department: 'Mathematics',
      status: 'ACTIVE',
      subjects: ['Mathematics', 'Physics'],
    ),
    TeacherResponse(
      id: '2',
      employeeId: 'EMP002',
      firstName: 'Sunita',
      lastName: 'Devi',
      fullName: 'Sunita Devi',
      gender: 'FEMALE',
      email: 'sunita@school.com',
      phone: '9876543211',
      designation: 'Teacher',
      department: 'English',
      status: 'ACTIVE',
      subjects: ['English', 'Hindi'],
    ),
  ];

  setUp(() {
    mockRepository = MockTeacherRepository();
    handler = StateRequestHandler();
    bloc = TeacherBloc(mockRepository, handler);
  });

  tearDown(() {
    bloc.close();
  });

  group('TeacherBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.teachers, isEmpty);
      expect(bloc.state.selectedTeacher, isNull);
      expect(bloc.state.actionCompleted, isFalse);
      expect(bloc.state.currentPage, equals(0));
      expect(bloc.state.totalPages, equals(0));
      expect(bloc.state.hasMore, isTrue);
      expect(bloc.state.isLoadingMore, isFalse);
      expect(bloc.state.isNone, isTrue);
    });

    // ===== FetchTeachers =====
    group('FetchTeachers', () {
      blocTest<TeacherBloc, TeacherState>(
        'emits loading then success with teachers when fetch succeeds',
        build: () {
          when(mockRepository.getAllTeachers(page: 0, size: 20))
              .thenAnswer(
            (_) async => PaginatedResponse.fromList(testTeachers),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTeachers()),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TeacherState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.teachers.length, 'teachers.length', 2)
              .having((s) => s.hasMore, 'hasMore', false),
        ],
        verify: (_) {
          verify(mockRepository.getAllTeachers(page: 0, size: 20))
              .called(1);
        },
      );

      blocTest<TeacherBloc, TeacherState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getAllTeachers(page: 0, size: 20))
              .thenAnswer(
                  (_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTeachers()),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TeacherState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getAllTeachers(page: 0, size: 20))
              .called(1);
        },
      );

      blocTest<TeacherBloc, TeacherState>(
        'emits isLoadingMore then success when loadMore is true',
        build: () {
          when(mockRepository.getAllTeachers(page: 1, size: 20))
              .thenAnswer(
            (_) async => PaginatedResponse<TeacherResponse>(
              content: [testTeachers[1]],
              totalPages: 2,
              totalElements: 3,
              number: 1,
              size: 20,
              last: true,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
            const FetchTeachers(page: 1, size: 20, loadMore: true)),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoadingMore, 'isLoadingMore', true),
          isA<TeacherState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.isLoadingMore, 'isLoadingMore', false)
              .having((s) => s.hasMore, 'hasMore', false),
        ],
        verify: (_) {
          verify(mockRepository.getAllTeachers(page: 1, size: 20))
              .called(1);
        },
      );

      blocTest<TeacherBloc, TeacherState>(
        'emits isLoadingMore then failed when loadMore throws',
        build: () {
          when(mockRepository.getAllTeachers(page: 1, size: 20))
              .thenAnswer(
                  (_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(
            const FetchTeachers(page: 1, size: 20, loadMore: true)),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoadingMore, 'isLoadingMore', true),
          isA<TeacherState>()
              .having((s) => s.isFailed, 'isFailed', true)
              .having(
                  (s) => s.isLoadingMore, 'isLoadingMore', false),
        ],
        verify: (_) {
          verify(mockRepository.getAllTeachers(page: 1, size: 20))
              .called(1);
        },
      );

      blocTest<TeacherBloc, TeacherState>(
        'uses custom page and size parameters',
        build: () {
          when(mockRepository.getAllTeachers(page: 2, size: 10))
              .thenAnswer(
            (_) async => PaginatedResponse<TeacherResponse>(
              content: [],
              totalPages: 3,
              totalElements: 22,
              number: 2,
              size: 10,
              last: true,
            ),
          );
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchTeachers(page: 2, size: 10)),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TeacherState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.currentPage, 'currentPage', 2)
              .having((s) => s.totalPages, 'totalPages', 3)
              .having((s) => s.hasMore, 'hasMore', false),
        ],
        verify: (_) {
          verify(mockRepository.getAllTeachers(page: 2, size: 10))
              .called(1);
        },
      );
    });

    // ===== FetchTeacherById =====
    group('FetchTeacherById', () {
      blocTest<TeacherBloc, TeacherState>(
        'emits loading then success with selected teacher',
        build: () {
          when(mockRepository.getTeacherById('1'))
              .thenAnswer((_) async => testTeachers[0]);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTeacherById('1')),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TeacherState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.selectedTeacher?.fullName, 'fullName',
                  'Rajesh Kumar')
              .having((s) => s.selectedTeacher?.employeeId,
                  'employeeId', 'EMP001'),
        ],
        verify: (_) {
          verify(mockRepository.getTeacherById('1')).called(1);
        },
      );

      blocTest<TeacherBloc, TeacherState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getTeacherById('1'))
              .thenAnswer((_) async => throw Exception('Not found'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchTeacherById('1')),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TeacherState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getTeacherById('1')).called(1);
        },
      );
    });

    // ===== CreateTeacher =====
    group('CreateTeacher', () {
      final request = CreateTeacherRequest(
        employeeId: 'EMP003',
        firstName: 'Amit',
        lastName: 'Singh',
        dateOfBirth: '1985-05-15',
        gender: 'MALE',
        email: 'amit@school.com',
        phone: '9876543212',
        joiningDate: '2024-06-01',
        designation: 'Teacher',
      );

      blocTest<TeacherBloc, TeacherState>(
        'emits loading then success with actionCompleted and refreshed teachers',
        build: () {
          when(mockRepository.createTeacher(request)).thenAnswer(
            (_) async => TeacherResponse(
              id: '3',
              employeeId: 'EMP003',
              firstName: 'Amit',
              lastName: 'Singh',
              fullName: 'Amit Singh',
              gender: 'MALE',
              designation: 'Teacher',
              status: 'ACTIVE',
            ),
          );
          when(mockRepository.getAllTeachers()).thenAnswer(
            (_) async =>
                PaginatedResponse.fromList([...testTeachers]),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CreateTeacher(request)),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TeacherState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.actionCompleted, 'actionCompleted', true)
              .having(
                  (s) => s.teachers.length, 'teachers.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.createTeacher(request)).called(1);
          verify(mockRepository.getAllTeachers()).called(1);
        },
      );

      blocTest<TeacherBloc, TeacherState>(
        'emits loading then failed when create throws',
        build: () {
          when(mockRepository.createTeacher(request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateTeacher(request)),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TeacherState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.createTeacher(request)).called(1);
        },
      );
    });

    // ===== UpdateTeacher =====
    group('UpdateTeacher', () {
      final updates = <String, dynamic>{
        'designation': 'Senior Teacher',
        'department': 'Science',
      };

      blocTest<TeacherBloc, TeacherState>(
        'emits loading then success with updated teacher and actionCompleted',
        build: () {
          when(mockRepository.updateTeacher('2', updates)).thenAnswer(
            (_) async => TeacherResponse(
              id: '2',
              employeeId: 'EMP002',
              firstName: 'Sunita',
              lastName: 'Devi',
              fullName: 'Sunita Devi',
              gender: 'FEMALE',
              designation: 'Senior Teacher',
              department: 'Science',
              status: 'ACTIVE',
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateTeacher('2', updates)),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TeacherState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.actionCompleted, 'actionCompleted', true)
              .having((s) => s.selectedTeacher?.designation,
                  'designation', 'Senior Teacher'),
        ],
        verify: (_) {
          verify(mockRepository.updateTeacher('2', updates)).called(1);
        },
      );

      blocTest<TeacherBloc, TeacherState>(
        'emits loading then failed when update throws',
        build: () {
          when(mockRepository.updateTeacher('2', updates))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateTeacher('2', updates)),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TeacherState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.updateTeacher('2', updates)).called(1);
        },
      );
    });

    // ===== DeleteTeacher =====
    group('DeleteTeacher', () {
      blocTest<TeacherBloc, TeacherState>(
        'emits loading then success with refreshed teachers and actionCompleted',
        build: () {
          when(mockRepository.deleteTeacher('1'))
              .thenAnswer((_) async {});
          when(mockRepository.getAllTeachers()).thenAnswer(
            (_) async =>
                PaginatedResponse.fromList([testTeachers[1]]),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteTeacher('1')),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TeacherState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.actionCompleted, 'actionCompleted', true)
              .having(
                  (s) => s.teachers.length, 'teachers.length', 1),
        ],
        verify: (_) {
          verify(mockRepository.deleteTeacher('1')).called(1);
          verify(mockRepository.getAllTeachers()).called(1);
        },
      );

      blocTest<TeacherBloc, TeacherState>(
        'emits loading then failed when delete throws',
        build: () {
          when(mockRepository.deleteTeacher('1'))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteTeacher('1')),
        expect: () => [
          isA<TeacherState>()
              .having((s) => s.isLoading, 'isLoading', true),
          isA<TeacherState>()
              .having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.deleteTeacher('1')).called(1);
        },
      );
    });
  });
}
