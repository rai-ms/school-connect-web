part of '../validator.dart';

abstract class BaseValidator<T extends Validation> {
  BaseValidator({required this.validation}) {
    _init();
  }

  // Initial State
  //----------------------------------------------------------------------------
  final T validation;
  //----------------------------------------------------------------------------

  // Validation Stream Section
  //----------------------------------------------------------------------------
  final StateStreamController<ValidatorError> _errorController = StateStreamController(initialValue: const ValidatorError.empty());
  Stream<ValidatorError> get errorDataStream => _errorController.stream;
  Sink<ValidatorError> get _errorSink => _errorController.sink;

  ValidatorError get error => _errorController.value;
  //----------------------------------------------------------------------------

  // Validation Init Section
  //----------------------------------------------------------------------------
  void _init() {}
  //----------------------------------------------------------------------------

  // Validation Processing Section
  //----------------------------------------------------------------------------
  ValidatorError validate();
  //----------------------------------------------------------------------------

  void dispose() {
    _errorController.close();
  }
}
