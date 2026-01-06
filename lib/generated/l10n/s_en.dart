// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Student Management App';

  @override
  String get no_internet => 'No Internet';

  @override
  String get upcomingClasses => 'Upcoming Classes';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get safetyAndCompliance => 'Safety & Compliance';

  @override
  String get present => 'Present';

  @override
  String get totalStudents => 'Total Students';

  @override
  String get attendance => 'Attendance';

  @override
  String get classesToday => 'Classes Today';

  @override
  String get assignments => 'Assignments';

  @override
  String get messages => 'Messages';

  @override
  String get takeAttendance => 'Take Attendance';

  @override
  String get createAssignment => 'Create Assignment';

  @override
  String get scheduleClass => 'Schedule Class';

  @override
  String get viewReports => 'View Reports';

  @override
  String get noUpcomingClasses => 'No upcoming classes';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get notifyMe => 'Notify me';

  @override
  String get grades => 'Grades';

  @override
  String get schedule => 'Schedule';

  @override
  String get students => 'Students';

  @override
  String get classes => 'Classes';

  @override
  String get tasks => 'Tasks';

  @override
  String get newAssignmentAdded => 'New assignment added';

  @override
  String get gradeUpdatedForMathQuiz => 'Grade updated for Math Quiz';

  @override
  String get newStudentEnrolled => 'New student enrolled';

  @override
  String get incidentReport => 'Incident Report';

  @override
  String get reportSafetyIncidents => 'Report safety incidents';

  @override
  String get counseling => 'Counseling';

  @override
  String get studentReferrals => 'Student referrals';

  @override
  String get emergencyAlert => 'Emergency Alert';

  @override
  String get sosImmediateHelp => 'SOS - Immediate help';

  @override
  String get safetyLog => 'Safety Log';

  @override
  String get viewAllReports => 'View all reports';

  @override
  String get mathematics => 'Mathematics';

  @override
  String get physics => 'Physics';

  @override
  String get computerScience => 'Computer Science';

  @override
  String room(Object roomNumber) {
    return 'Room $roomNumber';
  }

  @override
  String lab(Object labNumber) {
    return 'Lab $labNumber';
  }

  @override
  String hoursAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }
}
