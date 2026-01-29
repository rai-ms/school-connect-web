class ProfileUpdateRequest {
  final String userId;
  final String token;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? avatarUrl;

  const ProfileUpdateRequest({
    required this.userId,
    required this.token,
    this.firstName,
    this.lastName,
    this.phone,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (firstName != null) map['firstName'] = firstName;
    if (lastName != null) map['lastName'] = lastName;
    if (phone != null) map['phone'] = phone;
    if (avatarUrl != null) map['avatarUrl'] = avatarUrl;
    return map;
  }
}
