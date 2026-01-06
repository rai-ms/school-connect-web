part of '../../validation.dart';

class PhoneValidation extends StringValidation {
  const PhoneValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return const ValidationResult(message: 'Please enter Phone Number');
    }
    if (ValidationRegex.inverseNumberOnlyFilter.hasMatch(input)) {
      return const ValidationResult(message: ValidationStrings.improperPhone);
    } else if (input[0] == '0') {
      return const ValidationResult(message: ValidationStrings.improperPhone);
    }

    if (input.length < 10 || input.length > 15) {
      return const ValidationResult(message: ValidationStrings.improperPhone);
    }
    return const ValidationResult.proper();
  }
}
