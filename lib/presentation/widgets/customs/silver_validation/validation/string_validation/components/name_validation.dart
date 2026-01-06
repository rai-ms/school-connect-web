part of '../../validation.dart';

class NameValidation extends StringValidation {
  const NameValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return isEmptyResult;
    }

    if (input.isEmpty || input.length > 50) {
      return isImproperResult;
    }

    if (ValidationRegex.inverseAlphabetSpaceFilter.hasMatch(input)) {
      return isImproperResult;
    }

    return const ValidationResult.proper();
  }

  ValidationResult get isEmptyResult =>
      const ValidationResult(message: ValidationStrings.emptyField);

  ValidationResult get isImproperResult =>
      const ValidationResult(message: ValidationStrings.improperName);
}

class FirstNameValidator extends NameValidation {
  const FirstNameValidator();
  @override
  ValidationResult get isEmptyResult =>
      const ValidationResult(message: 'Please enter First Name');

  @override
  ValidationResult get isImproperResult =>
      const ValidationResult(message: 'Please enter a valid First Name');
}

class LastNameValidator extends NameValidation {
  const LastNameValidator();

  @override
  ValidationResult get isEmptyResult =>
      const ValidationResult(message: 'Please enter Last Name');

  @override
  ValidationResult get isImproperResult =>
      const ValidationResult(message: 'Please enter a valid Last Name');
}
