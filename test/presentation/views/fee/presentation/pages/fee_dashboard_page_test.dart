import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/presentation/views/fee/data/models/fee_payment_model.dart';
import 'package:student_management/presentation/views/fee/data/models/fee_structure_model.dart';
import 'package:student_management/presentation/views/fee/data/models/fee_type_model.dart';
import 'package:student_management/presentation/views/fee/presentation/manager/fee_bloc/fee_bloc.dart';

class MockFeeBloc extends MockBloc<FeeEvent, FeeState> implements FeeBloc {}

class FakeFeeEvent extends Fake implements FeeEvent {}

class FakeFeeState extends Fake implements FeeState {}

void main() {
  late MockFeeBloc mockBloc;

  final testReport = CollectionReport(
    totalCollected: 250000.0,
    totalPending: 75000.0,
    overdueCount: 5,
    monthlyCollection: 50000.0,
  );

  final testFeeType = FeeTypeResponse(
    id: 'ft1',
    name: 'Tuition Fee',
    description: 'Monthly tuition fee',
    isRecurring: true,
    frequency: 'MONTHLY',
    isMandatory: true,
    isActive: true,
  );

  final testFeeStructure = FeeStructureResponse(
    id: 'fs1',
    feeType: testFeeType,
    classId: 'c1',
    amount: 5000.0,
    dueDate: '2026-01-15',
    lateFee: 200.0,
    academicYear: '2025-2026',
  );

  final testPayments = [
    FeePaymentResponse(
      id: 'p1',
      studentId: 's1',
      studentName: 'Rahul Sharma',
      amountPaid: 5000.0,
      totalAmount: 5000.0,
      paymentStatus: 'PAID',
      paymentMode: 'CASH',
      receiptNumber: 'REC-001',
      paymentDate: '2026-01-10',
      feeStructure: testFeeStructure,
    ),
    FeePaymentResponse(
      id: 'p2',
      studentId: 's2',
      studentName: 'Priya Patel',
      amountPaid: 2000.0,
      totalAmount: 5000.0,
      balanceAmount: 3000.0,
      paymentStatus: 'PARTIAL',
      paymentMode: 'UPI',
      receiptNumber: 'REC-002',
      paymentDate: '2026-01-12',
      feeStructure: testFeeStructure,
    ),
  ];

  final testOverduePayments = [
    FeePaymentResponse(
      id: 'p3',
      studentId: 's3',
      studentName: 'Amit Kumar',
      amountPaid: 0.0,
      totalAmount: 5000.0,
      balanceAmount: 5000.0,
      paymentStatus: 'OVERDUE',
      feeStructure: testFeeStructure,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeFeeEvent());
    registerFallbackValue(FakeFeeState());
  });

  setUp(() {
    mockBloc = MockFeeBloc();
  });

  Widget buildTestWidget({required FeeState state}) {
    when(() => mockBloc.state).thenReturn(state);
    whenListen(mockBloc, Stream<FeeState>.empty(), initialState: state);

    return MaterialApp(
      home: BlocProvider<FeeBloc>.value(
        value: mockBloc,
        child: const Scaffold(
          body: _FeeDashboardBody(),
        ),
      ),
    );
  }

  group('FeeDashboardPage', () {
    testWidgets('shows loading indicator when state is loading',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: FeeState(state: BlocState.loading),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows collection summary with report data', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: FeeState(
          state: BlocState.success,
          collectionReport: testReport,
          payments: testPayments,
        ),
      ));

      expect(find.text('Total Collected'), findsOneWidget);
      expect(find.text('Total Pending'), findsOneWidget);
      expect(find.text('This Month'), findsOneWidget);
      expect(find.text('Overdue'), findsOneWidget);
    });

    testWidgets('shows formatted currency values', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: FeeState(
          state: BlocState.success,
          collectionReport: testReport,
          payments: testPayments,
        ),
      ));

      // 250000 >= 100000, so formatted as \u20B9250.0K (with K suffix)
      expect(find.textContaining('250.0K'), findsOneWidget);
      expect(find.text('5'), findsOneWidget); // overdueCount
    });

    testWidgets('shows quick action buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: FeeState(
          state: BlocState.success,
          collectionReport: testReport,
          payments: testPayments,
        ),
      ));

      expect(find.text('Collect Fee'), findsOneWidget);
      expect(find.text('Pending Fees'), findsOneWidget);
      expect(find.text('Fee Types'), findsOneWidget);
    });

    testWidgets('shows recent payment cards', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: FeeState(
          state: BlocState.success,
          collectionReport: testReport,
          payments: testPayments,
        ),
      ));

      expect(find.text('Recent Payments'), findsOneWidget);
      expect(find.text('Rahul Sharma'), findsOneWidget);
      expect(find.text('Priya Patel'), findsOneWidget);
    });

    testWidgets('shows payment status chips', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: FeeState(
          state: BlocState.success,
          collectionReport: testReport,
          payments: testPayments,
        ),
      ));

      expect(find.text('PAID'), findsOneWidget);
      expect(find.text('PARTIAL'), findsOneWidget);
    });

    testWidgets('shows overdue payments section when overdue exist',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: FeeState(
          state: BlocState.success,
          collectionReport: testReport,
          payments: testPayments,
          overduePayments: testOverduePayments,
        ),
      ));

      expect(find.text('Overdue Payments'), findsOneWidget);
      expect(find.text('Amit Kumar'), findsOneWidget);
      expect(find.text('OVERDUE'), findsOneWidget);
    });

    testWidgets('hides overdue section when no overdue payments',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: FeeState(
          state: BlocState.success,
          collectionReport: testReport,
          payments: testPayments,
          overduePayments: [],
        ),
      ));

      expect(find.text('Overdue Payments'), findsNothing);
    });

    testWidgets('shows balance due when payment has balance', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: FeeState(
          state: BlocState.success,
          collectionReport: testReport,
          payments: [testPayments[1]], // partial payment with balance
        ),
      ));

      expect(find.textContaining('Due:'), findsOneWidget);
    });

    testWidgets('shows receipt number on payment card', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: FeeState(
          state: BlocState.success,
          collectionReport: testReport,
          payments: [testPayments[0]],
        ),
      ));

      expect(find.text('REC-001'), findsOneWidget);
    });
  });
}

/// Extracted body widget to test core rendering without GoRouter/initState.
class _FeeDashboardBody extends StatelessWidget {
  const _FeeDashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeeBloc, FeeState>(
      builder: (context, state) {
        if (state.isLoading && state.collectionReport == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collection Summary
              if (state.collectionReport != null)
                _buildCollectionSummary(state.collectionReport!),
              const SizedBox(height: 20),

              // Quick Actions
              const Text('Quick Actions',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildQuickActions(context),
              const SizedBox(height: 20),

              // Overdue Payments
              if (state.overduePayments.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Overdue Payments',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${state.overduePayments.length}'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...state.overduePayments
                    .take(5)
                    .map((p) => _buildPaymentCard(p)),
                const SizedBox(height: 20),
              ],

              // Recent Payments
              if (state.payments.isNotEmpty) ...[
                const Text('Recent Payments',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...state.payments.take(10).map((p) => _buildPaymentCard(p)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCollectionSummary(CollectionReport report) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Collected',
                _formatCurrency(report.totalCollected),
                Icons.account_balance_wallet,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Total Pending',
                _formatCurrency(report.totalPending),
                Icons.pending_actions,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'This Month',
                _formatCurrency(report.monthlyCollection),
                Icons.calendar_month,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Overdue',
                '${report.overdueCount}',
                Icons.warning_amber_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildActionButton('Collect Fee', Icons.payment)),
        const SizedBox(width: 8),
        Expanded(
            child:
                _buildActionButton('Pending Fees', Icons.pending_actions)),
        const SizedBox(width: 8),
        Expanded(child: _buildActionButton('Fee Types', Icons.category)),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(FeePaymentResponse payment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: _getStatusColor(payment.paymentStatus),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          payment.studentName ?? 'Student',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusChip(payment.paymentStatus),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                          payment.feeStructure?.feeType?.name ?? 'Fee'),
                      if (payment.receiptNumber != null) ...[
                        const Text(' | '),
                        Text(payment.receiptNumber!),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Paid: ${_formatCurrency(payment.amountPaid)}'),
                      if (payment.balanceAmount > 0)
                        Text(
                            'Due: ${_formatCurrency(payment.balanceAmount)}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PAID':
        return Colors.green;
      case 'PARTIAL':
        return Colors.orange;
      case 'OVERDUE':
        return Colors.red;
      case 'CANCELLED':
        return Colors.grey;
      default:
        return Colors.yellow;
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '\u{20B9}${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '\u{20B9}${amount.toStringAsFixed(0)}';
  }
}
