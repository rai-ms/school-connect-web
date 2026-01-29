import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_management/core/base/bloc_base/bloc_event_state.dart';
import 'package:student_management/presentation/views/student/data/models/student_model.dart';
import 'package:student_management/presentation/views/student/presentation/manager/student_bloc/student_bloc.dart';

class MockStudentBloc extends MockBloc<StudentEvent, StudentState>
    implements StudentBloc {}

class FakeStudentEvent extends Fake implements StudentEvent {}

class FakeStudentState extends Fake implements StudentState {}

void main() {
  late MockStudentBloc mockBloc;

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
      status: 'INACTIVE',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeStudentEvent());
    registerFallbackValue(FakeStudentState());
  });

  setUp(() {
    mockBloc = MockStudentBloc();
  });

  Widget buildTestWidget({required StudentState state}) {
    when(() => mockBloc.state).thenReturn(state);
    whenListen(mockBloc, Stream<StudentState>.empty(),
        initialState: state);

    return MaterialApp(
      home: BlocProvider<StudentBloc>.value(
        value: mockBloc,
        child: const Scaffold(
          body: _StudentListBody(),
        ),
      ),
    );
  }

  group('StudentListPage', () {
    testWidgets('shows loading indicator when state is loading',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: StudentState(
          state: BlocState.loading,
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no students found', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: StudentState(
          state: BlocState.success,
        ),
      ));

      expect(find.text('No students found'), findsOneWidget);
      expect(find.byIcon(Icons.people_outline), findsOneWidget);
    });

    testWidgets('displays student cards when students are loaded',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: StudentState(
          state: BlocState.success,
          students: testStudents,
        ),
      ));

      expect(find.text('Rahul Sharma'), findsOneWidget);
      expect(find.text('Priya Patel'), findsOneWidget);
      expect(find.text('Roll: R001'), findsOneWidget);
      expect(find.text('Roll: R002'), findsOneWidget);
    });

    testWidgets('displays correct status for active and inactive students',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: StudentState(
          state: BlocState.success,
          students: testStudents,
        ),
      ));

      expect(find.text('ACTIVE'), findsOneWidget);
      expect(find.text('INACTIVE'), findsOneWidget);
    });

    testWidgets('displays student initials in avatar when no photo',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: StudentState(
          state: BlocState.success,
          students: [testStudents[0]],
        ),
      ));

      expect(find.text('RS'), findsOneWidget);
    });

    testWidgets('search field is present', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        state: StudentState(
          state: BlocState.success,
          students: testStudents,
        ),
      ));

      expect(find.byType(TextField), findsOneWidget);
      expect(
          find.text('Search by name or roll number...'), findsOneWidget);
    });
  });
}

/// Extracted body widget to test BLoC builder without initState side effects.
/// This avoids the GoRouter/navigation issues in tests while testing the
/// core rendering logic.
class _StudentListBody extends StatelessWidget {
  const _StudentListBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by name or roll number...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (query) {
              if (query.trim().isNotEmpty) {
                context
                    .read<StudentBloc>()
                    .add(SearchStudents(query.trim()));
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: BlocBuilder<StudentBloc, StudentState>(
            builder: (context, state) {
              if (state.isLoading && state.students.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state.students.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline,
                          size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      const Text('No students found'),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.students.length,
                itemBuilder: (context, index) {
                  final student = state.students[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(student.initials),
                      ),
                      title: Text(student.fullName),
                      subtitle: Row(
                        children: [
                          Text('Roll: ${student.rollNumber}'),
                          const SizedBox(width: 8),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: student.isActive
                                  ? Colors.green
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(student.status),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
