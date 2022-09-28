import 'package:arch/src/actions/alerts.dart';
import 'package:flutter/material.dart';

MvvmErrorListener defaultErrorListener = MvvmErrorListener();

class MvvmErrorListener {
  void handleErrorMessage(BuildContext context, String errorMessage) {
    showPlatformAlert(
      context,
      title: 'Error',
      message: errorMessage,
      actions: [
        AlertPlatformAction(
          text: 'OK',
          isDefault: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
