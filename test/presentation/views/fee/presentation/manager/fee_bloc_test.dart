import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/fee/data/models/fee_type_model.dart';
import 'package:student_management/presentation/views/fee/data/models/fee_structure_model.dart';
import 'package:student_management/presentation/views/fee/data/models/fee_payment_model.dart';
import 'package:student_management/presentation/views/fee/data/repositories/fee_repository.dart';
import 'package:student_management/presentation/views/fee/presentation/manager/fee_bloc/fee_bloc.dart';

@GenerateMocks([FeeRepository])
import 'fee_bloc_test.mocks.dart';

void main() {
  late FeeBloc bloc;
  late MockFeeRepository mockRepository;
  late StateRequestHandler handler;

  final testFeeTypes = [
    FeeTypeResponse(
      id: '1',
      name: 'Tuition Fee',
      description: 'Monthly tuition fee',
      isRecurring: true,
      frequency: 'MONTHLY',
      isMandatory: true,
      isActive: true,
    ),
    FeeTypeResponse(
      id: '2',
      name: 'Transport Fee',
      description: 'School bus transport fee',
      isRecurring: true,
      frequency: 'MONTHLY',
      isMandatory: false,
      isActive: true,
    ),
  ];

  final testFeeStructures = [
    FeeStructureResponse(
      id: 'fs-1',
      classId: 'class-1',
      amount: 5000.0,
      dueDate: '2026-02-15',
      lateFee: 100.0,
      academicYear: '2025-2026',
      isActive: true,
    ),
    FeeStructureResponse(
      id: 'fs-2',
      classId: 'class-2',
      amount: 5500.0,
      dueDate: '2026-02-15',
      lateFee: 100.0,
      academicYear: '2025-2026',
      isActive: true,
    ),
  ];

  final testPayments = [
    FeePaymentResponse(
      id: 'pay-1',
      studentId: 'student-1',
      studentName: 'Rahul Sharma',
      amountPaid: 5000.0,
      totalAmount: 5000.0,
      paymentStatus: 'PAID',
      paymentMode: 'CASH',
      receiptNumber: 'REC-001',
    ),
    FeePaymentResponse(
      id: 'pay-2',
      studentId: 'student-2',
      studentName: 'Priya Patel',
      amountPaid: 3000.0,
      totalAmount: 5000.0,
      balanceAmount: 2000.0,
      paymentStatus: 'PARTIAL',
      paymentMode: 'ONLINE',
      receiptNumber: 'REC-002',
    ),
  ];

  final testOverduePayments = [
    FeePaymentResponse(
      id: 'pay-3',
      studentId: 'student-3',
      studentName: 'Amit Kumar',
      amountPaid: 0.0,
      totalAmount: 5000.0,
      balanceAmount: 5000.0,
      paymentStatus: 'OVERDUE',
    ),
  ];

  final testCollectionReport = CollectionReport(
    totalCollected: 150000.0,
    totalPending: 50000.0,
    overdueCount: 5,
    monthlyCollection: 30000.0,
  );

  setUp(() {
    mockRepository = MockFeeRepository();
    handler = StateRequestHandler();
    bloc = FeeBloc(mockRepository, handler);
  });

  tearDown(() {
    bloc.close();
  });

  group('FeeBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.feeTypes, isEmpty);
      expect(bloc.state.feeStructures, isEmpty);
      expect(bloc.state.payments, isEmpty);
      expect(bloc.state.pendingFees, isEmpty);
      expect(bloc.state.overduePayments, isEmpty);
      expect(bloc.state.selectedPayment, isNull);
      expect(bloc.state.collectionReport, isNull);
      expect(bloc.state.isNone, isTrue);
    });

    // ===== FetchFeeTypes =====
    group('FetchFeeTypes', () {
      blocTest<FeeBloc, FeeState>(
        'emits loading then success with fee types when fetch succeeds',
        build: () {
          when(mockRepository.getFeeTypes())
              .thenAnswer((_) async => testFeeTypes);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchFeeTypes()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.feeTypes.length, 'feeTypes.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getFeeTypes()).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getFeeTypes())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchFeeTypes()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getFeeTypes()).called(1);
        },
      );
    });

    // ===== FetchActiveFeeTypes =====
    group('FetchActiveFeeTypes', () {
      blocTest<FeeBloc, FeeState>(
        'emits loading then success with active fee types',
        build: () {
          when(mockRepository.getActiveFeeTypes())
              .thenAnswer((_) async => testFeeTypes);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchActiveFeeTypes()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.feeTypes.length, 'feeTypes.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getActiveFeeTypes()).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getActiveFeeTypes())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchActiveFeeTypes()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getActiveFeeTypes()).called(1);
        },
      );
    });

    // ===== CreateFeeType =====
    group('CreateFeeType', () {
      final request = FeeTypeRequest(
        name: 'Lab Fee',
        description: 'Laboratory fee',
        isRecurring: false,
        isMandatory: true,
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then success on successful create',
        build: () {
          when(mockRepository.createFeeType(request)).thenAnswer(
            (_) async => FeeTypeResponse(
              id: '3',
              name: 'Lab Fee',
              description: 'Laboratory fee',
              isMandatory: true,
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CreateFeeType(request)),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.createFeeType(request)).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when create throws',
        build: () {
          when(mockRepository.createFeeType(request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateFeeType(request)),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.createFeeType(request)).called(1);
        },
      );
    });

    // ===== UpdateFeeType =====
    group('UpdateFeeType', () {
      final request = FeeTypeRequest(
        name: 'Tuition Fee Updated',
        description: 'Updated tuition fee',
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then success on successful update',
        build: () {
          when(mockRepository.updateFeeType('1', request)).thenAnswer(
            (_) async => FeeTypeResponse(
              id: '1',
              name: 'Tuition Fee Updated',
              description: 'Updated tuition fee',
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateFeeType('1', request)),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.updateFeeType('1', request)).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when update throws',
        build: () {
          when(mockRepository.updateFeeType('1', request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateFeeType('1', request)),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.updateFeeType('1', request)).called(1);
        },
      );
    });

    // ===== DeleteFeeType =====
    group('DeleteFeeType', () {
      blocTest<FeeBloc, FeeState>(
        'emits loading then success on successful delete',
        build: () {
          when(mockRepository.deleteFeeType('1'))
              .thenAnswer((_) async {});
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteFeeType('1')),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.deleteFeeType('1')).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when delete throws',
        build: () {
          when(mockRepository.deleteFeeType('1'))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteFeeType('1')),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.deleteFeeType('1')).called(1);
        },
      );
    });

    // ===== FetchFeeStructures =====
    group('FetchFeeStructures', () {
      blocTest<FeeBloc, FeeState>(
        'emits loading then success with fee structures',
        build: () {
          when(mockRepository.getFeeStructures())
              .thenAnswer((_) async => testFeeStructures);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchFeeStructures()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.feeStructures.length,
                  'feeStructures.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getFeeStructures()).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getFeeStructures())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchFeeStructures()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getFeeStructures()).called(1);
        },
      );
    });

    // ===== FetchFeeStructuresByClass =====
    group('FetchFeeStructuresByClass', () {
      blocTest<FeeBloc, FeeState>(
        'emits loading then success with class fee structures',
        build: () {
          when(mockRepository.getFeeStructuresByClass('class-1'))
              .thenAnswer((_) async => [testFeeStructures[0]]);
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchFeeStructuresByClass('class-1')),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.feeStructures.length,
                  'feeStructures.length', 1),
        ],
        verify: (_) {
          verify(mockRepository.getFeeStructuresByClass('class-1'))
              .called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getFeeStructuresByClass('class-1'))
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchFeeStructuresByClass('class-1')),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getFeeStructuresByClass('class-1'))
              .called(1);
        },
      );
    });

    // ===== CreateFeeStructure =====
    group('CreateFeeStructure', () {
      final request = FeeStructureRequest(
        feeTypeId: '1',
        classId: 'class-3',
        amount: 6000.0,
        dueDate: '2026-03-15',
        academicYear: '2025-2026',
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then success on successful create',
        build: () {
          when(mockRepository.createFeeStructure(request)).thenAnswer(
            (_) async => FeeStructureResponse(
              id: 'fs-3',
              classId: 'class-3',
              amount: 6000.0,
              dueDate: '2026-03-15',
              academicYear: '2025-2026',
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CreateFeeStructure(request)),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.createFeeStructure(request)).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when create throws',
        build: () {
          when(mockRepository.createFeeStructure(request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateFeeStructure(request)),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.createFeeStructure(request)).called(1);
        },
      );
    });

    // ===== UpdateFeeStructure =====
    group('UpdateFeeStructure', () {
      final request = FeeStructureRequest(
        feeTypeId: '1',
        classId: 'class-1',
        amount: 5500.0,
        dueDate: '2026-02-20',
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then success on successful update',
        build: () {
          when(mockRepository.updateFeeStructure('fs-1', request))
              .thenAnswer(
            (_) async => FeeStructureResponse(
              id: 'fs-1',
              classId: 'class-1',
              amount: 5500.0,
              dueDate: '2026-02-20',
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateFeeStructure('fs-1', request)),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isSuccess, 'isSuccess', true),
        ],
        verify: (_) {
          verify(mockRepository.updateFeeStructure('fs-1', request))
              .called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when update throws',
        build: () {
          when(mockRepository.updateFeeStructure('fs-1', request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateFeeStructure('fs-1', request)),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.updateFeeStructure('fs-1', request))
              .called(1);
        },
      );
    });

    // ===== CollectFee =====
    group('CollectFee', () {
      final request = FeePaymentRequest(
        feeStructureId: 'fs-1',
        studentId: 'student-1',
        studentName: 'Rahul Sharma',
        amountPaid: 5000.0,
        totalAmount: 5000.0,
        paymentMode: 'CASH',
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then success with payment on successful collect',
        build: () {
          when(mockRepository.collectFee(request)).thenAnswer(
            (_) async => testPayments[0],
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CollectFee(request)),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.selectedPayment?.id, 'paymentId', 'pay-1'),
        ],
        verify: (_) {
          verify(mockRepository.collectFee(request)).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when collect throws',
        build: () {
          when(mockRepository.collectFee(request))
              .thenAnswer((_) async => throw Exception('Payment failed'));
          return bloc;
        },
        act: (bloc) => bloc.add(CollectFee(request)),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.collectFee(request)).called(1);
        },
      );
    });

    // ===== FetchStudentPayments =====
    group('FetchStudentPayments', () {
      blocTest<FeeBloc, FeeState>(
        'emits loading then success with student payments',
        build: () {
          when(mockRepository.getStudentPayments('student-1'))
              .thenAnswer((_) async => [testPayments[0]]);
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchStudentPayments('student-1')),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.payments.length, 'payments.length', 1),
        ],
        verify: (_) {
          verify(mockRepository.getStudentPayments('student-1'))
              .called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getStudentPayments('student-1'))
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchStudentPayments('student-1')),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getStudentPayments('student-1'))
              .called(1);
        },
      );
    });

    // ===== FetchStudentPendingFees =====
    group('FetchStudentPendingFees', () {
      blocTest<FeeBloc, FeeState>(
        'emits loading then success with pending fees',
        build: () {
          when(mockRepository.getStudentPendingFees('student-2'))
              .thenAnswer((_) async => [testPayments[1]]);
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchStudentPendingFees('student-2')),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.pendingFees.length, 'pendingFees.length', 1),
        ],
        verify: (_) {
          verify(mockRepository.getStudentPendingFees('student-2'))
              .called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getStudentPendingFees('student-2'))
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const FetchStudentPendingFees('student-2')),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getStudentPendingFees('student-2'))
              .called(1);
        },
      );
    });

    // ===== FetchAllPayments =====
    group('FetchAllPayments', () {
      blocTest<FeeBloc, FeeState>(
        'emits loading then success with all payments',
        build: () {
          when(mockRepository.getAllPayments())
              .thenAnswer((_) async => testPayments);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchAllPayments()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.payments.length, 'payments.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getAllPayments()).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getAllPayments())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchAllPayments()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getAllPayments()).called(1);
        },
      );
    });

    // ===== FetchReceipt =====
    group('FetchReceipt', () {
      blocTest<FeeBloc, FeeState>(
        'emits loading then success with receipt payment',
        build: () {
          when(mockRepository.getReceipt('pay-1'))
              .thenAnswer((_) async => testPayments[0]);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchReceipt('pay-1')),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.selectedPayment?.receiptNumber,
                  'receiptNumber', 'REC-001'),
        ],
        verify: (_) {
          verify(mockRepository.getReceipt('pay-1')).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getReceipt('pay-1'))
              .thenAnswer((_) async => throw Exception('Not found'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchReceipt('pay-1')),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getReceipt('pay-1')).called(1);
        },
      );
    });

    // ===== FetchOverduePayments =====
    group('FetchOverduePayments', () {
      blocTest<FeeBloc, FeeState>(
        'emits loading then success with overdue payments',
        build: () {
          when(mockRepository.getOverduePayments())
              .thenAnswer((_) async => testOverduePayments);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchOverduePayments()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.overduePayments.length,
                  'overduePayments.length', 1),
        ],
        verify: (_) {
          verify(mockRepository.getOverduePayments()).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getOverduePayments())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchOverduePayments()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getOverduePayments()).called(1);
        },
      );
    });

    // ===== FetchCollectionReport =====
    group('FetchCollectionReport', () {
      blocTest<FeeBloc, FeeState>(
        'emits loading then success with collection report',
        build: () {
          when(mockRepository.getCollectionReport())
              .thenAnswer((_) async => testCollectionReport);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchCollectionReport()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.collectionReport?.totalCollected,
                  'totalCollected', 150000.0)
              .having((s) => s.collectionReport?.overdueCount,
                  'overdueCount', 5),
        ],
        verify: (_) {
          verify(mockRepository.getCollectionReport()).called(1);
        },
      );

      blocTest<FeeBloc, FeeState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getCollectionReport())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchCollectionReport()),
        expect: () => [
          isA<FeeState>().having((s) => s.isLoading, 'isLoading', true),
          isA<FeeState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getCollectionReport()).called(1);
        },
      );
    });
  });
}
