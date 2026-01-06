part of '../../validation.dart';

class PercentageValidation extends StringValidation {
  const PercentageValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return const ValidationResult(message: ValidationStrings.emptyField);
    }

    var num = double.tryParse(input);
    if (num == null) {
      return const ValidationResult(
          message: ValidationStrings.improperPercentage);
    } else if (num > 100) {
      return const ValidationResult(
          message: ValidationStrings.invalidLengthPercentage);
    } else {
      return const ValidationResult.proper();
    }
  }
}
