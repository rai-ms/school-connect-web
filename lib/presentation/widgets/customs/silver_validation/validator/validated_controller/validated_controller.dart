part of '../validator.dart';

class FocusValidatedController<T extends StringValidation> = ValidatedController<T> with FocusValidateMode<T>;

/// Wrapper class for [TextEditingController]\
/// with internal validation logic
///
/// Use [errorDataStream] to read errors
class ValidatedController<T extends StringValidation> extends BaseValidator<T> {
  ValidatedController({
    required super.validation,
    String? initialText,
    FocusNode? focus,
    this.autoValidateMode = const InactiveValidation(),
  })  : controller = TextEditingController(text: initialText),
        focusNode = focus ?? FocusNode();

  // Initial State
  //----------------------------------------------------------------------------
  final TextEditingController controller;
  String get text => controller.text;
  set text(String text) => controller.text = text;

  final FocusNode focusNode;

  final ValidationStatus autoValidateMode;
  ValidationStatus get _currentValidationStatus => autoValidateMode;
  //----------------------------------------------------------------------------

  // Validation Init Section
  //----------------------------------------------------------------------------
  @override
  void _init() {
    _autoValidate();
  }

  void _autoValidate() {
    controller.addListener(_autoValidator);
  }

  void _autoValidator() {
    if (autoValidateMode.isEnabled) {
      validate(autoValidateMode);
    }
  }

  //----------------------------------------------------------------------------

  // Validation Processing Section
  //----------------------------------------------------------------------------
  @override
  ValidatorError validate([ValidationStatus? status]) {
    var result = validation.validate(input: text);
    var error = _transform(result, status ?? _currentValidationStatus);

    _errorSink.add(error);
    return error;
  }

  ValidatorError _transform(
    ValidationResult error,
    ValidationStatus status,
  ) {
    if (error.isProper) {
      return ValidatorError(
        errorState: ValidatorErrorState.correct,
        validationResult: error,
      );
    } else if (error.message!.isEmpty) {
      return const ValidatorError.empty();
    } else {
      return _transformError(error, status);
    }
  }

  ValidatorError _transformError(
    ValidationResult error,
    ValidationStatus status,
  ) =>
      const ActiveValidation().transformError(error);
  //----------------------------------------------------------------------------

  @override
  void dispose() {
    controller.dispose();
    try {
      focusNode.dispose();
    } catch (e) {
      Log.e('Exception:: $e');
    }
    super.dispose();
  }
}
