enum UserRole {
  superAdmin('SUPER_ADMIN'),
  schoolAdmin('ADMIN'),
  teacher('TEACHER'),
  parent('PARENT'),
  student('STUDENT');

  final String value;
  const UserRole(this.value);

  bool get isTeacher => this == UserRole.teacher;
  bool get isSchoolAdmin => this == UserRole.schoolAdmin;
  bool get isParent => this == UserRole.parent;
  bool get isStudent => this == UserRole.student;
  bool get isSuperAdmin => this == UserRole.superAdmin;

  static UserRole fromValue(String? value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.student,
    );
  }

  @override
  String toString() => value.replaceAll("_", " ");
}
