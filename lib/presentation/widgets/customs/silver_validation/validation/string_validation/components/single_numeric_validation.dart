part of '../../validation.dart';

class SingleNumericValidation extends StringValidation {
  const SingleNumericValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return const ValidationResult(message: ValidationStrings.emptyField);
    }

    if (ValidationRegex.inverseNumberOnlyFilter.hasMatch(input)) {
      return const ValidationResult(
          message: ValidationStrings.improperSingleNumber);
    }

    return const ValidationResult.proper();
  }
}
