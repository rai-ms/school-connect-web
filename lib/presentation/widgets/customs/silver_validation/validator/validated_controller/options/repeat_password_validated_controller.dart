part of '../../validator.dart';

class RepeatPasswordStepValidatedController = RepeatPasswordValidatedController
    with StepValidator<PasswordValidation>;

class RepeatPasswordStepFocusValidatedController = RepeatPasswordStepValidatedController
    with FocusStepValidateMode<PasswordValidation>;

class RepeatPasswordValidatedController
    extends ValidatedController<PasswordValidation> {
  RepeatPasswordValidatedController({
    required this.mainPasswordController,
    super.initialText,
    super.autoValidateMode,
  }) : super(validation: mainPasswordController.validation);

  final ValidatedController<PasswordValidation> mainPasswordController;

  @override
  ValidatorError validate([ValidationStatus? status]) {
    var mainError = mainPasswordController.validate();

    if (!mainError.errorState.isCorrect) {
      ValidatorError error;

      error = const ValidatorError(
        errorState: ValidatorErrorState.incorrect,
        validationResult: ValidationResult.empty(),
      );

      _errorSink.add(error);
      return error;
    }

    var mainPassword = mainPasswordController.text;

    return validateRepeatPassword(mainPassword, status);
  }

  ValidatorError validateRepeatPassword(
    String mainPassword, [
    ValidationStatus? status,
  ]) {
    var result = validation.repeatValidate(
      input: text,
      mainPassword: mainPassword,
    );

    var error = _transform(
      result,
      status ?? _currentValidationStatus,
    );
    _errorSink.add(error);
    return error;
  }
}
