part of '../validator.dart';

class CustomValidator<T> extends BaseValidator<CustomValidation<T>> {
  CustomValidator({
    required super.validation,
    required this.getState,
  });

  //----------------------------------------------------------------------------
  final T Function() getState;
  //----------------------------------------------------------------------------

  // Validation Processing Section
  //----------------------------------------------------------------------------
  @override
  ValidatorError validate() {
    var result = validation.validate(getState());
    var error = ValidatorError(
      errorState: result.isProper
          ? ValidatorErrorState.correct
          : ValidatorErrorState.error,
      validationResult: result,
    );

    _errorSink.add(error);
    return error;
  }
  //----------------------------------------------------------------------------
}
