import 'package:student_management/presentation/widgets/customs/silver_validation/validation/validation.dart';

class NameWithCharacterRestriction extends StringValidation {
  const NameWithCharacterRestriction();

  @override
  ValidationResult validate({required String input}) {
    if (input.trim().isEmpty) {
      return isEmptyResult;
    }
    if (input.isEmpty || input.length > 50) {
      return isImproperResult;
    }

    return const ValidationResult.proper();
  }

  ValidationResult get isEmptyResult =>
      const ValidationResult(message: ValidationStrings.emptyField);

  ValidationResult get isImproperResult =>
      const ValidationResult(message: ValidationStrings.improperName);
}
