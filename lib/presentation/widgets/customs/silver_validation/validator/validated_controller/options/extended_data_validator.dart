part of '../../validator.dart';

class ExtendedValidatedController<S extends StringValidation, T>
    extends ValidatedController<S> with ExtendedDataValidator<S, T> {
  ExtendedValidatedController({
    required super.validation,
    super.autoValidateMode,
    super.initialText,
    super.focus,
    T? initialExtendedData,
  }) {
    _extendedData = initialExtendedData;
  }
}

class ExtendedStepValidatedController<S extends StringValidation, T>
    extends ValidatedController<S>
    with StepValidator<S>, ExtendedDataValidator<S, T> {
  ExtendedStepValidatedController({
    required super.validation,
    super.autoValidateMode,
    super.focus,
    super.initialText,
    T? initialExtendedData,
  }) {
    _extendedData = initialExtendedData;
  }
}

mixin ExtendedDataValidator<S extends StringValidation, T>
    on ValidatedController<S> {
  T? _extendedData;
  T? get extendedData => _extendedData;
  set extendedData(T? value) {
    _extendedData = value;
    controller.text = controller.text;
  }
}
