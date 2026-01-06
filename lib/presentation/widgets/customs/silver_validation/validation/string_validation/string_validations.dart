part of '../validation.dart';

class StringValidations {
  const StringValidations._internal();

  StringValidation email({RegExp? emailChecker}) => EmailValidation(emailChecker: emailChecker);
  PasswordValidation password({RegExp? passwordChecker}) => PasswordValidation(passwordChecker: passwordChecker);
  StringValidation custom(StringValidationLogic logic) => CustomStringValidation(logic: logic);

  StringValidation countryCode() => const CountryCodeValidation();
  StringValidation empty() => const EmptyValidation();
  StringValidation username() => const UsernameValidation();
  StringValidation referralCode() => const ReferralCodeValidation();
  StringValidation name() => const NameValidation();
  StringValidation searchText() => const SearchTextValidation();
  StringValidation description() => const DescriptionValidation();
  StringValidation percentage() => const PercentageValidation();
  StringValidation numeric() => const SingleNumericValidation();
  StringValidation decimal() => const DecimalValidation();
  StringValidation phone() => const PhoneValidation();
  StringValidation firstName() => const FirstNameValidator();
  StringValidation lastName() => const LastNameValidator();
  StringValidation alwaysProper() => const AlwaysProperValidation();
  StringValidation none() => const NoneValidation();
  StringValidation usPhone() => const USPhoneValidation();
  StringValidation nameWithCharacterRestriction() => const NameWithCharacterRestriction();
}
