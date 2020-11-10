import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/strings.dart';

class ErrorListener extends MvvmErrorListener {
  @override
  void handleErrorMessage(BuildContext context, String errorMessage) {
    showPlatformAlert(
      context,
      title: 'errorTitle'.localized(context),
      message: errorMessage.localized(context),
    );
  }
}