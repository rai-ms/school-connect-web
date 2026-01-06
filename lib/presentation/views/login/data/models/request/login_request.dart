

class LoginRequest{

  final String username, password;
  final bool rememberMe;

  const LoginRequest({
    required this.password,
    required this.rememberMe,
    required this.username
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "rememberMe": rememberMe
    };
  }
}