part of '../validation.dart';

class ValidationRegex {
  static final RegExp numberOnlyFilter = RegExp(r'[\d]');
  static final RegExp decimalFilter = RegExp(r'[\d.]');
  static final RegExp alphabetOnlyFilter = RegExp(r'[a-zA-Z]');
  static final RegExp alphabetSpaceFilter = RegExp(r'[a-zA-Z ]');
  static final RegExp sentenceFilter = RegExp(r'[a-zA-Z .]');
  static final RegExp dateOnlyFilter = RegExp(r'[\d\/]');
  static final RegExp alphaNumericWithSomeSpecialSymbol = RegExp(r"[a-zA-Z0-9\u0020\u005F\u0027\u002D\u002E]");

  // Inverse
  static final RegExp inverseNumberOnlyFilter = RegExp(r'[^\d]');
  static final RegExp inverseDecimalFilter = RegExp(r'[^\d.]');
  static final RegExp inverseAlphabetOnlyFilter = RegExp(r'[^a-zA-Z]');
  static final RegExp inverseAlphabetSpaceFilter = RegExp(r'[^a-zA-Z ]');
  static final RegExp inverseSentenceFilter = RegExp(r'[^a-zA-Z .]');
  static final RegExp inverseDateOnlyFilter = RegExp(r'[^\d\/]');
  static final RegExp usPhoneFilter = RegExp(r'^(\([0-9]{3}\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$');

  // Whole Matches Only
  static final RegExp email = RegExp(r'''^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');
  static final RegExp password = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  static RegExp passwordWithSpecialChar = RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
}
