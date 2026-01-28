import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../base/logger/app_logger_impl.dart';
import '../storage_contract/storage_contract.dart';

@Named('secure_storage')
@Singleton(as: StorageStrategy)
class SecureStorageStrategy implements StorageStrategy {
  final FlutterSecureStorage _storage;

  /// In-memory cache for synchronous access
  /// FlutterSecureStorage is async-only, so we cache values in memory
  final Map<String, String> _cache = {};

  /// Whether the cache has been initialized
  bool _isInitialized = false;

  SecureStorageStrategy()
    : _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  /// Initialize cache by loading all stored values into memory
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final allValues = await _storage.readAll();
      _cache.addAll(allValues);
      _isInitialized = true;
      Log.d('SecureStorageStrategy initialized with ${_cache.length} cached values');
    } catch (e) {
      Log.e('Failed to initialize SecureStorageStrategy cache', error: e);
      _isInitialized = true; // Mark as initialized to prevent retry loops
    }
  }

  @override
  Future<void> write(String key, dynamic value) async {
    final stringValue = value.toString();
    await _storage.write(key: key, value: stringValue);
    // Update cache
    _cache[key] = stringValue;
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
    // Remove from cache
    _cache.remove(key);
  }

  @override
  Future<void> clear() async {
    await _storage.deleteAll();
    // Clear cache
    _cache.clear();
  }

  @override
  Future<T?> read<T>(String key) async {
    final value = await _storage.read(key: key);

    // Update cache with latest value
    if (value != null) {
      _cache[key] = value;
    } else {
      _cache.remove(key);
    }

    return _parseValue<T>(value);
  }

  @override
  T? readSync<T>(String key) {
    final value = _cache[key];
    return _parseValue<T>(value);
  }

  /// Parse string value to the requested type
  T? _parseValue<T>(String? value) {
    if (value == null) return null;

    // If caller expects String
    if (T == String) {
      return value as T;
    }

    // If caller expects int, bool, double – handle decoding
    if (T == int) {
      return int.tryParse(value) as T?;
    }
    if (T == double) {
      return double.tryParse(value) as T?;
    }
    if (T == bool) {
      return (value.toLowerCase() == 'true') as T?;
    }

    // If caller expects complex object → try JSON decode
    try {
      return jsonDecode(value) as T?;
    } catch (_) {
      return null;
    }
  }
}
