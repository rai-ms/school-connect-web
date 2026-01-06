
import 'package:student_management/presentation/views/dashboard/domain/entities/user_role.dart';

class ProfileResponse {
  final String? id;
  final dynamic username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? phone;
  final dynamic avatarUrl;
  final UserRole? primaryRole;
  final List<String>? roles;
  final String? status;
  final bool? emailVerified;
  final bool? mfaEnabled;
  final List<int>? lastLoginAt;
  final List<int>? createdAt;
  final List<int>? updatedAt;

  ProfileResponse({
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

  ProfileResponse copyWith({
    String? id,
    dynamic username,
    String? email,
    String? firstName,
    String? lastName,
    String? fullName,
    String? phone,
    dynamic avatarUrl,
    UserRole? primaryRole,
    List<String>? roles,
    String? status,
    bool? emailVerified,
    bool? mfaEnabled,
    List<int>? lastLoginAt,
    List<int>? createdAt,
    List<int>? updatedAt,
  }) =>
      ProfileResponse(
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

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    fullName: json["fullName"],
    phone: json["phone"],
    avatarUrl: json["avatarUrl"],
    primaryRole: UserRole.fromValue(json["primaryRole"]),
    roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
    status: json["status"],
    emailVerified: json["emailVerified"],
    mfaEnabled: json["mfaEnabled"],
    lastLoginAt: json["lastLoginAt"] == null ? [] : List<int>.from(json["lastLoginAt"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? [] : List<int>.from(json["createdAt"]!.map((x) => x)),
    updatedAt: json["updatedAt"] == null ? [] : List<int>.from(json["updatedAt"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "fullName": fullName,
    "phone": phone,
    "avatarUrl": avatarUrl,
    "primaryRole": primaryRole?.name,
    "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
    "status": status,
    "emailVerified": emailVerified,
    "mfaEnabled": mfaEnabled,
    "lastLoginAt": lastLoginAt == null ? [] : List<dynamic>.from(lastLoginAt!.map((x) => x)),
    "createdAt": createdAt == null ? [] : List<dynamic>.from(createdAt!.map((x) => x)),
    "updatedAt": updatedAt == null ? [] : List<dynamic>.from(updatedAt!.map((x) => x)),
  };
}
