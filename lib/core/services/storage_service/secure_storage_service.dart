import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../base/logger/app_logger_impl.dart';
import '../../constants/storage_keys.dart';

/// Auth tokens data model
class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiryTime;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiryTime,
  });

  bool get isExpired {
    if (expiryTime == null) return false;
    return DateTime.now().isAfter(expiryTime!);
  }

  bool get isAboutToExpire {
    if (expiryTime == null) return false;
    // Consider token about to expire if less than 5 minutes remaining
    return DateTime.now().isAfter(expiryTime!.subtract(const Duration(minutes: 5)));
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiryTime': expiryTime?.toIso8601String(),
      };

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        expiryTime: json['expiryTime'] != null
            ? DateTime.parse(json['expiryTime'] as String)
            : null,
      );
}

/// Secure storage service for sensitive data (tokens, credentials)
/// Uses FlutterSecureStorage with platform-specific encryption
@lazySingleton
class SecureStorageService {
  late final FlutterSecureStorage _storage;

  // In-memory cache for faster access (tokens are frequently accessed)
  String? _cachedAccessToken;
  String? _cachedRefreshToken;
  String? _cachedUserId;

  SecureStorageService() {
    _initStorage();
  }

  void _initStorage() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
        resetOnError: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
    Log.d('SecureStorageService initialized');
  }

  // ============ Generic Methods ============

  /// Read value by key
  Future<String?> read(SecureStorageKey key) async {
    try {
      return await _storage.read(key: key.key);
    } catch (e) {
      Log.e('SecureStorage read error for ${key.key}', error: e);
      return null;
    }
  }

  /// Write value by key
  Future<bool> write(SecureStorageKey key, String value) async {
    try {
      await _storage.write(key: key.key, value: value);
      return true;
    } catch (e) {
      Log.e('SecureStorage write error for ${key.key}', error: e);
      return false;
    }
  }

  /// Delete value by key
  Future<bool> delete(SecureStorageKey key) async {
    try {
      await _storage.delete(key: key.key);
      return true;
    } catch (e) {
      Log.e('SecureStorage delete error for ${key.key}', error: e);
      return false;
    }
  }

  /// Check if key exists
  Future<bool> containsKey(SecureStorageKey key) async {
    try {
      return await _storage.containsKey(key: key.key);
    } catch (e) {
      Log.e('SecureStorage containsKey error for ${key.key}', error: e);
      return false;
    }
  }

  /// Delete all secure storage data
  Future<bool> deleteAll() async {
    try {
      await _storage.deleteAll();
      _clearCache();
      Log.d('SecureStorage: All data deleted');
      return true;
    } catch (e) {
      Log.e('SecureStorage deleteAll error', error: e);
      return false;
    }
  }

  // ============ Token Management ============

  /// Save access token
  Future<bool> saveAccessToken(String token) async {
    final success = await write(SecureStorageKey.accessToken, token);
    if (success) _cachedAccessToken = token;
    return success;
  }

  /// Get access token (uses cache for performance)
  Future<String?> getAccessToken() async {
    if (_cachedAccessToken != null) return _cachedAccessToken;
    _cachedAccessToken = await read(SecureStorageKey.accessToken);
    return _cachedAccessToken;
  }

  /// Save refresh token
  Future<bool> saveRefreshToken(String token) async {
    final success = await write(SecureStorageKey.refreshToken, token);
    if (success) _cachedRefreshToken = token;
    return success;
  }

  /// Get refresh token (uses cache for performance)
  Future<String?> getRefreshToken() async {
    if (_cachedRefreshToken != null) return _cachedRefreshToken;
    _cachedRefreshToken = await read(SecureStorageKey.refreshToken);
    return _cachedRefreshToken;
  }

  /// Save token expiry time
  Future<bool> saveTokenExpiry(DateTime expiryTime) async {
    return await write(
      SecureStorageKey.tokenExpiry,
      expiryTime.toIso8601String(),
    );
  }

  /// Get token expiry time
  Future<DateTime?> getTokenExpiry() async {
    final expiryStr = await read(SecureStorageKey.tokenExpiry);
    if (expiryStr == null) return null;
    try {
      return DateTime.parse(expiryStr);
    } catch (e) {
      return null;
    }
  }

  /// Save both tokens at once
  Future<bool> saveTokens({
    required String accessToken,
    required String refreshToken,
    DateTime? expiryTime,
  }) async {
    final results = await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
      if (expiryTime != null) saveTokenExpiry(expiryTime),
    ]);
    return results.every((success) => success);
  }

  /// Get all tokens as AuthTokens object
  Future<AuthTokens?> getTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    if (accessToken == null || refreshToken == null) return null;

    final expiryTime = await getTokenExpiry();
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiryTime: expiryTime,
    );
  }

  /// Clear all tokens
  Future<bool> clearTokens() async {
    final results = await Future.wait([
      delete(SecureStorageKey.accessToken),
      delete(SecureStorageKey.refreshToken),
      delete(SecureStorageKey.tokenExpiry),
    ]);
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    Log.d('SecureStorage: Tokens cleared');
    return results.every((success) => success);
  }

  /// Check if tokens exist
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  // ============ User Management ============

  /// Save user ID
  Future<bool> saveUserId(String userId) async {
    final success = await write(SecureStorageKey.userId, userId);
    if (success) _cachedUserId = userId;
    return success;
  }

  /// Get user ID (uses cache for performance)
  Future<String?> getUserId() async {
    if (_cachedUserId != null) return _cachedUserId;
    _cachedUserId = await read(SecureStorageKey.userId);
    return _cachedUserId;
  }

  /// Save user email
  Future<bool> saveUserEmail(String email) async {
    return await write(SecureStorageKey.userEmail, email);
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    return await read(SecureStorageKey.userEmail);
  }

  /// Save tenant ID
  Future<bool> saveTenantId(String tenantId) async {
    return await write(SecureStorageKey.tenantId, tenantId);
  }

  /// Get tenant ID
  Future<String?> getTenantId() async {
    return await read(SecureStorageKey.tenantId);
  }

  // ============ Complete Auth Data ============

  /// Clear all auth-related data (logout)
  Future<bool> clearAuthData() async {
    final results = await Future.wait([
      clearTokens(),
      delete(SecureStorageKey.userId),
      delete(SecureStorageKey.userEmail),
      delete(SecureStorageKey.tenantId),
      delete(SecureStorageKey.sessionId),
    ]);
    _clearCache();
    Log.d('SecureStorage: All auth data cleared');
    return results.every((success) => success);
  }

  /// Check if user is authenticated (has valid tokens)
  Future<bool> isAuthenticated() async {
    final tokens = await getTokens();
    if (tokens == null) return false;
    return !tokens.isExpired;
  }

  // ============ Private Helpers ============

  void _clearCache() {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    _cachedUserId = null;
  }

  /// Force refresh cache from storage
  Future<void> refreshCache() async {
    _cachedAccessToken = await read(SecureStorageKey.accessToken);
    _cachedRefreshToken = await read(SecureStorageKey.refreshToken);
    _cachedUserId = await read(SecureStorageKey.userId);
  }
}
