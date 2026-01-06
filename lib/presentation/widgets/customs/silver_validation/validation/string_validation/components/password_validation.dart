part of '../../validation.dart';

class PasswordValidation extends StringValidation {
  const PasswordValidation({this.passwordChecker});

  final RegExp? passwordChecker;

  @override
  ValidationResult validate({required String input}) {
    var passwordCheck =
        passwordChecker ?? ValidationRegex.passwordWithSpecialChar;

    if (input.isEmpty) {
      return const ValidationResult(message: 'Please enter a valid password');
    }

    if (input.length < 8) {
      return const ValidationResult(
          message: ValidationStrings.invalidLengthPassword);
    }

    if (passwordCheck.hasMatch(input)) {
      return const ValidationResult.proper();
    } else {
      return const ValidationResult(
          message: ValidationStrings.improperPassword);
    }
  }

  ValidationResult repeatValidate(
      {required String input, required String mainPassword}) {
    if (input.isEmpty) {
      return const ValidationResult(
          message: ValidationStrings.incorrectRepeatPassword);
    }

    if (input == mainPassword) {
      return const ValidationResult.proper();
    } else {
      return const ValidationResult(
          message: ValidationStrings.incorrectRepeatPassword);
    }
  }
}
