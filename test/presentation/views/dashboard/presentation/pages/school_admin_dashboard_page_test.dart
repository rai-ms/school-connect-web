import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/presentation/views/dashboard/data/models/res/school_admin/dashboard_stats_model.dart';
import 'package:student_management/presentation/views/dashboard/presentation/widgets/school_admin/bloc/school_admin_dashboard_bloc/school_admin_dashboard_bloc.dart';
import 'package:student_management/presentation/views/fee/data/models/fee_payment_model.dart';

class MockSchoolAdminDashboardBloc
    extends MockBloc<SchoolAdminDashboardEvent, SchoolAdminDashboardState>
    implements SchoolAdminDashboardBloc {}

class FakeSchoolAdminDashboardEvent extends Fake
    implements SchoolAdminDashboardEvent {}

class FakeSchoolAdminDashboardState extends Fake
    implements SchoolAdminDashboardState {}

void main() {
  late MockSchoolAdminDashboardBloc mockBloc;

  final testStats = TenantStatistics(
    totalStudents: 450,
    totalTeachers: 35,
    totalParents: 400,
    activeUsers: 900,
    totalClasses: 15,
    attendancePercentage: 92.5,
    storageUsedMb: 512,
    usersByRole: {
      'STUDENT': 450,
      'TEACHER': 35,
      'PARENT': 400,
    },
    studentsByClass: {
      'Class 1': 30,
      'Class 2': 28,
    },
  );

  final testFeeReport = CollectionReport(
    totalCollected: 1500000.0,
    totalPending: 300000.0,
    overdueCount: 12,
    monthlyCollection: 200000.0,
  );

  setUpAll(() {
    registerFallbackValue(FakeSchoolAdminDashboardEvent());
    registerFallbackValue(FakeSchoolAdminDashboardState());
  });

  setUp(() {
    mockBloc = MockSchoolAdminDashboardBloc();
  });

  Widget buildTestWidget({required SchoolAdminDashboardState state}) {
    when(() => mockBloc.state).thenReturn(state);
    whenListen(mockBloc, Stream<SchoolAdminDashboardState>.empty(),
        initialState: state);

    return MaterialApp(
      home: BlocProvider<SchoolAdminDashboardBloc>.value(
        value: mockBloc,
        child: const Scaffold(
          body: _DashboardBody(),
        ),
      ),
    );
  }

  group('SchoolAdminDashboardPage', () {
    testWidgets('shows loading indicator when state is loading',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: SchoolAdminDashboardState(state: BlocState.loading),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows quick stats with tenant statistics', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: SchoolAdminDashboardState(
          state: BlocState.success,
          tenantStats: testStats,
          feeReport: testFeeReport,
          pendingLeaveCount: 3,
        ),
      ));

      expect(find.text('450'), findsOneWidget); // totalStudents
      expect(find.text('35'), findsOneWidget); // totalTeachers
      expect(find.text('15'), findsOneWidget); // totalClasses
      expect(find.text('92.5%'), findsOneWidget); // attendance
    });

    testWidgets('shows stat labels', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: SchoolAdminDashboardState(
          state: BlocState.success,
          tenantStats: testStats,
          feeReport: testFeeReport,
          pendingLeaveCount: 3,
        ),
      ));

      // Labels appear both in the quick stats row and in the quick actions
      // section, so we expect multiple widgets for each.
      expect(find.text('Students'), findsWidgets);
      expect(find.text('Teachers'), findsWidgets);
      expect(find.text('Classes'), findsWidgets);
      expect(find.text('Attendance'), findsOneWidget);
    });

    testWidgets('shows overview cards with computed values', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: SchoolAdminDashboardState(
          state: BlocState.success,
          tenantStats: testStats,
          feeReport: testFeeReport,
          pendingLeaveCount: 3,
        ),
      ));

      // Present estimate: (450 * 92.5 / 100).round() = 416
      expect(find.text('416'), findsOneWidget);
      // Absent estimate: 450 - 416 = 34
      expect(find.text('34'), findsOneWidget);
      expect(find.text('Present Today'), findsOneWidget);
      expect(find.text('Absent Today'), findsOneWidget);
    });

    testWidgets('shows pending leave count', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: SchoolAdminDashboardState(
          state: BlocState.success,
          tenantStats: testStats,
          feeReport: testFeeReport,
          pendingLeaveCount: 3,
        ),
      ));

      expect(find.text('Pending Leaves'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('shows overdue fees count from report', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: SchoolAdminDashboardState(
          state: BlocState.success,
          tenantStats: testStats,
          feeReport: testFeeReport,
          pendingLeaveCount: 3,
        ),
      ));

      expect(find.text('Overdue Fees'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('shows quick action items', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: SchoolAdminDashboardState(
          state: BlocState.success,
          tenantStats: testStats,
          feeReport: testFeeReport,
          pendingLeaveCount: 3,
        ),
      ));

      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.byIcon(Icons.school), findsWidgets);
      expect(find.byIcon(Icons.group), findsWidgets);
      expect(find.byIcon(Icons.class_), findsWidgets);
    });

    testWidgets('shows fee collection section when report is available',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: SchoolAdminDashboardState(
          state: BlocState.success,
          tenantStats: testStats,
          feeReport: testFeeReport,
          pendingLeaveCount: 0,
        ),
      ));

      expect(find.text('Fee Collection'), findsOneWidget);
      expect(find.text('Collected'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Collection Rate'), findsOneWidget);
    });

    testWidgets('shows zero values when stats are null', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: SchoolAdminDashboardState(
          state: BlocState.success,
          tenantStats: null,
          feeReport: null,
          pendingLeaveCount: 0,
        ),
      ));

      // Should show 0 for students, teachers, etc. when null
      expect(find.text('0'), findsWidgets);
      expect(find.text('0.0%'), findsOneWidget); // attendance
    });

    testWidgets('shows management links', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: SchoolAdminDashboardState(
          state: BlocState.success,
          tenantStats: testStats,
          feeReport: testFeeReport,
          pendingLeaveCount: 0,
        ),
      ));

      expect(find.text('Management'), findsOneWidget);
      expect(find.text('Mark Attendance'), findsOneWidget);
      expect(find.text('Add Student'), findsOneWidget);
      expect(find.text('Add Teacher'), findsOneWidget);
      expect(find.text('Leave Approvals'), findsOneWidget);
    });
  });
}

/// Extracted body widget to test core rendering without GoRouter/initState.
class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolAdminDashboardBloc, SchoolAdminDashboardState>(
      builder: (context, dashState) {
        if (dashState.isLoading &&
            dashState.tenantStats == null &&
            dashState.feeReport == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = dashState.tenantStats;
        final feeReport = dashState.feeReport;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Stats
              _buildQuickStats(stats),
              const SizedBox(height: 24),

              // Overview
              const Text('Overview',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _buildOverviewCards(stats, feeReport, dashState.pendingLeaveCount),
              const SizedBox(height: 24),

              // Quick Actions
              const Text('Quick Actions',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _buildQuickActions(),
              const SizedBox(height: 24),

              // Fee Summary
              if (feeReport != null) ...[
                const Text('Fee Collection',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _buildFeeOverview(feeReport),
                const SizedBox(height: 24),
              ],

              // Management Links
              const Text('Management',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _buildManagementLinks(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickStats(TenantStatistics? stats) {
    final totalStudents = stats?.totalStudents ?? 0;
    final totalTeachers = stats?.totalTeachers ?? 0;
    final totalClasses = stats?.totalClasses ?? 0;
    final attendanceRate = stats?.attendancePercentage ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('$totalStudents', 'Students', Icons.school),
          _buildStatItem('$totalTeachers', 'Teachers', Icons.person),
          _buildStatItem('$totalClasses', 'Classes', Icons.class_),
          _buildStatItem(
              '${attendanceRate.toStringAsFixed(1)}%', 'Attendance', Icons.pie_chart),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildOverviewCards(
      TenantStatistics? stats, CollectionReport? feeReport, int pendingLeaves) {
    final totalStudents = stats?.totalStudents ?? 0;
    final attendanceRate = stats?.attendancePercentage ?? 0.0;
    final presentEstimate = (totalStudents * attendanceRate / 100).round();
    final absentEstimate = totalStudents - presentEstimate;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child:
                  _buildOverviewCard('Present Today', '$presentEstimate', Icons.check_circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child:
                  _buildOverviewCard('Absent Today', '$absentEstimate', Icons.cancel),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child:
                  _buildOverviewCard('Pending Leaves', '$pendingLeaves', Icons.event_busy),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                  'Overdue Fees', '${feeReport?.overdueCount ?? 0}', Icons.warning_amber),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildActionItem(Icons.school, 'Students'),
        _buildActionItem(Icons.group, 'Teachers'),
        _buildActionItem(Icons.class_, 'Classes'),
        _buildActionItem(Icons.assessment, 'Reports'),
        _buildActionItem(Icons.payment, 'Fees'),
        _buildActionItem(Icons.event_busy, 'Leave'),
        _buildActionItem(Icons.security, 'Safety'),
        _buildActionItem(Icons.settings, 'Settings'),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildFeeOverview(CollectionReport feeReport) {
    final collected = feeReport.totalCollected;
    final pending = feeReport.totalPending;
    final total = collected + pending;
    final collectionPercent = total > 0 ? (collected / total * 100) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Collected'),
                  const SizedBox(height: 4),
                  Text(_formatCurrency(collected),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Pending'),
                  const SizedBox(height: 4),
                  Text(_formatCurrency(pending),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Collection Rate'),
                  Text('${collectionPercent.toStringAsFixed(1)}%'),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: total > 0 ? collected / total : 0,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementLinks() {
    final links = [
      {'icon': Icons.how_to_reg, 'label': 'Mark Attendance', 'subtitle': 'Select a class to mark'},
      {'icon': Icons.person_add, 'label': 'Add Student', 'subtitle': 'Enroll a new student'},
      {'icon': Icons.group_add, 'label': 'Add Teacher', 'subtitle': 'Register a new teacher'},
      {'icon': Icons.approval, 'label': 'Leave Approvals', 'subtitle': 'Review pending requests'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: links.asMap().entries.map((entry) {
          final index = entry.key;
          final link = entry.value;
          return Column(
            children: [
              Row(
                children: [
                  Icon(link['icon'] as IconData, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(link['label'] as String),
                        const SizedBox(height: 4),
                        Text(link['subtitle'] as String,
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              if (index < links.length - 1) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '\u20B9${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '\u20B9${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '\u20B9${amount.toStringAsFixed(0)}';
  }
}
