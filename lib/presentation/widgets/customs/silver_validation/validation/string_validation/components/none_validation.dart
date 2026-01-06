part of '../../validation.dart';

class NoneValidation extends StringValidation {
  const NoneValidation();

  @override
  ValidationResult validate({required String input}) {
    return const ValidationResult.empty();
  }
}
