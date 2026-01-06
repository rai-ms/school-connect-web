part of '../validation.dart';

abstract class StringValidation extends Validation {
  const StringValidation();

  ValidationResult validate({required String input});

  ValidationResult validateNull(String? input) {
    if (input == null) {
      return const ValidationResult(message: ValidationStrings.emptyField);
    } else {
      return validate(input: input);
    }
  }

  String? validationSimplified(String? input) => validateNull(input).message;

  /// Takes a transformer Method which transforms the validation result
  /// to return specific error messages.\
  /// Validation Result contains current error message and error Type.
  ///
  /// Returns a validation method
  String? Function(String? input) validationTransformer(String? Function(ValidationResult result) transform) {
    String? validationTransformed(String? input) {
      var result = validateNull(input);
      return transform(result);
    }
    return validationTransformed;
  }

  bool isProper(String? input) => validateNull(input).isProper;
}
