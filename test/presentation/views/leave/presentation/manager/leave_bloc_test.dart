import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management/core/handler/state_request_handler.dart';
import 'package:student_management/presentation/views/leave/data/models/leave_type_model.dart';
import 'package:student_management/presentation/views/leave/data/models/leave_request_model.dart';
import 'package:student_management/presentation/views/leave/data/models/leave_balance_model.dart';
import 'package:student_management/presentation/views/leave/data/repositories/leave_repository.dart';
import 'package:student_management/presentation/views/leave/presentation/manager/leave_bloc/leave_bloc.dart';

@GenerateMocks([LeaveRepository])
import 'leave_bloc_test.mocks.dart';

void main() {
  late LeaveBloc bloc;
  late MockLeaveRepository mockRepository;
  late StateRequestHandler handler;

  final testLeaveTypes = [
    LeaveTypeResponse(
      id: '1',
      name: 'Sick Leave',
      description: 'Leave for illness',
      maxDaysPerYear: 12,
      isPaid: true,
      requiresApproval: true,
      isActive: true,
    ),
    LeaveTypeResponse(
      id: '2',
      name: 'Casual Leave',
      description: 'Casual leave',
      maxDaysPerYear: 10,
      isPaid: true,
      requiresApproval: true,
      isActive: true,
    ),
  ];

  final testMyLeaves = [
    LeaveRequestResponse(
      id: 'leave-1',
      userId: 'user-1',
      userName: 'Rahul Sharma',
      startDate: '2026-02-01',
      endDate: '2026-02-03',
      totalDays: 3,
      reason: 'Fever',
      status: 'APPROVED',
      leaveTypeName: 'Sick Leave',
    ),
    LeaveRequestResponse(
      id: 'leave-2',
      userId: 'user-1',
      userName: 'Rahul Sharma',
      startDate: '2026-03-10',
      endDate: '2026-03-10',
      totalDays: 1,
      reason: 'Personal work',
      status: 'PENDING',
      leaveTypeName: 'Casual Leave',
    ),
  ];

  final testPendingApprovals = [
    LeaveRequestResponse(
      id: 'leave-3',
      userId: 'user-2',
      userName: 'Priya Patel',
      startDate: '2026-02-15',
      endDate: '2026-02-16',
      totalDays: 2,
      reason: 'Family function',
      status: 'PENDING',
      leaveTypeName: 'Casual Leave',
    ),
  ];

  final testAllRequests = [
    ...testMyLeaves,
    ...testPendingApprovals,
  ];

  final testBalances = [
    LeaveBalanceResponse(
      id: 'bal-1',
      userId: 'user-1',
      leaveTypeName: 'Sick Leave',
      academicYear: '2025-2026',
      totalAllocated: 12,
      used: 3,
      pending: 0,
    ),
    LeaveBalanceResponse(
      id: 'bal-2',
      userId: 'user-1',
      leaveTypeName: 'Casual Leave',
      academicYear: '2025-2026',
      totalAllocated: 10,
      used: 2,
      pending: 1,
    ),
  ];

  final testSummary = LeaveSummaryResponse(
    balances: testBalances,
    pendingRequests: 1,
    academicYear: '2025-2026',
    totalAllocated: 22,
    totalUsed: 5,
    totalPending: 1,
    totalRemaining: 16,
  );

  setUp(() {
    mockRepository = MockLeaveRepository();
    handler = StateRequestHandler();
    bloc = LeaveBloc(mockRepository, handler);
  });

  tearDown(() {
    bloc.close();
  });

  group('LeaveBloc', () {
    test('initial state is correct', () {
      expect(bloc.state.leaveTypes, isEmpty);
      expect(bloc.state.myLeaves, isEmpty);
      expect(bloc.state.pendingApprovals, isEmpty);
      expect(bloc.state.allRequests, isEmpty);
      expect(bloc.state.balances, isEmpty);
      expect(bloc.state.summary, isNull);
      expect(bloc.state.leaveApplied, isFalse);
      expect(bloc.state.actionCompleted, isFalse);
      expect(bloc.state.isNone, isTrue);
    });

    // ===== FetchLeaveTypes =====
    group('FetchLeaveTypes', () {
      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with leave types when fetch succeeds',
        build: () {
          when(mockRepository.getLeaveTypes())
              .thenAnswer((_) async => testLeaveTypes);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchLeaveTypes()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.leaveTypes.length, 'leaveTypes.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getLeaveTypes()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getLeaveTypes())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchLeaveTypes()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getLeaveTypes()).called(1);
        },
      );
    });

    // ===== FetchActiveLeaveTypes =====
    group('FetchActiveLeaveTypes', () {
      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with active leave types',
        build: () {
          when(mockRepository.getActiveLeaveTypes())
              .thenAnswer((_) async => testLeaveTypes);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchActiveLeaveTypes()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.leaveTypes.length, 'leaveTypes.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getActiveLeaveTypes()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getActiveLeaveTypes())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchActiveLeaveTypes()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getActiveLeaveTypes()).called(1);
        },
      );
    });

    // ===== CreateLeaveType =====
    group('CreateLeaveType', () {
      final request = LeaveTypeRequest(
        name: 'Maternity Leave',
        description: 'Maternity leave for female staff',
        maxDaysPerYear: 90,
        isPaid: true,
        requiresApproval: true,
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with refreshed leave types and actionCompleted',
        build: () {
          when(mockRepository.createLeaveType(request)).thenAnswer(
            (_) async => LeaveTypeResponse(
              id: '3',
              name: 'Maternity Leave',
              description: 'Maternity leave for female staff',
              maxDaysPerYear: 90,
              isPaid: true,
              requiresApproval: true,
            ),
          );
          when(mockRepository.getLeaveTypes())
              .thenAnswer((_) async => [...testLeaveTypes]);
          return bloc;
        },
        act: (bloc) => bloc.add(CreateLeaveType(request)),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.actionCompleted, 'actionCompleted', true),
        ],
        verify: (_) {
          verify(mockRepository.createLeaveType(request)).called(1);
          verify(mockRepository.getLeaveTypes()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when create throws',
        build: () {
          when(mockRepository.createLeaveType(request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateLeaveType(request)),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.createLeaveType(request)).called(1);
        },
      );
    });

    // ===== UpdateLeaveType =====
    group('UpdateLeaveType', () {
      final request = LeaveTypeRequest(
        name: 'Sick Leave Updated',
        description: 'Updated sick leave',
        maxDaysPerYear: 15,
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with refreshed leave types and actionCompleted',
        build: () {
          when(mockRepository.updateLeaveType('1', request)).thenAnswer(
            (_) async => LeaveTypeResponse(
              id: '1',
              name: 'Sick Leave Updated',
              description: 'Updated sick leave',
              maxDaysPerYear: 15,
            ),
          );
          when(mockRepository.getLeaveTypes())
              .thenAnswer((_) async => testLeaveTypes);
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateLeaveType('1', request)),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.actionCompleted, 'actionCompleted', true),
        ],
        verify: (_) {
          verify(mockRepository.updateLeaveType('1', request)).called(1);
          verify(mockRepository.getLeaveTypes()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when update throws',
        build: () {
          when(mockRepository.updateLeaveType('1', request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateLeaveType('1', request)),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.updateLeaveType('1', request)).called(1);
        },
      );
    });

    // ===== DeleteLeaveType =====
    group('DeleteLeaveType', () {
      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with refreshed leave types and actionCompleted',
        build: () {
          when(mockRepository.deleteLeaveType('1'))
              .thenAnswer((_) async {});
          when(mockRepository.getLeaveTypes())
              .thenAnswer((_) async => [testLeaveTypes[1]]);
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteLeaveType('1')),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.actionCompleted, 'actionCompleted', true)
              .having(
                  (s) => s.leaveTypes.length, 'leaveTypes.length', 1),
        ],
        verify: (_) {
          verify(mockRepository.deleteLeaveType('1')).called(1);
          verify(mockRepository.getLeaveTypes()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when delete throws',
        build: () {
          when(mockRepository.deleteLeaveType('1'))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteLeaveType('1')),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.deleteLeaveType('1')).called(1);
        },
      );
    });

    // ===== ApplyLeave =====
    group('ApplyLeave', () {
      final request = LeaveRequestCreate(
        leaveTypeId: '1',
        startDate: '2026-04-01',
        endDate: '2026-04-03',
        reason: 'Fever and cold',
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with leaveApplied true',
        build: () {
          when(mockRepository.applyLeave(request)).thenAnswer(
            (_) async => LeaveRequestResponse(
              id: 'leave-4',
              userId: 'user-1',
              startDate: '2026-04-01',
              endDate: '2026-04-03',
              totalDays: 3,
              reason: 'Fever and cold',
              status: 'PENDING',
            ),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(ApplyLeave(request)),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.leaveApplied, 'leaveApplied', true),
        ],
        verify: (_) {
          verify(mockRepository.applyLeave(request)).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when apply throws',
        build: () {
          when(mockRepository.applyLeave(request))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(ApplyLeave(request)),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.applyLeave(request)).called(1);
        },
      );
    });

    // ===== FetchMyLeaves =====
    group('FetchMyLeaves', () {
      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with my leaves',
        build: () {
          when(mockRepository.getMyLeaves())
              .thenAnswer((_) async => testMyLeaves);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMyLeaves()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.myLeaves.length, 'myLeaves.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getMyLeaves()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getMyLeaves())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMyLeaves()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getMyLeaves()).called(1);
        },
      );
    });

    // ===== FetchPendingApprovals =====
    group('FetchPendingApprovals', () {
      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with pending approvals',
        build: () {
          when(mockRepository.getPendingApprovals())
              .thenAnswer((_) async => testPendingApprovals);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPendingApprovals()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.pendingApprovals.length,
                  'pendingApprovals.length', 1),
        ],
        verify: (_) {
          verify(mockRepository.getPendingApprovals()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getPendingApprovals())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchPendingApprovals()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getPendingApprovals()).called(1);
        },
      );
    });

    // ===== FetchAllLeaveRequests =====
    group('FetchAllLeaveRequests', () {
      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with all leave requests',
        build: () {
          when(mockRepository.getAllLeaveRequests())
              .thenAnswer((_) async => testAllRequests);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchAllLeaveRequests()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.allRequests.length, 'allRequests.length',
                  3),
        ],
        verify: (_) {
          verify(mockRepository.getAllLeaveRequests()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getAllLeaveRequests())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchAllLeaveRequests()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getAllLeaveRequests()).called(1);
        },
      );
    });

    // ===== ApproveLeave =====
    group('ApproveLeave', () {
      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with refreshed pending and actionCompleted',
        build: () {
          when(mockRepository.approveLeave('leave-3', remarks: 'Approved'))
              .thenAnswer(
            (_) async => LeaveRequestResponse(
              id: 'leave-3',
              userId: 'user-2',
              startDate: '2026-02-15',
              endDate: '2026-02-16',
              totalDays: 2,
              reason: 'Family function',
              status: 'APPROVED',
            ),
          );
          when(mockRepository.getPendingApprovals())
              .thenAnswer((_) async => []);
          return bloc;
        },
        act: (bloc) => bloc.add(
            const ApproveLeave('leave-3', remarks: 'Approved')),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.actionCompleted, 'actionCompleted', true)
              .having((s) => s.pendingApprovals.length,
                  'pendingApprovals.length', 0),
        ],
        verify: (_) {
          verify(mockRepository.approveLeave('leave-3',
                  remarks: 'Approved'))
              .called(1);
          verify(mockRepository.getPendingApprovals()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when approve throws',
        build: () {
          when(mockRepository.approveLeave('leave-3', remarks: 'Approved'))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(
            const ApproveLeave('leave-3', remarks: 'Approved')),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.approveLeave('leave-3',
                  remarks: 'Approved'))
              .called(1);
        },
      );
    });

    // ===== RejectLeave =====
    group('RejectLeave', () {
      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with refreshed pending and actionCompleted',
        build: () {
          when(mockRepository.rejectLeave('leave-3',
                  remarks: 'Not enough leave balance'))
              .thenAnswer(
            (_) async => LeaveRequestResponse(
              id: 'leave-3',
              userId: 'user-2',
              startDate: '2026-02-15',
              endDate: '2026-02-16',
              totalDays: 2,
              reason: 'Family function',
              status: 'REJECTED',
            ),
          );
          when(mockRepository.getPendingApprovals())
              .thenAnswer((_) async => []);
          return bloc;
        },
        act: (bloc) => bloc.add(const RejectLeave('leave-3',
            remarks: 'Not enough leave balance')),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.actionCompleted, 'actionCompleted', true),
        ],
        verify: (_) {
          verify(mockRepository.rejectLeave('leave-3',
                  remarks: 'Not enough leave balance'))
              .called(1);
          verify(mockRepository.getPendingApprovals()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when reject throws',
        build: () {
          when(mockRepository.rejectLeave('leave-3',
                  remarks: 'Not enough leave balance'))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const RejectLeave('leave-3',
            remarks: 'Not enough leave balance')),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.rejectLeave('leave-3',
                  remarks: 'Not enough leave balance'))
              .called(1);
        },
      );
    });

    // ===== CancelLeave =====
    group('CancelLeave', () {
      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with refreshed my leaves and actionCompleted',
        build: () {
          when(mockRepository.cancelLeave('leave-2')).thenAnswer(
            (_) async => LeaveRequestResponse(
              id: 'leave-2',
              userId: 'user-1',
              startDate: '2026-03-10',
              endDate: '2026-03-10',
              totalDays: 1,
              reason: 'Personal work',
              status: 'CANCELLED',
            ),
          );
          when(mockRepository.getMyLeaves())
              .thenAnswer((_) async => [testMyLeaves[0]]);
          return bloc;
        },
        act: (bloc) => bloc.add(const CancelLeave('leave-2')),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having(
                  (s) => s.actionCompleted, 'actionCompleted', true)
              .having((s) => s.myLeaves.length, 'myLeaves.length', 1),
        ],
        verify: (_) {
          verify(mockRepository.cancelLeave('leave-2')).called(1);
          verify(mockRepository.getMyLeaves()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when cancel throws',
        build: () {
          when(mockRepository.cancelLeave('leave-2'))
              .thenAnswer((_) async => throw Exception('Server error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const CancelLeave('leave-2')),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.cancelLeave('leave-2')).called(1);
        },
      );
    });

    // ===== FetchMyBalance =====
    group('FetchMyBalance', () {
      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with balances',
        build: () {
          when(mockRepository.getMyBalance(academicYear: '2025-2026'))
              .thenAnswer((_) async => testBalances);
          return bloc;
        },
        act: (bloc) => bloc.add(
            const FetchMyBalance(academicYear: '2025-2026')),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.balances.length, 'balances.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getMyBalance(
                  academicYear: '2025-2026'))
              .called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success without academic year parameter',
        build: () {
          when(mockRepository.getMyBalance())
              .thenAnswer((_) async => testBalances);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMyBalance()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.balances.length, 'balances.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getMyBalance()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getMyBalance())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMyBalance()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getMyBalance()).called(1);
        },
      );
    });

    // ===== FetchMySummary =====
    group('FetchMySummary', () {
      blocTest<LeaveBloc, LeaveState>(
        'emits loading then success with summary and balances',
        build: () {
          when(mockRepository.getMySummary())
              .thenAnswer((_) async => testSummary);
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMySummary()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>()
              .having((s) => s.isSuccess, 'isSuccess', true)
              .having((s) => s.summary?.pendingRequests,
                  'pendingRequests', 1)
              .having((s) => s.summary?.totalAllocated,
                  'totalAllocated', 22)
              .having((s) => s.balances.length, 'balances.length', 2),
        ],
        verify: (_) {
          verify(mockRepository.getMySummary()).called(1);
        },
      );

      blocTest<LeaveBloc, LeaveState>(
        'emits loading then failed when fetch throws',
        build: () {
          when(mockRepository.getMySummary())
              .thenAnswer((_) async => throw Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchMySummary()),
        expect: () => [
          isA<LeaveState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LeaveState>().having((s) => s.isFailed, 'isFailed', true),
        ],
        verify: (_) {
          verify(mockRepository.getMySummary()).called(1);
        },
      );
    });
  });
}
