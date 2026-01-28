import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../base/logger/app_logger_impl.dart';
import '../storage_service/secure_storage_service.dart';

/// Token refresh result
enum TokenRefreshResult {
  success,
  failed,
  noRefreshToken,
  networkError,
}

/// Token Manager with mutex-based refresh handling
///
/// Handles token refresh with proper concurrency control:
/// - Only one refresh can happen at a time
/// - Other requests wait for the ongoing refresh
/// - Prevents race conditions during multiple API calls
@lazySingleton
class TokenManager {
  final SecureStorageService _secureStorage;

  /// Completer for mutex-based refresh
  /// When null, no refresh is in progress
  Completer<TokenRefreshResult>? _refreshCompleter;

  /// Callback for performing the actual token refresh API call
  /// This should be set by the repository/service that handles auth
  Future<TokenRefreshResponse?> Function(String refreshToken)? onRefreshToken;

  /// Callback when refresh fails and user needs to re-login
  VoidCallback? onSessionExpired;

  TokenManager(this._secureStorage);

  // ============ Token Access ============

  /// Get current access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.getAccessToken();
  }

  /// Get current refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.getRefreshToken();
  }

  /// Get all tokens
  Future<AuthTokens?> getTokens() async {
    return await _secureStorage.getTokens();
  }

  /// Check if token is valid (not expired)
  Future<bool> isTokenValid() async {
    final tokens = await _secureStorage.getTokens();
    if (tokens == null) return false;
    return !tokens.isExpired;
  }

  /// Check if token is about to expire (within 5 minutes)
  Future<bool> isTokenAboutToExpire() async {
    final tokens = await _secureStorage.getTokens();
    if (tokens == null) return true;
    return tokens.isAboutToExpire;
  }

  // ============ Token Refresh (with Mutex) ============

  /// Refresh the access token
  ///
  /// Uses mutex pattern to prevent race conditions:
  /// - If a refresh is already in progress, waits for it to complete
  /// - Only one refresh API call is made even with multiple concurrent requests
  Future<TokenRefreshResult> refreshToken() async {
    // If refresh is already in progress, wait for it
    if (_refreshCompleter != null) {
      Log.d('TokenManager: Refresh already in progress, waiting...');
      return await _refreshCompleter!.future;
    }

    // Start new refresh
    _refreshCompleter = Completer<TokenRefreshResult>();
    Log.d('TokenManager: Starting token refresh');

    try {
      final result = await _performRefresh();
      _refreshCompleter?.complete(result);
      return result;
    } catch (e) {
      Log.e('TokenManager: Refresh failed', error: e);
      _refreshCompleter?.complete(TokenRefreshResult.failed);
      return TokenRefreshResult.failed;
    } finally {
      _refreshCompleter = null;
    }
  }

  /// Internal method to perform the actual refresh
  Future<TokenRefreshResult> _performRefresh() async {
    // Get current refresh token
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      Log.w('TokenManager: No refresh token available');
      _handleSessionExpired();
      return TokenRefreshResult.noRefreshToken;
    }

    // Check if callback is set
    if (onRefreshToken == null) {
      Log.e('TokenManager: onRefreshToken callback not set');
      return TokenRefreshResult.failed;
    }

    try {
      // Call the refresh API
      final response = await onRefreshToken!(refreshToken);

      if (response == null) {
        Log.w('TokenManager: Refresh API returned null');
        _handleSessionExpired();
        return TokenRefreshResult.failed;
      }

      // Save new tokens
      await _secureStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken ?? refreshToken,
        expiryTime: response.expiryTime,
      );

      Log.d('TokenManager: Token refreshed successfully');
      return TokenRefreshResult.success;
    } catch (e) {
      Log.e('TokenManager: Refresh API failed', error: e);
      return TokenRefreshResult.networkError;
    }
  }

  /// Handle session expiration
  void _handleSessionExpired() {
    Log.w('TokenManager: Session expired, triggering re-login');
    onSessionExpired?.call();
  }

  // ============ Token Storage ============

  /// Save new tokens (after login)
  Future<bool> saveTokens({
    required String accessToken,
    required String refreshToken,
    DateTime? expiryTime,
  }) async {
    return await _secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiryTime: expiryTime,
    );
  }

  /// Clear all tokens (logout)
  Future<bool> clearTokens() async {
    return await _secureStorage.clearTokens();
  }

  // ============ Proactive Refresh ============

  /// Ensure token is fresh before making a request
  ///
  /// Call this before critical API requests to proactively
  /// refresh the token if it's about to expire
  Future<bool> ensureFreshToken() async {
    final tokens = await getTokens();

    if (tokens == null) {
      Log.d('TokenManager: No tokens available');
      return false;
    }

    if (tokens.isExpired) {
      Log.d('TokenManager: Token expired, refreshing');
      final result = await refreshToken();
      return result == TokenRefreshResult.success;
    }

    if (tokens.isAboutToExpire) {
      Log.d('TokenManager: Token about to expire, proactively refreshing');
      final result = await refreshToken();
      return result == TokenRefreshResult.success;
    }

    return true;
  }
}

/// Response model for token refresh
class TokenRefreshResponse {
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiryTime;

  const TokenRefreshResponse({
    required this.accessToken,
    this.refreshToken,
    this.expiryTime,
  });

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) {
    return TokenRefreshResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiryTime: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'] as String)
          : null,
    );
  }
}

/// Typedef for callbacks
typedef VoidCallback = void Function();
