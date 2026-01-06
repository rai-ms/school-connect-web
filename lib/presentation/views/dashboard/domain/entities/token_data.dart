import 'dart:convert';

class TokenData {
  final String role;
  final String tenantId;
  final String sub;
  final int iat;
  final int exp;

  TokenData({
    required this.role,
    required this.tenantId,
    required this.sub,
    required this.iat,
    required this.exp,
  });

  TokenData copyWith({
    String? role,
    String? tenantId,
    String? sub,
    int? iat,
    int? exp,
  }) =>
      TokenData(
        role: role ?? this.role,
        tenantId: tenantId ?? this.tenantId,
        sub: sub ?? this.sub,
        iat: iat ?? this.iat,
        exp: exp ?? this.exp,
      );

  factory TokenData.fromRawJson(String str) => TokenData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TokenData.fromJson(Map<String, dynamic> json) => TokenData(
    role: json["role"],
    tenantId: json["tenantId"],
    sub: json["sub"],
    iat: json["iat"],
    exp: json["exp"],
  );

  Map<String, dynamic> toJson() => {
    "role": role,
    "tenantId": tenantId,
    "sub": sub,
    "iat": iat,
    "exp": exp,
  };
}
