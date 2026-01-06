import 'package:flutter/material.dart';
import 'package:student_management/core/services/route_service/app_routing.dart'
    show RouteService;

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  ///common method for showing progress dialog
  static void showProgressDialog({
    BuildContext? context,
    bool isCancellable = false,
  }) async {
    if (!isProgressVisible &&
        RouteService.navigatorKey.currentState?.overlay?.context != null) {
      showDialog(
        barrierDismissible: isCancellable,
        context: RouteService.navigatorKey.currentState!.overlay!.context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        },
      );
      isProgressVisible = true;
    }
  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) {
      Navigator.pop(RouteService.navigatorKey.currentState!.overlay!.context);
    }
    isProgressVisible = false;
  }
}
