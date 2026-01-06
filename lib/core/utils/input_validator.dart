

import 'package:flutter/services.dart';

class AppInputFormatter {

  AppInputFormatter._privateConstructor();

  static final AppInputFormatter _instance = AppInputFormatter._privateConstructor();

  static AppInputFormatter get instance => _instance;

  factory AppInputFormatter() {
    return _instance;
  }


  TextInputFormatter get baseInputFormatter =>
      TextInputFormatter.withFunction((oldValue, newValue) {
        final oldText = oldValue.text;
        final newText = newValue.text;

        // Allow empty input
        if (newText.isEmpty) return newValue;

        // Detect paste or selection replace
        final isPasting = (newText.length - oldText.length) > 1 ||
            oldValue.selection.baseOffset != oldValue.selection.extentOffset;

        String processedText = newText;

        // Track cursor offset
        int newOffset = newValue.selection.baseOffset;

        // Remove leading spaces on paste
        if (isPasting) {
          final trimmedText = processedText.replaceFirst(RegExp(r'^\s+'), '');
          if (trimmedText.length != processedText.length) {
            // Adjust offset based on how many leading spaces were removed
            final diff = processedText.length - trimmedText.length;
            newOffset = (newOffset - diff).clamp(0, trimmedText.length);
          }
          processedText = trimmedText;
        }

        // Prevent manual typing of leading space
        if (!isPasting && processedText.startsWith(' ')) {
          return oldValue;
        }

        // Everything else (multiple spaces, trailing spaces) is allowed
        return TextEditingValue(
          text: processedText,
          selection: TextSelection.collapsed(offset: newOffset),
        );
      });

}