class TenantStatistics {
  final int totalStudents;
  final int totalTeachers;
  final int totalParents;
  final int activeUsers;
  final int totalClasses;
  final double attendancePercentage;
  final int storageUsedMb;
  final Map<String, int> usersByRole;
  final Map<String, int> studentsByClass;

  TenantStatistics({
    this.totalStudents = 0,
    this.totalTeachers = 0,
    this.totalParents = 0,
    this.activeUsers = 0,
    this.totalClasses = 0,
    this.attendancePercentage = 0.0,
    this.storageUsedMb = 0,
    this.usersByRole = const {},
    this.studentsByClass = const {},
  });

  factory TenantStatistics.fromJson(Map<String, dynamic> json) {
    return TenantStatistics(
      totalStudents: (json['totalStudents'] as num?)?.toInt() ?? 0,
      totalTeachers: (json['totalTeachers'] as num?)?.toInt() ?? 0,
      totalParents: (json['totalParents'] as num?)?.toInt() ?? 0,
      activeUsers: (json['activeUsers'] as num?)?.toInt() ?? 0,
      totalClasses: (json['totalClasses'] as num?)?.toInt() ?? 0,
      attendancePercentage:
          (json['attendancePercentage'] as num?)?.toDouble() ?? 0.0,
      storageUsedMb: (json['storageUsedMb'] as num?)?.toInt() ?? 0,
      usersByRole: (json['usersByRole'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
          {},
      studentsByClass: (json['studentsByClass'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
          {},
    );
  }

  int get totalStaff =>
      activeUsers - totalStudents - totalTeachers - totalParents;
}
