part of 'validator.dart';

/// if [ValidatorErrorState] => none\
/// [errorString] => null
///
/// if [ValidatorErrorState] => incorrect\
/// [errorString] => null
///
/// if [ValidatorErrorState] => correct\
/// [errorString] => null
///
/// if [ValidatorErrorState] => error\
/// [errorString] => error
class ValidatorError {
  const ValidatorError({
    required this.errorState,
    required this.validationResult,
  });

  const ValidatorError.empty()
      : errorState = ValidatorErrorState.none,
        validationResult = const ValidationResult.empty();

  final ValidatorErrorState errorState;
  final ValidationResult validationResult;

  String? get errorString {
    return errorState == ValidatorErrorState.error
        ? validationResult.message
        : null;
  }

  bool get isCorrect => errorString == null;

  @override
  String toString() => '$errorState: $validationResult';
}

enum ValidatorErrorState {
  none,
  correct,
  incorrect,
  error;

  /// Is Properly Validated
  bool get isCorrect => this == ValidatorErrorState.correct;

  /// Has Validation Error
  bool get isIncorrect =>
      this == ValidatorErrorState.incorrect ||
      this == ValidatorErrorState.error;
}
