import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/base/base_service/base_service.dart'
    show BaseService;
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/core/utils/app_style.dart'
    show AppStyles, TextStyling;
import 'package:student_management/presentation/views/dashboard/presentation/pages/controller/add_school_super_admin_controller.dart';
import 'package:student_management/presentation/views/dashboard/presentation/pages/controller/dashboard_controller.dart'
    show DashboardController;
import 'package:student_management/presentation/views/dashboard/presentation/widgets/super_admin/bloc/add_school_bloc/add_school_bloc.dart';
import 'package:student_management/presentation/views/intro/presentation/pages/controller/intro_controller.dart';
import 'package:student_management/presentation/views/login/presentation/pages/controller/login_controller.dart'
    show LoginController;
import 'package:student_management/presentation/views/safety/counseling_referral_screen.dart';
import 'package:student_management/presentation/views/safety/emergency_alerts_screen.dart';
import 'package:student_management/presentation/views/safety/incident_report_screen.dart';
import 'package:student_management/presentation/views/exam/presentation/manager/exam_bloc/exam_bloc.dart';
import 'package:student_management/presentation/views/exam/presentation/pages/create_exam_page.dart';
import 'package:student_management/presentation/views/exam/presentation/pages/exam_details_page.dart';
import 'package:student_management/presentation/views/exam/presentation/pages/exam_list_page.dart';
import 'package:student_management/presentation/views/exam/presentation/pages/mark_entry_page.dart';
import 'package:student_management/presentation/views/exam/presentation/pages/report_card_page.dart';
import 'package:student_management/presentation/views/timetable/presentation/manager/timetable_bloc/timetable_bloc.dart';
import 'package:student_management/presentation/views/timetable/presentation/pages/timetable_page.dart';
import 'package:student_management/presentation/views/fee/presentation/manager/fee_bloc/fee_bloc.dart';
import 'package:student_management/presentation/views/fee/presentation/pages/fee_dashboard_page.dart';
import 'package:student_management/presentation/views/fee/presentation/pages/collect_fee_page.dart';
import 'package:student_management/presentation/views/fee/presentation/pages/fee_receipt_page.dart';
import 'package:student_management/presentation/views/fee/presentation/pages/pending_fees_page.dart';
import 'package:student_management/presentation/views/leave/presentation/manager/leave_bloc/leave_bloc.dart';
import 'package:student_management/presentation/views/leave/presentation/pages/leave_history_page.dart';
import 'package:student_management/presentation/views/leave/presentation/pages/apply_leave_page.dart';
import 'package:student_management/presentation/views/leave/presentation/pages/leave_approvals_page.dart';
import 'package:student_management/presentation/views/student/presentation/manager/student_bloc/student_bloc.dart';
import 'package:student_management/presentation/views/student/presentation/pages/student_list_page.dart';
import 'package:student_management/presentation/views/student/presentation/pages/student_detail_page.dart';
import 'package:student_management/presentation/views/student/presentation/pages/add_student_page.dart';
import 'package:student_management/presentation/views/teacher/presentation/manager/teacher_bloc/teacher_bloc.dart';
import 'package:student_management/presentation/views/teacher/presentation/pages/teacher_list_page.dart';
import 'package:student_management/presentation/views/teacher/presentation/pages/teacher_detail_page.dart';
import 'package:student_management/presentation/views/teacher/presentation/pages/add_teacher_page.dart';
import 'package:student_management/presentation/views/class_mgmt/presentation/manager/class_bloc/class_bloc.dart';
import 'package:student_management/presentation/views/class_mgmt/presentation/pages/class_list_page.dart';
import 'package:student_management/presentation/views/class_mgmt/presentation/pages/class_detail_page.dart';
import 'package:student_management/presentation/views/attendance/presentation/manager/attendance_bloc/attendance_bloc.dart';
import 'package:student_management/presentation/views/attendance/presentation/pages/mark_attendance_page.dart';
import 'package:student_management/presentation/views/attendance/presentation/pages/attendance_report_page.dart';
import 'package:student_management/presentation/views/notification/presentation/manager/notification_bloc/notification_bloc.dart';
import 'package:student_management/presentation/views/notification/presentation/pages/notification_list_page.dart';
import 'package:student_management/presentation/views/reports/presentation/pages/reports_page.dart';
import 'package:student_management/presentation/views/splash/presentation/pages/controller/splash_controller.dart'
    show SplashController;

import '../../base/logger/app_logger_impl.dart';
import 'route_names.dart';

@protected
@immutable
class RouteService extends BaseService<void, void> {
  static final RouteService routeService = RouteService();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'mainNavigation');

  @override
  void init({void param}) {
    Log.d("RouteService Initialized");
  }

  final GoRouter goRouter = GoRouter(
    initialLocation: RoutesName.splashScreen,
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    observers: [BotToastNavigatorObserver()],
    redirect: (context, state) {
      Log.d(state.uri.path);
      return null;
    },
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text("Link Broken", style: AppStyles.medium.medium.red),
        ),
      );
    },
    routes: <RouteBase>[
      // Splash Screen
      GoRoute(
        path: RoutesName.splashScreen,
        name: RoutesName.splashScreen,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashController()),
      ),

      // Auth Screens
      GoRoute(
        path: RoutesName.loginScreen,
        name: RoutesName.loginScreen,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginController()),
      ),
      // Main App Screens
      GoRoute(
        path: RoutesName.home,
        name: RoutesName.home,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: DashboardController()),
      ),

      GoRoute(
        path: RoutesName.introScreen,
        name: RoutesName.introScreen,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: IntroController()),
      ),

      // Safety & Compliance Routes
      GoRoute(
        path: RoutesName.incidentReport,
        name: RoutesName.incidentReport,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: IncidentReportScreen()),
      ),

      GoRoute(
        path: RoutesName.counselingReferral,
        name: RoutesName.counselingReferral,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CounselingReferralScreen()),
      ),

      GoRoute(
        path: RoutesName.emergencyAlerts,
        name: RoutesName.emergencyAlerts,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: EmergencyAlertsScreen()),
      ),

      GoRoute(
        path: RoutesName.safetyLog,
        name: RoutesName.safetyLog,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: Scaffold(
            body: Center(
              child: Text(
                'Safety Log - Coming Soon',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.addSchool,
        name: RoutesName.addSchool,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<AddSchoolBloc>(),
            child: AddSchoolSuperAdminController(),
          ),
        ),
      ),

      // Exam Routes
      GoRoute(
        path: RoutesName.examList,
        name: RoutesName.examList,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<ExamBloc>(),
            child: const ExamListPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.createExam,
        name: RoutesName.createExam,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<ExamBloc>(),
            child: const CreateExamPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.examDetails,
        name: RoutesName.examDetails,
        pageBuilder: (context, state) {
          final examId = state.pathParameters['examId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) => InjectorService.service.inject<ExamBloc>(),
              child: ExamDetailsPage(examId: examId),
            ),
          );
        },
      ),
      GoRoute(
        path: RoutesName.markEntry,
        name: RoutesName.markEntry,
        pageBuilder: (context, state) {
          final examId = state.pathParameters['examId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) => InjectorService.service.inject<ExamBloc>(),
              child: MarkEntryPage(examId: examId),
            ),
          );
        },
      ),
      GoRoute(
        path: RoutesName.reportCard,
        name: RoutesName.reportCard,
        pageBuilder: (context, state) {
          final studentId = state.pathParameters['studentId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) => InjectorService.service.inject<ExamBloc>(),
              child: ReportCardPage(studentId: studentId),
            ),
          );
        },
      ),

      // Timetable Routes
      GoRoute(
        path: RoutesName.timetable,
        name: RoutesName.timetable,
        pageBuilder: (context, state) {
          final classId = state.pathParameters['classId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) => InjectorService.service.inject<TimetableBloc>(),
              child: TimetablePage(classId: classId),
            ),
          );
        },
      ),
      GoRoute(
        path: RoutesName.teacherTimetable,
        name: RoutesName.teacherTimetable,
        pageBuilder: (context, state) {
          final teacherId = state.pathParameters['teacherId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) => InjectorService.service.inject<TimetableBloc>(),
              child: TimetablePage(
                classId: '',
                teacherId: teacherId,
                isTeacherView: true,
              ),
            ),
          );
        },
      ),

      // Fee Management Routes
      GoRoute(
        path: RoutesName.feeDashboard,
        name: RoutesName.feeDashboard,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<FeeBloc>(),
            child: const FeeDashboardPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.collectFee,
        name: RoutesName.collectFee,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<FeeBloc>(),
            child: const CollectFeePage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.feeReceipt,
        name: RoutesName.feeReceipt,
        pageBuilder: (context, state) {
          final paymentId = state.pathParameters['paymentId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) => InjectorService.service.inject<FeeBloc>(),
              child: FeeReceiptPage(paymentId: paymentId),
            ),
          );
        },
      ),
      GoRoute(
        path: RoutesName.pendingFees,
        name: RoutesName.pendingFees,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<FeeBloc>(),
            child: const PendingFeesPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.studentFees,
        name: RoutesName.studentFees,
        pageBuilder: (context, state) {
          final studentId = state.pathParameters['studentId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) => InjectorService.service.inject<FeeBloc>(),
              child: PendingFeesPage(studentId: studentId),
            ),
          );
        },
      ),

      // Leave Management Routes
      GoRoute(
        path: RoutesName.leaveHistory,
        name: RoutesName.leaveHistory,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<LeaveBloc>(),
            child: const LeaveHistoryPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.applyLeave,
        name: RoutesName.applyLeave,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<LeaveBloc>(),
            child: const ApplyLeavePage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.leaveApprovals,
        name: RoutesName.leaveApprovals,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<LeaveBloc>(),
            child: const LeaveApprovalsPage(),
          ),
        ),
      ),

      // Student Management Routes
      GoRoute(
        path: RoutesName.studentList,
        name: RoutesName.studentList,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<StudentBloc>(),
            child: const StudentListPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.addStudent,
        name: RoutesName.addStudent,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<StudentBloc>(),
            child: const AddStudentPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.studentDetail,
        name: RoutesName.studentDetail,
        pageBuilder: (context, state) {
          final studentId = state.pathParameters['studentId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) =>
                  InjectorService.service.inject<StudentBloc>(),
              child: StudentDetailPage(studentId: studentId),
            ),
          );
        },
      ),

      // Teacher Management Routes
      GoRoute(
        path: RoutesName.teacherList,
        name: RoutesName.teacherList,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<TeacherBloc>(),
            child: const TeacherListPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.addTeacher,
        name: RoutesName.addTeacher,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<TeacherBloc>(),
            child: const AddTeacherPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.teacherDetail,
        name: RoutesName.teacherDetail,
        pageBuilder: (context, state) {
          final teacherId = state.pathParameters['teacherId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) =>
                  InjectorService.service.inject<TeacherBloc>(),
              child: TeacherDetailPage(teacherId: teacherId),
            ),
          );
        },
      ),

      // Class Management Routes
      GoRoute(
        path: RoutesName.classList,
        name: RoutesName.classList,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) => InjectorService.service.inject<ClassBloc>(),
            child: const ClassListPage(),
          ),
        ),
      ),
      GoRoute(
        path: RoutesName.classDetail,
        name: RoutesName.classDetail,
        pageBuilder: (context, state) {
          final classId = state.pathParameters['classId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) =>
                  InjectorService.service.inject<ClassBloc>(),
              child: ClassDetailPage(classId: classId),
            ),
          );
        },
      ),

      // Attendance Routes
      GoRoute(
        path: RoutesName.markAttendance,
        name: RoutesName.markAttendance,
        pageBuilder: (context, state) {
          final classId = state.pathParameters['classId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) =>
                  InjectorService.service.inject<AttendanceBloc>(),
              child: MarkAttendancePage(classId: classId),
            ),
          );
        },
      ),
      GoRoute(
        path: RoutesName.attendanceReport,
        name: RoutesName.attendanceReport,
        pageBuilder: (context, state) {
          final studentId = state.pathParameters['studentId']!;
          return NoTransitionPage(
            child: BlocProvider(
              create: (ctx) =>
                  InjectorService.service.inject<AttendanceBloc>(),
              child: AttendanceReportPage(studentId: studentId),
            ),
          );
        },
      ),

      // Notification Routes
      GoRoute(
        path: RoutesName.notifications,
        name: RoutesName.notifications,
        pageBuilder: (context, state) => NoTransitionPage(
          child: BlocProvider(
            create: (ctx) =>
                InjectorService.service.inject<NotificationBloc>(),
            child: const NotificationListPage(),
          ),
        ),
      ),

      // Reports
      GoRoute(
        path: RoutesName.reports,
        name: RoutesName.reports,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ReportsPage(),
        ),
      ),
    ],
  );
}
