part of '../../validation.dart';

class EmptyValidation extends StringValidation {
  const EmptyValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return isEmptyResult;
    }

    return const ValidationResult.proper();
  }

  ValidationResult get isEmptyResult =>
      const ValidationResult(message: ValidationStrings.emptyField);
}
