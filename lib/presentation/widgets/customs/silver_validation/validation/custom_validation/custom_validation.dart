part of '../validation.dart';

class CustomValidation<T> extends Validation {
  const CustomValidation({required this.logic});

  final ValidationLogic<T> logic;

  ValidationResult validate(T input) => logic(input);
  String? validationSimplified(T input) => validate(input).message;

  /// Takes a transformer Method which transforms the validation result
  /// to return specific error messages.\
  /// Validation Result contains current error message and error Type.
  ///
  /// Returns a validation method
  String? Function(T input) validationTransformer(
      String? Function(ValidationResult result) transform) {
    String? validationTransformed(T input) {
      var result = validate(input);
      return transform(result);
    }

    return validationTransformed;
  }

  bool isProper(T input) => validate(input).isProper;
}
