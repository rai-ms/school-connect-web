part of '../../validation.dart';

class DecimalValidation extends StringValidation {
  const DecimalValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return const ValidationResult(message: ValidationStrings.emptyField);
    }
    var num = double.tryParse(input);
    if (num == null) {
      return const ValidationResult(message: ValidationStrings.improperDecimal);
    } else {
      return const ValidationResult.proper();
    }
  }
}
