class LoginResponse {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final User? user;

  LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.user,
  });

  LoginResponse copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    User? user,
  }) =>
      LoginResponse(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        tokenType: tokenType ?? this.tokenType,
        expiresIn: expiresIn ?? this.expiresIn,
        user: user ?? this.user,
      );

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    tokenType: json["tokenType"],
    expiresIn: json["expiresIn"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "tokenType": tokenType,
    "expiresIn": expiresIn,
    "user": user?.toJson(),
  };
}

class User {
  final String? id;
  final dynamic username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? tenantId;
  final bool? emailVerified;
  final bool? mfaEnabled;

  User({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.tenantId,
    this.emailVerified,
    this.mfaEnabled,
  });

  User copyWith({
    String? id,
    dynamic username,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    String? tenantId,
    bool? emailVerified,
    bool? mfaEnabled,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        role: role ?? this.role,
        tenantId: tenantId ?? this.tenantId,
        emailVerified: emailVerified ?? this.emailVerified,
        mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    role: json["role"],
    tenantId: json["tenantId"],
    emailVerified: json["emailVerified"],
    mfaEnabled: json["mfaEnabled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "role": role,
    "tenantId": tenantId,
    "emailVerified": emailVerified,
    "mfaEnabled": mfaEnabled,
  };
}
