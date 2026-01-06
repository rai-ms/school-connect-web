import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 's_en.dart';
import 's_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/s.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Student Management App'**
  String get title;

  /// No description provided for @no_internet.
  ///
  /// In en, this message translates to:
  /// **'No Internet'**
  String get no_internet;

  /// No description provided for @upcomingClasses.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Classes'**
  String get upcomingClasses;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @safetyAndCompliance.
  ///
  /// In en, this message translates to:
  /// **'Safety & Compliance'**
  String get safetyAndCompliance;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @totalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get totalStudents;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @classesToday.
  ///
  /// In en, this message translates to:
  /// **'Classes Today'**
  String get classesToday;

  /// No description provided for @assignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get assignments;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @takeAttendance.
  ///
  /// In en, this message translates to:
  /// **'Take Attendance'**
  String get takeAttendance;

  /// No description provided for @createAssignment.
  ///
  /// In en, this message translates to:
  /// **'Create Assignment'**
  String get createAssignment;

  /// No description provided for @scheduleClass.
  ///
  /// In en, this message translates to:
  /// **'Schedule Class'**
  String get scheduleClass;

  /// No description provided for @viewReports.
  ///
  /// In en, this message translates to:
  /// **'View Reports'**
  String get viewReports;

  /// No description provided for @noUpcomingClasses.
  ///
  /// In en, this message translates to:
  /// **'No upcoming classes'**
  String get noUpcomingClasses;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @notifyMe.
  ///
  /// In en, this message translates to:
  /// **'Notify me'**
  String get notifyMe;

  /// No description provided for @grades.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get grades;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classes;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @newAssignmentAdded.
  ///
  /// In en, this message translates to:
  /// **'New assignment added'**
  String get newAssignmentAdded;

  /// No description provided for @gradeUpdatedForMathQuiz.
  ///
  /// In en, this message translates to:
  /// **'Grade updated for Math Quiz'**
  String get gradeUpdatedForMathQuiz;

  /// No description provided for @newStudentEnrolled.
  ///
  /// In en, this message translates to:
  /// **'New student enrolled'**
  String get newStudentEnrolled;

  /// No description provided for @incidentReport.
  ///
  /// In en, this message translates to:
  /// **'Incident Report'**
  String get incidentReport;

  /// No description provided for @reportSafetyIncidents.
  ///
  /// In en, this message translates to:
  /// **'Report safety incidents'**
  String get reportSafetyIncidents;

  /// No description provided for @counseling.
  ///
  /// In en, this message translates to:
  /// **'Counseling'**
  String get counseling;

  /// No description provided for @studentReferrals.
  ///
  /// In en, this message translates to:
  /// **'Student referrals'**
  String get studentReferrals;

  /// No description provided for @emergencyAlert.
  ///
  /// In en, this message translates to:
  /// **'Emergency Alert'**
  String get emergencyAlert;

  /// No description provided for @sosImmediateHelp.
  ///
  /// In en, this message translates to:
  /// **'SOS - Immediate help'**
  String get sosImmediateHelp;

  /// No description provided for @safetyLog.
  ///
  /// In en, this message translates to:
  /// **'Safety Log'**
  String get safetyLog;

  /// No description provided for @viewAllReports.
  ///
  /// In en, this message translates to:
  /// **'View all reports'**
  String get viewAllReports;

  /// No description provided for @mathematics.
  ///
  /// In en, this message translates to:
  /// **'Mathematics'**
  String get mathematics;

  /// No description provided for @physics.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get physics;

  /// No description provided for @computerScience.
  ///
  /// In en, this message translates to:
  /// **'Computer Science'**
  String get computerScience;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room {roomNumber}'**
  String room(Object roomNumber);

  /// No description provided for @lab.
  ///
  /// In en, this message translates to:
  /// **'Lab {labNumber}'**
  String lab(Object labNumber);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String hoursAgo(num count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(num count);
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SEn();
    case 'hi': return SHi();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
