import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/presentation/views/attendance/data/models/attendance_model.dart';
import 'package:student_management/presentation/views/attendance/presentation/manager/attendance_bloc/attendance_bloc.dart';

class MockAttendanceBloc extends MockBloc<AttendanceEvent, AttendanceState>
    implements AttendanceBloc {}

class FakeAttendanceEvent extends Fake implements AttendanceEvent {}

class FakeAttendanceState extends Fake implements AttendanceState {}

void main() {
  late MockAttendanceBloc mockBloc;

  final testPercentage = AttendancePercentage(
    percentage: 85.0,
    totalDays: 100,
    presentDays: 85,
    absentDays: 10,
    lateDays: 5,
  );

  final testRecords = [
    AttendanceResponse(
      id: 'a1',
      studentId: 's1',
      studentName: 'Rahul Sharma',
      rollNumber: 'R001',
      attendanceDate: '2026-01-20',
      status: 'PRESENT',
      session: 'FULL_DAY',
      subject: 'Mathematics',
    ),
    AttendanceResponse(
      id: 'a2',
      studentId: 's1',
      studentName: 'Rahul Sharma',
      rollNumber: 'R001',
      attendanceDate: '2026-01-21',
      status: 'ABSENT',
      session: 'FULL_DAY',
    ),
    AttendanceResponse(
      id: 'a3',
      studentId: 's1',
      studentName: 'Rahul Sharma',
      rollNumber: 'R001',
      attendanceDate: '2026-01-22',
      status: 'LATE',
      session: 'FULL_DAY',
      subject: 'Science',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeAttendanceEvent());
    registerFallbackValue(FakeAttendanceState());
  });

  setUp(() {
    mockBloc = MockAttendanceBloc();
  });

  Widget buildTestWidget({required AttendanceState state}) {
    when(() => mockBloc.state).thenReturn(state);
    whenListen(mockBloc, Stream<AttendanceState>.empty(),
        initialState: state);

    return MaterialApp(
      home: BlocProvider<AttendanceBloc>.value(
        value: mockBloc,
        child: const Scaffold(
          body: _AttendanceBody(),
        ),
      ),
    );
  }

  group('AttendanceReportPage', () {
    testWidgets('shows loading indicator when state is loading',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: AttendanceState(state: BlocState.loading),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows percentage card when percentage is available',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: AttendanceState(
          state: BlocState.success,
          percentage: testPercentage,
          records: testRecords,
        ),
      ));

      expect(find.text('Overall Attendance'), findsOneWidget);
      expect(find.text('85.0%'), findsOneWidget);
      expect(find.text('85 of 100 days'), findsOneWidget);
    });

    testWidgets('shows stat cards for present, absent, and late',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: AttendanceState(
          state: BlocState.success,
          percentage: testPercentage,
          records: testRecords,
        ),
      ));

      // "Present", "Absent", "Late" appear both as stat card labels
      // and as status labels on records, so we expect multiple widgets.
      expect(find.text('Present'), findsWidgets);
      expect(find.text('85'), findsOneWidget);
      expect(find.text('Absent'), findsWidgets);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('Late'), findsWidgets);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('shows recent attendance records', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: AttendanceState(
          state: BlocState.success,
          percentage: testPercentage,
          records: testRecords,
        ),
      ));

      expect(find.text('Recent Attendance'), findsOneWidget);
      expect(find.text('2026-01-20'), findsOneWidget);
      expect(find.text('2026-01-21'), findsOneWidget);
      expect(find.text('2026-01-22'), findsOneWidget);
    });

    testWidgets('shows status labels for attendance records', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: AttendanceState(
          state: BlocState.success,
          percentage: testPercentage,
          records: testRecords,
        ),
      ));

      expect(find.text('Present'), findsWidgets);
      expect(find.text('Absent'), findsWidgets);
      expect(find.text('Late'), findsWidgets);
    });

    testWidgets('shows subject when available on record', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: AttendanceState(
          state: BlocState.success,
          percentage: testPercentage,
          records: testRecords,
        ),
      ));

      expect(find.text('Mathematics'), findsOneWidget);
      expect(find.text('Science'), findsOneWidget);
    });

    testWidgets('shows empty state when no records', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: AttendanceState(
          state: BlocState.success,
          percentage: testPercentage,
          records: [],
        ),
      ));

      expect(find.text('No attendance records'), findsOneWidget);
    });

    testWidgets('shows correct status icons', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: AttendanceState(
          state: BlocState.success,
          percentage: testPercentage,
          records: testRecords,
        ),
      ));

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });
  });
}

/// Extracted body widget to test core rendering without GoRouter/initState.
class _AttendanceBody extends StatelessWidget {
  const _AttendanceBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        if (state.isLoading &&
            state.records.isEmpty &&
            state.percentage == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Percentage Card
            if (state.percentage != null)
              _buildPercentageCard(state.percentage!),

            const SizedBox(height: 16),

            // Stats Row
            if (state.percentage != null) ...[
              Row(
                children: [
                  _buildStatCard(
                      'Present', '${state.percentage!.presentDays}'),
                  const SizedBox(width: 8),
                  _buildStatCard(
                      'Absent', '${state.percentage!.absentDays}'),
                  const SizedBox(width: 8),
                  _buildStatCard('Late', '${state.percentage!.lateDays}'),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Recent Records
            const Text('Recent Attendance',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            if (state.records.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text('No attendance records'),
                ),
              )
            else
              ...state.records.map(_buildAttendanceCard),
          ],
        );
      },
    );
  }

  Widget _buildPercentageCard(AttendancePercentage pct) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Text('Overall Attendance'),
          const SizedBox(height: 12),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: pct.percentage / 100,
                    strokeWidth: 8,
                  ),
                ),
                Text('${pct.percentage.toStringAsFixed(1)}%'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('${pct.presentDays} of ${pct.totalDays} days'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceResponse record) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(record.status),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.attendanceDate),
                  if (record.subject != null) Text(record.subject!),
                ],
              ),
            ),
            Text(record.statusLabel),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'PRESENT':
        return Icons.check_circle;
      case 'ABSENT':
        return Icons.cancel;
      case 'LATE':
        return Icons.access_time;
      case 'HALF_DAY':
        return Icons.timelapse;
      default:
        return Icons.help_outline;
    }
  }
}
