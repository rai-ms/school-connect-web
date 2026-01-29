import 'dart:convert';

class TenantSettingsResponse {
  final String? id;
  final String? tenantId;

  // Branding
  final String? displayName;
  final String? tagline;
  final String? logoUrl;
  final String? faviconUrl;
  final String? primaryColor;
  final String? secondaryColor;
  final String? accentColor;

  // Academic Settings
  final String? academicYearStart;
  final String? academicYearEnd;
  final String? gradingSystem;
  final int? passingPercentage;
  final String? defaultWorkingDays;
  final String? schoolStartTime;
  final String? schoolEndTime;

  // Feature Flags
  final bool? attendanceEnabled;
  final bool? feesEnabled;
  final bool? examsEnabled;
  final bool? timetableEnabled;
  final bool? libraryEnabled;
  final bool? transportEnabled;
  final bool? hostelEnabled;
  final bool? parentPortalEnabled;
  final bool? studentPortalEnabled;
  final bool? smsNotificationsEnabled;
  final bool? emailNotificationsEnabled;
  final bool? pushNotificationsEnabled;

  // Locale Settings
  final String? timezone;
  final String? dateFormat;
  final String? timeFormat;
  final String? currency;
  final String? language;

  // Contact Settings
  final String? supportEmail;
  final String? supportPhone;
  final String? emergencyContact;

  // Timestamps
  final String? createdAt;
  final String? updatedAt;

  TenantSettingsResponse({
    this.id,
    this.tenantId,
    this.displayName,
    this.tagline,
    this.logoUrl,
    this.faviconUrl,
    this.primaryColor,
    this.secondaryColor,
    this.accentColor,
    this.academicYearStart,
    this.academicYearEnd,
    this.gradingSystem,
    this.passingPercentage,
    this.defaultWorkingDays,
    this.schoolStartTime,
    this.schoolEndTime,
    this.attendanceEnabled,
    this.feesEnabled,
    this.examsEnabled,
    this.timetableEnabled,
    this.libraryEnabled,
    this.transportEnabled,
    this.hostelEnabled,
    this.parentPortalEnabled,
    this.studentPortalEnabled,
    this.smsNotificationsEnabled,
    this.emailNotificationsEnabled,
    this.pushNotificationsEnabled,
    this.timezone,
    this.dateFormat,
    this.timeFormat,
    this.currency,
    this.language,
    this.supportEmail,
    this.supportPhone,
    this.emergencyContact,
    this.createdAt,
    this.updatedAt,
  });

  factory TenantSettingsResponse.fromRawJson(String str) =>
      TenantSettingsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TenantSettingsResponse.fromJson(Map<String, dynamic> json) =>
      TenantSettingsResponse(
        id: json['id'],
        tenantId: json['tenantId'],
        displayName: json['displayName'],
        tagline: json['tagline'],
        logoUrl: json['logoUrl'],
        faviconUrl: json['faviconUrl'],
        primaryColor: json['primaryColor'],
        secondaryColor: json['secondaryColor'],
        accentColor: json['accentColor'],
        academicYearStart: json['academicYearStart'],
        academicYearEnd: json['academicYearEnd'],
        gradingSystem: json['gradingSystem'],
        passingPercentage: json['passingPercentage'],
        defaultWorkingDays: json['defaultWorkingDays'],
        schoolStartTime: json['schoolStartTime'],
        schoolEndTime: json['schoolEndTime'],
        attendanceEnabled: json['attendanceEnabled'],
        feesEnabled: json['feesEnabled'],
        examsEnabled: json['examsEnabled'],
        timetableEnabled: json['timetableEnabled'],
        libraryEnabled: json['libraryEnabled'],
        transportEnabled: json['transportEnabled'],
        hostelEnabled: json['hostelEnabled'],
        parentPortalEnabled: json['parentPortalEnabled'],
        studentPortalEnabled: json['studentPortalEnabled'],
        smsNotificationsEnabled: json['smsNotificationsEnabled'],
        emailNotificationsEnabled: json['emailNotificationsEnabled'],
        pushNotificationsEnabled: json['pushNotificationsEnabled'],
        timezone: json['timezone'],
        dateFormat: json['dateFormat'],
        timeFormat: json['timeFormat'],
        currency: json['currency'],
        language: json['language'],
        supportEmail: json['supportEmail'],
        supportPhone: json['supportPhone'],
        emergencyContact: json['emergencyContact'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tenantId': tenantId,
        'displayName': displayName,
        'tagline': tagline,
        'logoUrl': logoUrl,
        'faviconUrl': faviconUrl,
        'primaryColor': primaryColor,
        'secondaryColor': secondaryColor,
        'accentColor': accentColor,
        'academicYearStart': academicYearStart,
        'academicYearEnd': academicYearEnd,
        'gradingSystem': gradingSystem,
        'passingPercentage': passingPercentage,
        'defaultWorkingDays': defaultWorkingDays,
        'schoolStartTime': schoolStartTime,
        'schoolEndTime': schoolEndTime,
        'attendanceEnabled': attendanceEnabled,
        'feesEnabled': feesEnabled,
        'examsEnabled': examsEnabled,
        'timetableEnabled': timetableEnabled,
        'libraryEnabled': libraryEnabled,
        'transportEnabled': transportEnabled,
        'hostelEnabled': hostelEnabled,
        'parentPortalEnabled': parentPortalEnabled,
        'studentPortalEnabled': studentPortalEnabled,
        'smsNotificationsEnabled': smsNotificationsEnabled,
        'emailNotificationsEnabled': emailNotificationsEnabled,
        'pushNotificationsEnabled': pushNotificationsEnabled,
        'timezone': timezone,
        'dateFormat': dateFormat,
        'timeFormat': timeFormat,
        'currency': currency,
        'language': language,
        'supportEmail': supportEmail,
        'supportPhone': supportPhone,
        'emergencyContact': emergencyContact,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  /// Check if a specific feature is enabled
  bool isFeatureEnabled(String feature) {
    switch (feature) {
      case 'attendance':
        return attendanceEnabled ?? true;
      case 'fees':
        return feesEnabled ?? true;
      case 'exams':
        return examsEnabled ?? true;
      case 'timetable':
        return timetableEnabled ?? true;
      case 'library':
        return libraryEnabled ?? false;
      case 'transport':
        return transportEnabled ?? false;
      case 'hostel':
        return hostelEnabled ?? false;
      case 'parentPortal':
        return parentPortalEnabled ?? true;
      case 'studentPortal':
        return studentPortalEnabled ?? true;
      default:
        return false;
    }
  }

  /// Get working days as a list
  List<String> get workingDaysList =>
      (defaultWorkingDays ?? 'MON,TUE,WED,THU,FRI').split(',');
}
