part of '../../validation.dart';

class CountryCodeValidation extends StringValidation {
  const CountryCodeValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return const ValidationResult(message: ValidationStrings.emptyField);
    }

    if (input[0] != '+') {
      return const ValidationResult(message: ValidationStrings.improperCountryCodeFirst);
    }

    if (ValidationRegex.inverseNumberOnlyFilter.hasMatch(input.substring(1))) {
      return const ValidationResult(message: ValidationStrings.improperCountryCode);
    }

    if (input.length > 4 || input.length < 2) {
      return const ValidationResult(message: ValidationStrings.improperCountryCode);
    }

    if (input[1] == '0') {
      return const ValidationResult(
          message: ValidationStrings.improperCountryCode);
    }
    return const ValidationResult.proper();
  }
}
