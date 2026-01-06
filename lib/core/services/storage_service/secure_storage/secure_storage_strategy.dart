import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../storage_contract/storage_contract.dart';

@Named('secure_storage')
@Singleton(as: StorageStrategy)
class SecureStorageStrategy implements StorageStrategy {
  final FlutterSecureStorage _storage;

  const SecureStorageStrategy()
    : _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  @override
  Future<void> write(String key, dynamic value) async {
    await _storage.write(key: key, value: value.toString());
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> clear() async {
    await _storage.deleteAll();
  }

  @override
  Future<T?> read<T>(String key) async {
    final value = await _storage.read(key: key);

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

  @override
  T? readSync<T>(String key) {
    // TODO: implement readSync
    throw UnimplementedError();
  }
}
