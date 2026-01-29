import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/exam/data/models/exam_model.dart';
import 'package:student_management/presentation/views/exam/data/models/exam_result_model.dart';
import 'package:student_management/presentation/views/exam/data/models/exam_type_model.dart';
import 'package:student_management/presentation/views/exam/data/repositories/exam_repository.dart';
import 'package:student_management/presentation/views/exam/presentation/manager/exam_bloc/exam_bloc.dart';

@GenerateMocks([ExamRepository])
import 'exam_bloc_test.mocks.dart';

void main() {
  late ExamBloc bloc;
  late MockExamRepository mockRepository;
  late StateRequestHandler handler;

  final testExamTypes = [
    ExamTypeResponse(
      id: '1',
      name: 'Unit Test',
      description: 'Unit test exam',
      weightage: 20.0,
      maxMarks: 50,
      passingMarks: 18,
      isActive: true,
      displayOrder: 1,
    ),
    ExamTypeResponse(
      id: '2',
      name: 'Mid Term',
      description: 'Mid term exam',
      weightage: 30.0,
      maxMarks: 100,
      passingMarks: 33,
      isActive: true,
      displayOrder: 2,
    ),
  ];

  final testExams = [
    ExamResponse(
      id: 'exam-1',
      name: 'Math Unit Test 1',
      classId: 'class-1',
      subjectName: 'Mathematics',
      examDate: '2026-02-15',
      maxMarks: 50,
      passingMarks: 18,
      status: 'SCHEDULED',
    ),
    ExamResponse(
      id: 'exam-2',
      name: 'Science Mid Term',
      classId: 'class-1',
      subjectName: 'Science',
      examDate: '2026-03-10',
      maxMarks: 100,
      passingMarks: 33,
      status: 'SCHEDULED',
    ),
  ];

  final testExamResults = [
    ExamResultResponse(
      id: 'result-1',
      examId: 'exam-1',
      studentId: 'student-1',
      studentName: 'Rahul Sharma',
      marksObtained: 42.0,
      maxMarks: 50,
      percentage: 84.0,
      grade: 'A',
      resultStatus: 'PASS',
    ),
    ExamResultResponse(
      id: 'result-2',
      examId: 'exam-1',
      studentId: 'student-2',
      studentName: 'Priya Patel',
      marksObtained: 35.0,
      maxMarks: 50,
      percentage: 70.0,
      grade: 'B',
      resultStatus: 'PASS',
    ),
  ];

  final testStatistics = ExamStatistics(
    totalStudents: 40,
    averagePercentage: 72.5,
    passed: 35,
    failed: 5,
    passPercentage: 87.5,
    highestMarks: 48.0,
    lowestMarks: 12.0,
    topper: 'Rahul Sharma',
  );

  final testReportCard = ReportCard(
    studentId: 'student-1',
    results: testExamResults,
    overallPercentage: 77.0,
    overallGrade: 'B+',
    totalExams: 5,
    examsTaken: 4,
  );

  setUp(() {
    mockRepository = MockExamRepository();
    handler = StateRequestHandler();
    bloc = ExamBloc(mockRepository, handler);
  });

  tearDown(() {
    bloc.close();
  });

  group('ExamBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.examTypes, isEmpty);
      expect(bloc.state.exams, isEmpty);
      expect(bloc.state.upcomingExams, isEmpty);
      expect(bloc.state.selectedExam, isNull);
      expect(bloc.state.examResults, isEmpty);
      expect(bloc.state.studentResults, isEmpty);
      expect(bloc.state.statistics, isNull);
      expect(bloc.state.reportCard, isNull);
      expect(bloc.state.isNone, isTrue);
    });

    // ===== FetchExamTypes =====
    group('FetchExamTypes', () {
      blocTest<ExamBloc, ExamState>(
        'emits loading then success with exam types when fetch succeeds',
        build: () {
          when(mockRepository.getActiveExamTypes())
              .thenAnswer((_) async => testExamTypes);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExamTypes()),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.examTypes.length, 'examTypes.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getActiveExamTypes()).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getActiveExamTypes())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExamTypes()),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getActiveExamTypes()).called(1);
        },
      );
    });

    // ===== FetchExams =====
    group('FetchExams', () {
      blocTest<ExamBloc, ExamState>(
        'emits loading then success with exams when fetch succeeds',
        build: () {
          when(mockRepository.getExams())
              .thenAnswer((_) async => testExams);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExams()),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.exams.length, 'exams.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getExams()).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getExams())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExams()),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getExams()).called(1);
        },
      );
    });

    // ===== FetchUpcomingExams =====
    group('FetchUpcomingExams', () {
      blocTest<ExamBloc, ExamState>(
        'emits loading then success with upcoming exams when fetch succeeds',
        build: () {
          when(mockRepository.getUpcomingExams())
              .thenAnswer((_) async => testExams);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchUpcomingExams()),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.upcomingExams.length, 'upcomingExams.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getUpcomingExams()).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getUpcomingExams())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchUpcomingExams()),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getUpcomingExams()).called(1);
        },
      );
    });

    // ===== FetchExamsByClass =====
    group('FetchExamsByClass', () {
      blocTest<ExamBloc, ExamState>(
        'emits loading then success with exams for the given class',
        build: () {
          when(mockRepository.getExamsByClass('class-1'))
              .thenAnswer((_) async => testExams);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExamsByClass('class-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.exams.length, 'exams.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getExamsByClass('class-1')).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getExamsByClass('class-1'))
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExamsByClass('class-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getExamsByClass('class-1')).called(1);
        },
      );
    });

    // ===== FetchExamDetails =====
    group('FetchExamDetails', () {
      blocTest<ExamBloc, ExamState>(
        'emits loading then success with selected exam',
        build: () {
          when(mockRepository.getExamById('exam-1'))
              .thenAnswer((_) async => testExams[0]);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExamDetails('exam-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.selectedExam?.name, 'examName',
                  'Math Unit Test 1'),
        ],
        verify: (_) {
          verify(mockRepository.getExamById('exam-1')).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getExamById('exam-1'))
              .thenAnswer((_) async => throw Exception('Not found'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExamDetails('exam-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getExamById('exam-1')).called(1);
        },
      );
    });

    // ===== CreateExam =====
    group('CreateExam', () {
      final request = ExamRequest(
        name: 'Math Unit Test 2',
        examTypeId: '1',
        classId: 'class-1',
        examDate: '2026-03-01',
        maxMarks: 50,
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then success on successful create',
        build: () {
          when(mockRepository.createExam(request)).thenAnswer(
            (_) async => ExamResponse(
              id: 'exam-3',
              name: 'Math Unit Test 2',
              classId: 'class-1',
              examDate: '2026-03-01',
              maxMarks: 50,
              passingMarks: 18,
              status: 'SCHEDULED',
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CreateExam(request)),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.createExam(request)).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when create throws',
        build: () {
          when(mockRepository.createExam(request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateExam(request)),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.createExam(request)).called(1);
        },
      );
    });

    // ===== UpdateExam =====
    group('UpdateExam', () {
      final request = ExamRequest(
        name: 'Math Unit Test 1 Updated',
        examTypeId: '1',
        classId: 'class-1',
        examDate: '2026-02-20',
        maxMarks: 50,
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then success on successful update',
        build: () {
          when(mockRepository.updateExam('exam-1', request)).thenAnswer(
            (_) async => ExamResponse(
              id: 'exam-1',
              name: 'Math Unit Test 1 Updated',
              classId: 'class-1',
              examDate: '2026-02-20',
              maxMarks: 50,
              passingMarks: 18,
              status: 'SCHEDULED',
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateExam('exam-1', request)),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.updateExam('exam-1', request)).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when update throws',
        build: () {
          when(mockRepository.updateExam('exam-1', request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateExam('exam-1', request)),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.updateExam('exam-1', request)).called(1);
        },
      );
    });

    // ===== DeleteExam =====
    group('DeleteExam', () {
      blocTest<ExamBloc, ExamState>(
        'emits loading then success on successful delete',
        build: () {
          when(mockRepository.deleteExam('exam-1'))
              .thenAnswer((_) async {});
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteExam('exam-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.deleteExam('exam-1')).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when delete throws',
        build: () {
          when(mockRepository.deleteExam('exam-1'))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteExam('exam-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.deleteExam('exam-1')).called(1);
        },
      );
    });

    // ===== CreateExamType =====
    group('CreateExamType', () {
      final request = ExamTypeRequest(
        name: 'Final Exam',
        description: 'Final exam type',
        weightage: 50.0,
        maxMarks: 100,
        passingMarks: 33,
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then success on successful create',
        build: () {
          when(mockRepository.createExamType(request)).thenAnswer(
            (_) async => ExamTypeResponse(
              id: '3',
              name: 'Final Exam',
              description: 'Final exam type',
              weightage: 50.0,
              maxMarks: 100,
              passingMarks: 33,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CreateExamType(request)),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.createExamType(request)).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when create throws',
        build: () {
          when(mockRepository.createExamType(request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateExamType(request)),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.createExamType(request)).called(1);
        },
      );
    });

    // ===== EnterMarks =====
    group('EnterMarks', () {
      final request = ExamResultRequest(
        studentId: 'student-1',
        studentName: 'Rahul Sharma',
        marksObtained: 42.0,
        maxMarks: 50,
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then success on successful enter marks',
        build: () {
          when(mockRepository.enterMarks('exam-1', request)).thenAnswer(
            (_) async => testExamResults[0],
          );
          return bloc;
        },
        act: (bloc) => bloc.add(EnterMarks('exam-1', request)),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.enterMarks('exam-1', request)).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when enter marks throws',
        build: () {
          when(mockRepository.enterMarks('exam-1', request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(EnterMarks('exam-1', request)),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.enterMarks('exam-1', request)).called(1);
        },
      );
    });

    // ===== EnterBulkMarks =====
    group('EnterBulkMarks', () {
      final requests = [
        ExamResultRequest(
          studentId: 'student-1',
          marksObtained: 42.0,
          maxMarks: 50,
        ),
        ExamResultRequest(
          studentId: 'student-2',
          marksObtained: 35.0,
          maxMarks: 50,
        ),
      ];

      blocTest<ExamBloc, ExamState>(
        'emits loading then success with exam results on bulk entry',
        build: () {
          when(mockRepository.enterBulkMarks('exam-1', requests))
              .thenAnswer((_) async => testExamResults);
          return bloc;
        },
        act: (bloc) => bloc.add(EnterBulkMarks('exam-1', requests)),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.examResults.length, 'examResults.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.enterBulkMarks('exam-1', requests))
              .called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when bulk entry throws',
        build: () {
          when(mockRepository.enterBulkMarks('exam-1', requests))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(EnterBulkMarks('exam-1', requests)),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.enterBulkMarks('exam-1', requests))
              .called(1);
        },
      );
    });

    // ===== FetchExamResults =====
    group('FetchExamResults', () {
      blocTest<ExamBloc, ExamState>(
        'emits loading then success with exam results',
        build: () {
          when(mockRepository.getExamResults('exam-1'))
              .thenAnswer((_) async => testExamResults);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExamResults('exam-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.examResults.length, 'examResults.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getExamResults('exam-1')).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getExamResults('exam-1'))
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExamResults('exam-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getExamResults('exam-1')).called(1);
        },
      );
    });

    // ===== FetchExamStatistics =====
    group('FetchExamStatistics', () {
      blocTest<ExamBloc, ExamState>(
        'emits loading then success with statistics',
        build: () {
          when(mockRepository.getExamStatistics('exam-1'))
              .thenAnswer((_) async => testStatistics);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExamStatistics('exam-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.statistics?.totalStudents, 'totalStudents',
                  40)
              .having((s) => s.statistics?.passPercentage,
                  'passPercentage', 87.5),
        ],
        verify: (_) {
          verify(mockRepository.getExamStatistics('exam-1')).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getExamStatistics('exam-1'))
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchExamStatistics('exam-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getExamStatistics('exam-1')).called(1);
        },
      );
    });

    // ===== FetchStudentResults =====
    group('FetchStudentResults', () {
      blocTest<ExamBloc, ExamState>(
        'emits loading then success with student results',
        build: () {
          when(mockRepository.getStudentResults('student-1'))
              .thenAnswer((_) async => testExamResults);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchStudentResults('student-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.studentResults.length,
                  'studentResults.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getStudentResults('student-1')).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getStudentResults('student-1'))
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchStudentResults('student-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getStudentResults('student-1')).called(1);
        },
      );
    });

    // ===== FetchReportCard =====
    group('FetchReportCard', () {
      blocTest<ExamBloc, ExamState>(
        'emits loading then success with report card',
        build: () {
          when(mockRepository.getReportCard('student-1'))
              .thenAnswer((_) async => testReportCard);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchReportCard('student-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.reportCard?.overallGrade, 'overallGrade',
                  'B+')
              .having((s) => s.reportCard?.overallPercentage,
                  'overallPercentage', 77.0),
        ],
        verify: (_) {
          verify(mockRepository.getReportCard('student-1')).called(1);
        },
      );

      blocTest<ExamBloc, ExamState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getReportCard('student-1'))
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchReportCard('student-1')),
        expect: () => [
          isA<ExamState>().having((s) => s.isLoading, 'isLoading', true),
          isA<ExamState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getReportCard('student-1')).called(1);
        },
      );
    });
  });
}
