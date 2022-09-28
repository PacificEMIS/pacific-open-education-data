import 'dart:io';

import 'package:arch/src/shared_ui/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showPlatformAlert(
  BuildContext context, {
  String title,
  String message,
  List<AlertPlatformAction> actions,
}) {
  final createdActions = actions ??
      [
        AlertPlatformAction(
          text: 'OK',
          isDefault: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ];
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: createdActions,
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: createdActions,
        );
      },
    );
  }
}

class AlertPlatformAction extends PlatformWidget {
  final String text;
  final bool isDefault;
  final VoidCallback onPressed;

  AlertPlatformAction({
    this.text,
    this.isDefault,
    @required this.onPressed,
  });

  @override
  Widget createAndroidWidget(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  @override
  Widget createIosWidget(BuildContext context) {
    return CupertinoDialogAction(
      isDefaultAction: isDefault,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
