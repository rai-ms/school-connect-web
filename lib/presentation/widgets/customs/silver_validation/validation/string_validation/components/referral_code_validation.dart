import 'package:student_management/core/utils/app_regex.dart';
import 'package:student_management/presentation/widgets/customs/silver_validation/validation/validation.dart';

class ReferralCodeValidation extends StringValidation {
  const ReferralCodeValidation();

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return isEmptyResult;
    } else if (input.length != 8 ||
        !AppRegex.onlyAlphaNumeric.hasMatch(input)) {
      return isImproperResult;
    }

    return const ValidationResult.proper();
  }

  ValidationResult get isEmptyResult =>
      const ValidationResult(message: ValidationStrings.emptyField);

  ValidationResult get isImproperResult =>
      const ValidationResult(message: ValidationStrings.invalidReferralCode);
}
