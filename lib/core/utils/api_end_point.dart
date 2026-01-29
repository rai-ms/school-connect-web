abstract class ApiEndPoint {
  static const String login = "api/auth/login";
  static String profile(String userId) => "api/users/$userId";
  static const String config = "api/config/mobile";
  static const String getAllUsers = "api/users";
  static const String addSchool = "api/v1/schools";

  // Tenant Settings
  static const String tenantSettings = "api/tenant/settings";
  static const String tenantBranding = "api/tenant/settings/branding";
  static const String tenantFeatures = "api/tenant/settings/features";

  // Platform Config (Super Admin)
  static const String platformConfig = "api/superadmin/platform/config";
  static const String platformFeatures = "api/superadmin/platform/features";
  static const String platformBranding = "api/superadmin/platform/branding";

  // User Statistics
  static const String userStatistics = "users/statistics";

  // Tenant Statistics
  static const String tenantStatistics = "api/tenants/statistics";

  // Fee Reports
  static const String feeCollectionReport = "api/fees/report/collection";

  // Leave
  static const String pendingLeaveRequests = "api/leave/requests/pending";

  // Auth - Password Management
  static const String forgotPassword = "api/auth/forgot-password";
  static const String resetPassword = "api/auth/reset-password";
  static const String changePassword = "api/auth/change-password";
}
