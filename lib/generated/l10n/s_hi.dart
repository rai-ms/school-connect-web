// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class SHi extends S {
  SHi([String locale = 'hi']) : super(locale);

  @override
  String get title => 'छात्र प्रबंधन ऐप';

  @override
  String get no_internet => 'इंटरनेट नहीं';

  @override
  String get upcomingClasses => 'आगामी कक्षाएं';

  @override
  String get quickActions => 'त्वरित कार्य';

  @override
  String get recentActivity => 'हाल की गतिविधि';

  @override
  String get safetyAndCompliance => 'सुरक्षा और अनुपालन';

  @override
  String get present => 'उपस्थित';

  @override
  String get totalStudents => 'कुल छात्र';

  @override
  String get attendance => 'उपस्थिति';

  @override
  String get classesToday => 'आज की कक्षाएं';

  @override
  String get assignments => 'असाइनमेंट';

  @override
  String get messages => 'संदेश';

  @override
  String get takeAttendance => 'उपस्थिति लें';

  @override
  String get createAssignment => 'असाइनमेंट बनाएं';

  @override
  String get scheduleClass => 'कक्षा शेड्यूल करें';

  @override
  String get viewReports => 'रिपोर्ट देखें';

  @override
  String get noUpcomingClasses => 'कोई आगामी कक्षाएं नहीं हैं';

  @override
  String get noRecentActivity => 'कोई हाल की गतिविधि नहीं';

  @override
  String get welcomeBack => 'आपका स्वागत है ';

  @override
  String get notifyMe => 'मुझे सूचित करें';

  @override
  String get grades => 'ग्रेड';

  @override
  String get schedule => 'शेड्यूल';

  @override
  String get students => 'छात्र';

  @override
  String get classes => 'कक्षाएं';

  @override
  String get tasks => 'कार्य';

  @override
  String get newAssignmentAdded => 'नया असाइनमेंट जोड़ा गया';

  @override
  String get gradeUpdatedForMathQuiz => 'गणित क्विज़ के लिए ग्रेड अपडेट किया गया';

  @override
  String get newStudentEnrolled => 'नया छात्र नामांकित हुआ';

  @override
  String get incidentReport => 'घटना रिपोर्ट';

  @override
  String get reportSafetyIncidents => 'सुरक्षा घटनाओं की रिपोर्ट करें';

  @override
  String get counseling => 'परामर्श';

  @override
  String get studentReferrals => 'छात्र संदर्भ';

  @override
  String get emergencyAlert => 'आपातकालीन चेतावनी';

  @override
  String get sosImmediateHelp => 'एसओएस - तत्काल सहायता';

  @override
  String get safetyLog => 'सुरक्षा लॉग';

  @override
  String get viewAllReports => 'सभी रिपोर्ट देखें';

  @override
  String get mathematics => 'गणित';

  @override
  String get physics => 'भौतिक विज्ञान';

  @override
  String get computerScience => 'कंप्यूटर विज्ञान';

  @override
  String room(Object roomNumber) {
    return 'कमरा $roomNumber';
  }

  @override
  String lab(Object labNumber) {
    return 'प्रयोगशाला $labNumber';
  }

  @override
  String hoursAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटे पहले',
      one: '1 घंटा पहले',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन पहले',
      one: '1 दिन पहले',
    );
    return '$_temp0';
  }
}
