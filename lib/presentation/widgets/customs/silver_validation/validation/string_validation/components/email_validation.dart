part of '../../validation.dart';

class EmailValidation extends StringValidation {
  const EmailValidation({this.emailChecker});

  final RegExp? emailChecker;

  @override
  ValidationResult validate({required String input}) {
    var emailCheck = emailChecker ?? ValidationRegex.email;

    if (input.isEmpty) {
      return const ValidationResult(message: ValidationStrings.improperEmail);
    }
    if (emailCheck.hasMatch(input)) {
      return const ValidationResult.proper();
    } else {
      return const ValidationResult(message: ValidationStrings.improperEmail);
    }
  }
}
