import 'package:student_management/presentation/views/dashboard/data/models/res/super_admin/get_all_users_response.dart';

class SuperAdminAllUsers {
  final String? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? phone;
  final String? avatarUrl;
  final String? primaryRole;
  final List<String>? roles;
  final String? status;
  final bool? emailVerified;
  final bool? mfaEnabled;
  final List<int>? lastLoginAt;
  final List<int>? createdAt;
  final List<int>? updatedAt;

  SuperAdminAllUsers({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.fullName,
    this.phone,
    this.avatarUrl,
    this.primaryRole,
    this.roles,
    this.status,
    this.emailVerified,
    this.mfaEnabled,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  SuperAdminAllUsers copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? fullName,
    String? phone,
    String? avatarUrl,
    String? primaryRole,
    List<String>? roles,
    String? status,
    bool? emailVerified,
    bool? mfaEnabled,
    List<int>? lastLoginAt,
    List<int>? createdAt,
    List<int>? updatedAt,
  }) => SuperAdminAllUsers(
    id: id ?? this.id,
    username: username ?? this.username,
    email: email ?? this.email,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    primaryRole: primaryRole ?? this.primaryRole,
    roles: roles ?? this.roles,
    status: status ?? this.status,
    emailVerified: emailVerified ?? this.emailVerified,
    mfaEnabled: mfaEnabled ?? this.mfaEnabled,
    lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory SuperAdminAllUsers.fromContent(Content content) {
    return SuperAdminAllUsers(
      email: content.email,
      avatarUrl: content.avatarUrl,
      createdAt: content.createdAt,
      emailVerified: content.emailVerified,
      firstName: content.firstName,
      fullName: content.fullName,
      id: content.id,
      lastLoginAt: content.lastLoginAt,
      lastName: content.lastName,
      mfaEnabled: content.mfaEnabled,
      phone: content.phone,
      primaryRole: content.primaryRole,
      roles: content.roles,
      status: content.status,
      updatedAt: content.updatedAt,
      username: content.username,
    );
  }
}
