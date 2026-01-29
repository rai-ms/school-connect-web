abstract class RoutesName {
  static const String home = '/home';
  static const String splashScreen = '/';
  static const String loginScreen = '/login';
  static const String introScreen = '/introScreen';

  // Safety & Compliance Routes
  static const String incidentReport = '/incident-report';
  static const String counselingReferral = '/counseling-referral';
  static const String emergencyAlerts = '/emergency-alerts';
  static const String safetyLog = '/safety-log';
  static const String addSchool = '/add-school';

  // Exam Routes
  static const String examList = '/exams';
  static const String createExam = '/exams/create';
  static const String examDetails = '/exams/:examId';
  static const String markEntry = '/exams/:examId/marks';
  static const String reportCard = '/students/:studentId/report-card';

  // Timetable Routes
  static const String timetable = '/timetable/:classId';
  static const String teacherTimetable = '/timetable/teacher/:teacherId';

  // Fee Management Routes
  static const String feeDashboard = '/fees';
  static const String collectFee = '/fees/collect';
  static const String feeReceipt = '/fees/receipt/:paymentId';
  static const String pendingFees = '/fees/pending';
  static const String studentFees = '/fees/student/:studentId';

  // Leave Management Routes
  static const String leaveHistory = '/leave';
  static const String applyLeave = '/leave/apply';
  static const String leaveApprovals = '/leave/approvals';

  // Student Management Routes
  static const String studentList = '/students';
  static const String studentDetail = '/students/:studentId';
  static const String addStudent = '/students/add';

  // Teacher Management Routes
  static const String teacherList = '/teachers';
  static const String teacherDetail = '/teachers/:teacherId';
  static const String addTeacher = '/teachers/add';

  // Class Management Routes
  static const String classList = '/classes';
  static const String classDetail = '/classes/:classId';

  // Attendance Routes
  static const String markAttendance = '/attendance/mark/:classId';
  static const String attendanceReport = '/attendance/report/:studentId';

  // Notification Routes
  static const String notifications = '/notifications';

  // Auth Routes
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';

  // School Admin Routes
  static const String manageClasses = '/manage-classes';
  static const String reports = '/reports';
  static const String safetyHome = '/safety';
  static const String feeCollection = '/fee-collection';
  static const String settings = '/settings';

  // Profile & App Settings Routes
  static const String profile = '/profile';
  static const String appSettings = '/app-settings';
}
