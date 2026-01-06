import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Custom exceptions
class EnvFileNotFoundException implements Exception {
  final String message;
  EnvFileNotFoundException(this.message);

  @override
  String toString() => 'EnvFileNotFoundException: $message';
}

class EnvKeyNotFoundException implements Exception {
  final String message;
  EnvKeyNotFoundException(this.message);

  @override
  String toString() => 'EnvKeyNotFoundException: $message';
}

class EnvParseException implements Exception {
  final String message;
  EnvParseException(this.message);

  @override
  String toString() => 'EnvParseException: $message';
}

// Class to represent the result of .env file parsing
class EnvConfig {
  final Map<String, String> _values;

  EnvConfig(Map<String, String> values)
    : _values = Map.unmodifiable(
        Map.fromEntries(
          values.entries.map((e) => MapEntry(e.key.toUpperCase(), e.value)),
        ),
      );

  String? get(String key) => _values[key.toUpperCase()];

  String require(String key) {
    final value = get(key);
    if (value == null) {
      throw EnvKeyNotFoundException(
        'Required key "$key" not found in .env file',
      );
    }
    return value;
  }

  bool hasKey(String key) => _values.containsKey(key.toUpperCase());
}

// Class to handle .env file operations from assets
class EnvReader {
  static Future<EnvConfig> load({String assetPath = 'assets/env/.env'}) async {
    try {
      // Load the string content from assets
      final content = await rootBundle.loadString(assetPath, cache: true);

      final lines = content.split('\n');
      final configMap = <String, String>{};

      // Parse each line
      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty || line.startsWith('#')) continue;

        final parts = _splitLine(line);
        if (parts.length != 2) {
          throw EnvParseException('Invalid line format: $line');
        }

        final key = parts[0].trim();
        final value = parts[1].trim();

        if (!_isValidKey(key)) {
          throw EnvParseException('Invalid key format: $key');
        }

        String processedValue = _processValue(value);
        configMap[key] = processedValue;
      }

      return EnvConfig(configMap);
    } on FlutterError catch (e) {
      throw EnvFileNotFoundException(
        'Failed to load .env from assets at "$assetPath": $e',
      );
    } catch (e) {
      throw EnvParseException('Failed to parse .env file: $e');
    }
  }

  static List<String> _splitLine(String line) {
    final index = line.indexOf('=');
    if (index == -1) return [];
    return [line.substring(0, index), line.substring(index + 1)];
  }

  static bool _isValidKey(String key) {
    if (key.isEmpty) return false;
    final regExp = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
    return regExp.hasMatch(key);
  }

  static String _processValue(String value) {
    if (value.startsWith('"') && value.endsWith('"')) {
      return value.substring(1, value.length - 1).replaceAll('\\"', '"');
    }
    if (value.startsWith("'") && value.endsWith("'")) {
      return value.substring(1, value.length - 1).replaceAll("\\'", "'");
    }
    return value;
  }
}
