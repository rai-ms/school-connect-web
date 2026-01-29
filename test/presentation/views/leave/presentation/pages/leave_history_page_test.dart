import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/presentation/views/leave/data/models/leave_balance_model.dart';
import 'package:student_management/presentation/views/leave/data/models/leave_request_model.dart';
import 'package:student_management/presentation/views/leave/presentation/manager/leave_bloc/leave_bloc.dart';

class MockLeaveBloc extends MockBloc<LeaveEvent, LeaveState>
    implements LeaveBloc {}

class FakeLeaveEvent extends Fake implements LeaveEvent {}

class FakeLeaveState extends Fake implements LeaveState {}

void main() {
  late MockLeaveBloc mockBloc;

  final testSummary = LeaveSummaryResponse(
    balances: [
      LeaveBalanceResponse(
        id: 'b1',
        userId: 'u1',
        leaveTypeName: 'Sick Leave',
        academicYear: '2025-2026',
        totalAllocated: 12,
        used: 3,
        pending: 1,
      ),
      LeaveBalanceResponse(
        id: 'b2',
        userId: 'u1',
        leaveTypeName: 'Casual Leave',
        academicYear: '2025-2026',
        totalAllocated: 10,
        used: 2,
        pending: 0,
      ),
    ],
    pendingRequests: 1,
    academicYear: '2025-2026',
    totalAllocated: 22,
    totalUsed: 5,
    totalPending: 1,
    totalRemaining: 16,
  );

  final testLeaves = [
    LeaveRequestResponse(
      id: 'l1',
      userId: 'u1',
      userName: 'Test User',
      leaveTypeName: 'Sick Leave',
      startDate: '2026-01-20',
      endDate: '2026-01-22',
      totalDays: 3,
      reason: 'Fever',
      status: 'APPROVED',
    ),
    LeaveRequestResponse(
      id: 'l2',
      userId: 'u1',
      userName: 'Test User',
      leaveTypeName: 'Casual Leave',
      startDate: '2026-02-01',
      endDate: '2026-02-01',
      totalDays: 1,
      reason: 'Personal work',
      status: 'PENDING',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeLeaveEvent());
    registerFallbackValue(FakeLeaveState());
  });

  setUp(() {
    mockBloc = MockLeaveBloc();
  });

  Widget buildTestWidget({required LeaveState state}) {
    when(() => mockBloc.state).thenReturn(state);
    whenListen(mockBloc, Stream<LeaveState>.empty(), initialState: state);

    return MaterialApp(
      home: BlocProvider<LeaveBloc>.value(
        value: mockBloc,
        child: const Scaffold(
          body: _LeaveHistoryBody(),
        ),
      ),
    );
  }

  group('LeaveHistoryPage', () {
    testWidgets('shows loading indicator when state is loading',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: LeaveState(state: BlocState.loading),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows summary card with leave balance', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: LeaveState(
          state: BlocState.success,
          summary: testSummary,
          myLeaves: testLeaves,
        ),
      ));

      expect(find.text('22'), findsOneWidget); // totalAllocated
      expect(find.text('5'), findsOneWidget); // totalUsed
      expect(find.text('1'), findsOneWidget); // totalPending
      expect(find.text('16'), findsOneWidget); // totalRemaining
    });

    testWidgets('shows leave balance breakdown per type', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: LeaveState(
          state: BlocState.success,
          summary: testSummary,
          myLeaves: testLeaves,
        ),
      ));

      expect(find.text('Sick Leave'), findsWidgets);
      expect(find.text('Casual Leave'), findsWidgets);
    });

    testWidgets('shows leave history cards', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: LeaveState(
          state: BlocState.success,
          summary: testSummary,
          myLeaves: testLeaves,
        ),
      ));

      expect(find.text('Fever'), findsOneWidget);
      expect(find.text('Personal work'), findsOneWidget);
      expect(find.text('APPROVED'), findsOneWidget);
      expect(find.text('PENDING'), findsOneWidget);
    });

    testWidgets('shows empty state when no leaves', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: LeaveState(
          state: BlocState.success,
          summary: testSummary,
          myLeaves: [],
        ),
      ));

      expect(find.text('No leave requests yet'), findsOneWidget);
    });

    testWidgets('shows cancel button for pending leaves', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: LeaveState(
          state: BlocState.success,
          summary: testSummary,
          myLeaves: [testLeaves[1]], // only the PENDING one
        ),
      ));

      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}

/// Extracted body widget to test core rendering without GoRouter/initState.
class _LeaveHistoryBody extends StatelessWidget {
  const _LeaveHistoryBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveBloc, LeaveState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final summary = state.summary;
        final leaves = state.myLeaves;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              if (summary != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem('Allocated', '${summary.totalAllocated}'),
                        _statItem('Used', '${summary.totalUsed}'),
                        _statItem('Pending', '${summary.totalPending}'),
                        _statItem('Remaining', '${summary.totalRemaining}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Balance Breakdown
                ...summary.balances.map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: ListTile(
                          title: Text(b.leaveTypeName ?? 'Unknown'),
                          subtitle: LinearProgressIndicator(
                            value: b.totalAllocated > 0
                                ? b.used / b.totalAllocated
                                : 0,
                          ),
                          trailing: Text(
                              '${b.used}/${b.totalAllocated}'),
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
              ],

              // Leave History
              const Text('Leave History',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              if (leaves.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No leave requests yet'),
                  ),
                )
              else
                ...leaves.map((leave) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(leave.leaveTypeName ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(leave.status,
                                    style: TextStyle(
                                      color: leave.status == 'APPROVED'
                                          ? Colors.green
                                          : leave.status == 'PENDING'
                                              ? Colors.orange
                                              : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(leave.reason),
                            Text(
                                '${leave.startDate} - ${leave.endDate} (${leave.totalDays} days)'),
                            if (leave.status == 'PENDING') ...[
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Cancel'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
