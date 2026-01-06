part of '../../validator.dart';

class StepValidatedController<T extends StringValidation> = ValidatedController<
    T> with StepValidator<T>;

class StepFocusValidatedController<
        T extends StringValidation> = StepValidatedController<T>
    with FocusStepValidateMode<T>;

class StepFocusedValidatedController<
        T extends StringValidation> = StepFocusValidatedController<T>
    with FocusAutoValidateMode<T>;

mixin StepValidator<T extends StringValidation> on ValidatedController<T> {
  @override
  ValidationStatus get _currentValidationStatus => _status;
  late ValidationStatus _status = autoValidateMode;

  @override
  void _autoValidator() {
    if (autoValidateMode.isEnabled) {
      validate(_status);
    }
  }

  @override
  ValidatorError _transformError(
    ValidationResult error,
    ValidationStatus status,
  ) =>
      status.transformError(error);

  @override
  ValidatorError _transform(ValidationResult error, ValidationStatus status) {
    _status = status;
    if (error.isProper && _status.isEnabled) {
      _status = const PassiveValidation();
    }
    return super._transform(error, status);
  }
}
