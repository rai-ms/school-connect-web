part of '../validator.dart';

sealed class ValidationStatus {
  const ValidationStatus();

  bool get isDisabled => this is NoValidation;
  bool get isEnabled => this is! NoValidation;

  bool get isInactive => this is InactiveValidation;
  bool get isPassive => this is PassiveValidation;
  bool get isActive => this is ActiveValidation;

  ValidatorError transformError(ValidationResult result);
}

class NoValidation extends ValidationStatus {
  const NoValidation();

  @override
  ValidatorError transformError(ValidationResult result) =>
      const ValidatorError.empty();
}

class InactiveValidation extends ValidationStatus {
  const InactiveValidation();

  @override
  ValidatorError transformError(ValidationResult result) {
    return ValidatorError(
      errorState: ValidatorErrorState.none,
      validationResult: result,
    );
  }
}

class PassiveValidation extends ValidationStatus {
  const PassiveValidation();

  @override
  ValidatorError transformError(ValidationResult result) {
    return ValidatorError(
      errorState: ValidatorErrorState.incorrect,
      validationResult: result,
    );
  }
}

class ActiveValidation extends ValidationStatus {
  const ActiveValidation();

  @override
  ValidatorError transformError(ValidationResult result) {
    return ValidatorError(
      errorState: ValidatorErrorState.error,
      validationResult: result,
    );
  }
}
