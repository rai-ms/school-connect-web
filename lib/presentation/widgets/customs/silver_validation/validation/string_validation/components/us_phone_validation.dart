part of '../../validation.dart';

class USPhoneValidation extends StringValidation {
  const USPhoneValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return const ValidationResult(message: ValidationStrings.emptyField);
    }

    if (!ValidationRegex.usPhoneFilter.hasMatch(input)) {
      return const ValidationResult(message: ValidationStrings.improperPhone);
    }

    return const ValidationResult.proper();
  }
}
