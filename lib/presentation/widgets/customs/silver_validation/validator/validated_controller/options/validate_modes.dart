part of '../../validator.dart';

mixin FocusValidateMode<T extends StringValidation> on ValidatedController<T> {
  @override
  void _autoValidate() {
    focusNode.addListener(_autoValidator);
  }

  @override
  void _autoValidator() {
    if (autoValidateMode.isEnabled) {
      validate(autoValidateMode);
    }
  }
}

mixin FocusAutoValidateMode<T extends StringValidation>
    on FocusStepValidateMode<T> {
  @override
  void _autoValidator() {
    if (text.isNotEmpty) {
      if (focusNode.hasFocus) {
        _status = const PassiveValidation();
      } else {
        _status = const ActiveValidation();
      }
    }
    validate(_status);
  }
}

mixin FocusStepValidateMode<T extends StringValidation> on StepValidator<T> {
  @override
  void _autoValidate() {
    focusNode.addListener(_autoValidator);
  }

  @override
  void _autoValidator() {
    if (focusNode.hasFocus) {
      // _status = const PassiveValidation()
    }
    validate(_status);
  }
}
