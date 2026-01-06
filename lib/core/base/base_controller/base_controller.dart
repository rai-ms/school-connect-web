import 'package:flutter/material.dart';
import 'package:student_management/core/base/logger/app_logger_impl.dart';

/// A base controller mixin that provides common functionality for all controllers.
mixin BaseController<T extends StatefulWidget> on State<T> {
  /// Logger instance for logging messages
  final AppLoggerImpl log = AppLoggerImpl.I;

  /// A flag to check if the widget is still mounted
  bool get isMounted => mounted;

  @override
  void initState() {
    super.initState();
    log.d('${T.toString()} initialized');
  }

  @override
  void dispose() {
    log.d('${T.toString()} disposed');
    super.dispose();
  }

  /// Shows a snackbar with the given message
  void showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  /// Shows a loading dialog
  void showLoadingDialog() {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Hides the current dialog if any
  void hideLoadingDialog() {
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
