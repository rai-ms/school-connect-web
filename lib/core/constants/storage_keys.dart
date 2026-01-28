/// Type-safe storage keys for the application
/// Centralized location for all storage key constants

/// Secure storage keys (for sensitive data - tokens, credentials)
/// Stored in: FlutterSecureStorage (encrypted)
enum SecureStorageKey {
  // Auth tokens
  accessToken('access_token'),
  refreshToken('refresh_token'),
  tokenExpiry('token_expiry'),

  // User credentials
  userId('user_id'),
  userEmail('user_email'),
  userPhone('user_phone'),
  tenantId('tenant_id'),

  // MFA
  mfaToken('mfa_token'),

  // Session
  sessionId('session_id'),
  deviceId('device_id');

  final String key;
  const SecureStorageKey(this.key);
}

/// App storage keys (for non-sensitive app-level data)
/// Stored in: Hive
enum AppStorageKey {
  // App session flags
  hasSeenIntro('has_seen_intro'),
  isIntroCompleted('is_intro_completed'),
  appInstallDate('app_install_date'),
  appVersion('app_version'),

  // Preferences
  themeMode('theme_mode'),
  languageCode('language_code'),
  notificationsEnabled('notifications_enabled'),

  // FCM
  fcmToken('fcm_token'),
  fcmTokenUpdatedAt('fcm_token_updated_at'),

  // Cache timestamps
  lastSyncTime('last_sync_time'),
  cacheVersion('cache_version');

  final String key;
  const AppStorageKey(this.key);
}

/// User storage keys (for user-specific non-sensitive data)
/// Stored in: Hive (prefixed with user ID)
enum UserStorageKey {
  // User preferences
  defaultSchoolId('default_school_id'),
  lastViewedScreen('last_viewed_screen'),

  // User cache
  userProfileCache('user_profile_cache'),
  userSettingsCache('user_settings_cache');

  final String key;
  const UserStorageKey(this.key);

  /// Get key prefixed with user ID for user-specific storage
  String forUser(String userId) => '${userId}_$key';
}
