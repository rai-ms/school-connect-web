import 'dart:convert';
import 'package:crypto/crypto.dart';

class JwtUtils {
  // ==============================
  // JWT ENCODING
  // ==============================

  /// Encodes a JWT token using HS256 signature
  static String encode({
    required Map<String, dynamic> payload,
    required String secret,
    Map<String, dynamic>? header,
  }) {
    final jwtHeader = header ?? {'alg': 'HS256', 'typ': 'JWT'};

    final encodedHeader = _base64UrlEncode(jsonEncode(jwtHeader));
    final encodedPayload = _base64UrlEncode(jsonEncode(payload));

    final data = '$encodedHeader.$encodedPayload';
    final signature = _sign(data, secret);

    return '$data.$signature';
  }

  static String _base64UrlEncode(String input) {
    return base64Url.encode(utf8.encode(input)).replaceAll('=', '');
  }

  static String _sign(String data, String secret) {
    final hmac = Hmac(sha256, utf8.encode(secret));
    final digest = hmac.convert(utf8.encode(data));
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  // ==============================
  // JWT DECODING
  // ==============================

  /// Decode a JWT payload into a Map
  static Map<String, dynamic> decode(String token) {
    final parts = token.split(".");
    if (parts.length != 3) {
      throw FormatException('Invalid token');
    }
    try {
      final normalizedPayload = base64.normalize(parts[1]);
      final payloadString = utf8.decode(base64.decode(normalizedPayload));
      return jsonDecode(payloadString);
    } catch (_) {
      throw FormatException('Invalid payload');
    }
  }

  /// Try decoding and return null on failure
  static Map<String, dynamic>? tryDecode(String token) {
    try {
      return decode(token);
    } catch (_) {
      return null;
    }
  }

  // ==============================
  // CLAIM UTILITIES
  // ==============================

  /// Check if a specific claim exists
  static bool hasClaim(String token, String claim) {
    final payload = tryDecode(token);
    return payload?.containsKey(claim) ?? false;
  }

  /// Get specific claim value
  static dynamic getClaim(String token, String claim) {
    final payload = tryDecode(token);
    return payload?[claim];
  }

  // ==============================
  // SIGNATURE VERIFICATION
  // ==============================

  static bool verifySignature(String token, String secret) {
    final parts = token.split('.');
    if (parts.length != 3) return false;

    final data = '${parts[0]}.${parts[1]}';
    final signature = parts[2];

    final expectedSignature = _sign(data, secret);
    return expectedSignature == signature;
  }

  // ==============================
  // EXPIRATION AND TIME UTILITIES
  // ==============================

  static DateTime? _getDate(String token, String claim) {
    final payload = tryDecode(token);
    final value = payload?[claim];
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    return null;
  }

  /// Check if token is expired
  static bool isExpired(String token) {
    final exp = _getDate(token, 'exp');
    if (exp == null) return false;
    return DateTime.now().isAfter(exp);
  }

  /// Get remaining time before token expires
  static Duration? getRemainingTime(String token) {
    final exp = _getDate(token, 'exp');
    if (exp == null) return null;
    return exp.difference(DateTime.now());
  }

  /// Get issued at time
  static Duration? getTokenAge(String token) {
    final iat = _getDate(token, 'iat');
    if (iat == null) return null;
    return DateTime.now().difference(iat);
  }

  /// Check if token is about to expire within a threshold
  static bool isAboutToExpire(String token, {Duration threshold = const Duration(minutes: 5)}) {
    final remaining = getRemainingTime(token);
    if (remaining == null) return false;
    return remaining <= threshold;
  }

  // ==============================
  // REFRESH / REGENERATE
  // ==============================

  /// Refresh a token with new `iat` and `exp`
  static String refreshToken({
    required String token,
    required String secret,
    Duration expiresIn = const Duration(hours: 1),
  }) {
    final oldPayload = decode(token);

    final now = DateTime.now();
    final iat = (now.millisecondsSinceEpoch / 1000).floor();
    final exp = (now.add(expiresIn).millisecondsSinceEpoch / 1000).floor();

    final newPayload = Map<String, dynamic>.from(oldPayload)
      ..['iat'] = iat
      ..['exp'] = exp;

    return encode(payload: newPayload, secret: secret);
  }
}
