part of '../../validation.dart';

class CustomStringValidation extends StringValidation {
  const CustomStringValidation({required this.logic});

  final StringValidationLogic logic;

  @override
  ValidationResult validate({required String input}) => logic(input);
}
