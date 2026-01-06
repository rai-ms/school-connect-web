part of '../../validation.dart';

class UsernameValidation extends StringValidation {
  const UsernameValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return isEmptyResult;
    } else if (input.length < 3 ||
        input.length > 20 ||
        !AppRegex.userName.hasMatch(input)) {
      return isImproperResult;
    }

    return const ValidationResult.proper();
  }

  ValidationResult get isEmptyResult =>
      const ValidationResult(message: ValidationStrings.emptyField);

  ValidationResult get isImproperResult =>
      const ValidationResult(message: ValidationStrings.invalidUserName);
}
