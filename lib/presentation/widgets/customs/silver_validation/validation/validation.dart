
import 'package:student_management/core/utils/app_regex.dart';
import 'package:student_management/presentation/widgets/customs/silver_validation/validation/string_validation/components/name_with_special_symbol.dart';
import 'package:student_management/presentation/widgets/customs/silver_validation/validation/string_validation/components/referral_code_validation.dart';
import 'package:student_management/core/utils/app_regex.dart' show AppRegex;
import 'package:student_management/presentation/widgets/customs/silver_validation/validation/string_validation/components/name_with_special_symbol.dart'
    show NameWithCharacterRestriction;
import 'package:student_management/presentation/widgets/customs/silver_validation/validation/string_validation/components/referral_code_validation.dart'
    show ReferralCodeValidation;

part 'validation_result/validation_result.dart';
part 'validation_utils/validation_strings.dart';
part 'validation_utils/validation_regex.dart';

part 'custom_validation/custom_validation.dart';

part 'string_validation/string_validation.dart';
part 'string_validation/string_validations.dart';

part 'string_validation/components/country_code_validation.dart';
part 'string_validation/components/decimal_validation.dart';
part 'string_validation/components/email_validation.dart';
part 'string_validation/components/name_validation.dart';
part 'string_validation/components/password_validation.dart';
part 'string_validation/components/percentage_validation.dart';
part 'string_validation/components/single_numeric_validation.dart';
part 'string_validation/components/search_text_validation.dart';
part 'string_validation/components/phone_validation.dart';
part 'string_validation/components/custom_validation.dart';
part 'string_validation/components/always_proper_validation.dart';
part 'string_validation/components/none_validation.dart';
part 'string_validation/components/us_phone_validation.dart';
part 'string_validation/components/username_validation.dart';
part 'string_validation/components/empty_validation.dart';

abstract class Validation {
  const Validation();

  static StringValidations get string => const StringValidations._internal();
  static CustomValidation custom(ValidationLogic logic) =>
      CustomValidation(logic: logic);
}
