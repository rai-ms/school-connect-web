abstract class ApiEndPoint {
  static const String login = "api/auth/login";
  static String profile(String userId) => "api/users/$userId";
  static const String config = "api/config/mobile";
  static const String getAllUsers = "api/users";
  static const String addSchool = "api/v1/schools";
}
