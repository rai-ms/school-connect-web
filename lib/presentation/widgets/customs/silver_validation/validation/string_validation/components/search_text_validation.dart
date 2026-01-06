part of '../../validation.dart';

class SearchTextValidation extends StringValidation {
  const SearchTextValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return const ValidationResult(
          message: ValidationStrings.emptySearchField);
    }

    if (input.length < 2) {
      return const ValidationResult(
          message: ValidationStrings.invalidSearchLengthString);
    }

    return const ValidationResult.proper();
  }
}

class DescriptionValidation extends StringValidation {
  const DescriptionValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.length < 3) {
      return const ValidationResult(
          message: ValidationStrings.invalidSubjectLength);
    }

    return const ValidationResult.proper();
  }
}
