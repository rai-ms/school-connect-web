part of '../validation.dart';

typedef StringValidationLogic = ValidationResult Function(String);
typedef ValidationLogic<T> = ValidationResult Function(T input);

class ValidationResult {
  const ValidationResult.proper() : message = null, validationData = null;
  const ValidationResult.empty() : message = '', validationData = null;

  const ValidationResult({
    required this.message,
    this.validationData,
  });

  final String? message;
  final dynamic validationData;

  bool get isProper => message == null;

  ValidationResult copyWith({
    String? message,
    dynamic validationData,
  }) {
    return ValidationResult(
      message: message ?? this.message,
      validationData: validationData ?? this.validationData,
    );
  }

  @override
  String toString() => '$message';
}
