part of '../../validation.dart';

class AlwaysProperValidation extends StringValidation {
  const AlwaysProperValidation();

  @override
  ValidationResult validate({required String input}) {
    return const ValidationResult.proper();
  }
}
