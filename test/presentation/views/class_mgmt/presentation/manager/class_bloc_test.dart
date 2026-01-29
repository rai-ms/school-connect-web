import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/class_mgmt/data/models/class_model.dart';
import 'package:student_management/presentation/views/class_mgmt/data/repositories/class_repository.dart';
import 'package:student_management/presentation/views/class_mgmt/presentation/manager/class_bloc/class_bloc.dart';

@GenerateMocks([ClassRepository])
import 'class_bloc_test.mocks.dart';

void main() {
  late ClassBloc bloc;
  late MockClassRepository mockRepository;
  late StateRequestHandler handler;

  final testSections = [
    SectionResponse(
      id: 'sec-1',
      name: 'A',
      capacity: 40,
      schoolClassId: 'cls-1',
      schoolClassCode: '10',
      schoolClassName: 'Class 10',
    ),
    SectionResponse(
      id: 'sec-2',
      name: 'B',
      capacity: 35,
      schoolClassId: 'cls-1',
      schoolClassCode: '10',
      schoolClassName: 'Class 10',
    ),
  ];

  final testClasses = [
    SchoolClassResponse(
      id: 'cls-1',
      code: '10',
      name: 'Class 10',
      description: 'Tenth Standard',
      sections: testSections,
    ),
    SchoolClassResponse(
      id: 'cls-2',
      code: '11',
      name: 'Class 11',
      description: 'Eleventh Standard',
      sections: [],
    ),
  ];

  final testCreateClassRequest = CreateClassRequest(
    code: '12',
    name: 'Class 12',
    description: 'Twelfth Standard',
  );

  final testCreateSectionRequest = CreateSectionRequest(
    name: 'C',
    capacity: 30,
    schoolClassId: 'cls-1',
  );

  setUp(() {
    mockRepository = MockClassRepository();
    handler = StateRequestHandler();
    bloc = ClassBloc(mockRepository, handler);
  });

  tearDown(() {
    bloc.close();
  });

  group('ClassBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.classes, isEmpty);
      expect(bloc.state.selectedClass, isNull);
      expect(bloc.state.sections, isEmpty);
      expect(bloc.state.actionCompleted, isFalse);
      expect(bloc.state.isNone, isTrue);
    });

    group('FetchAllClasses', () {
      blocTest<ClassBloc, ClassState>(
        'emits loading then success with classes when fetch succeeds',
        build: () {
          when(mockRepository.getAllClasses())
              .thenAnswer((_) async => testClasses);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchAllClasses()),
        expect: () => [
          isA<ClassState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ClassState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.classes.length, 'classes.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getAllClasses()).called(1);
        },
      );

      blocTest<ClassBloc, ClassState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getAllClasses())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchAllClasses()),
        expect: () => [
          isA<ClassState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ClassState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getAllClasses()).called(1);
        },
      );
    });

    group('FetchClassById', () {
      blocTest<ClassBloc, ClassState>(
        'emits loading then success with selectedClass and sections',
        build: () {
          when(mockRepository.getClassById('cls-1'))
              .thenAnswer((_) async => testClasses[0]);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchClassById('cls-1')),
        expect: () => [
          isA<ClassState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ClassState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.selectedClass?.id, 'selectedClass.id', 'cls-1')
              .having(
                  (s) => s.selectedClass?.name, 'selectedClass.name', 'Class 10')
              .having((s) => s.sections.length, 'sections.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getClassById('cls-1')).called(1);
        },
      );

      blocTest<ClassBloc, ClassState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getClassById('cls-1'))
              .thenAnswer((_) async => throw Exception('Not found'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchClassById('cls-1')),
        expect: () => [
          isA<ClassState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ClassState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getClassById('cls-1')).called(1);
        },
      );
    });

    group('CreateSchoolClass', () {
      blocTest<ClassBloc, ClassState>(
        'emits loading then success with actionCompleted true when create succeeds',
        build: () {
          when(mockRepository.createClass(testCreateClassRequest))
              .thenAnswer((_) async => SchoolClassResponse(
                    id: 'cls-3',
                    code: '12',
                    name: 'Class 12',
                    description: 'Twelfth Standard',
                  ));
          when(mockRepository.getAllClasses())
              .thenAnswer((_) async => [...testClasses]);
          return bloc;
        },
        act: (bloc) => bloc.add(CreateSchoolClass(testCreateClassRequest)),
        expect: () => [
          isA<ClassState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ClassState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.actionCompleted, 'actionCompleted', true),
        ],
        verify: (_) {
          verify(mockRepository.createClass(testCreateClassRequest)).called(1);
          verify(mockRepository.getAllClasses()).called(1);
        },
      );

      blocTest<ClassBloc, ClassState>(
        'emits loading then failed when create throws',
        build: () {
          when(mockRepository.createClass(testCreateClassRequest))
              .thenAnswer((_) async => throw Exception('Create failed'));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateSchoolClass(testCreateClassRequest)),
        expect: () => [
          isA<ClassState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ClassState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.createClass(testCreateClassRequest)).called(1);
        },
      );
    });

    group('FetchSectionsByClass', () {
      blocTest<ClassBloc, ClassState>(
        'emits loading then success with sections when fetch succeeds',
        build: () {
          when(mockRepository.getSectionsByClass('cls-1'))
              .thenAnswer((_) async => testSections);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchSectionsByClass('cls-1')),
        expect: () => [
          isA<ClassState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ClassState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.sections.length, 'sections.length', 2)
              .having((s) => s.sections.first.name, 'first section name', 'A'),
        ],
        verify: (_) {
          verify(mockRepository.getSectionsByClass('cls-1')).called(1);
        },
      );

      blocTest<ClassBloc, ClassState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getSectionsByClass('cls-1'))
              .thenAnswer((_) async => throw Exception('Fetch error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchSectionsByClass('cls-1')),
        expect: () => [
          isA<ClassState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ClassState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getSectionsByClass('cls-1')).called(1);
        },
      );
    });

    group('CreateSection', () {
      blocTest<ClassBloc, ClassState>(
        'emits loading then success with actionCompleted true when create succeeds',
        build: () {
          when(mockRepository.createSection(testCreateSectionRequest))
              .thenAnswer((_) async => SectionResponse(
                    id: 'sec-3',
                    name: 'C',
                    capacity: 30,
                    schoolClassId: 'cls-1',
                  ));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateSection(testCreateSectionRequest)),
        expect: () => [
          isA<ClassState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ClassState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.actionCompleted, 'actionCompleted', true),
        ],
        verify: (_) {
          verify(mockRepository.createSection(testCreateSectionRequest))
              .called(1);
        },
      );

      blocTest<ClassBloc, ClassState>(
        'emits loading then failed when create throws',
        build: () {
          when(mockRepository.createSection(testCreateSectionRequest))
              .thenAnswer((_) async => throw Exception('Create error'));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateSection(testCreateSectionRequest)),
        expect: () => [
          isA<ClassState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ClassState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.createSection(testCreateSectionRequest))
              .called(1);
        },
      );
    });
  });
}
