import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/PlatformWidget.dart';

class PlatformAppBar extends PlatformWidget<CupertinoNavigationBar, AppBar> {
  final Widget leading;
  final Widget title;
  final IconThemeData iconTheme;
  final Color backgroundColor;
  List<Widget> actions;

  PlatformAppBar({
    this.leading,
    this.title,
    this.iconTheme,
    this.backgroundColor,
    this.actions,
  });

  @override
  AppBar createAndroidWidget(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title,
      iconTheme: iconTheme,
      backgroundColor: backgroundColor,
      actions: actions,
    );
  }

  @override
  CupertinoNavigationBar createIosWidget(BuildContext context) {
    return CupertinoNavigationBar(
      leading: leading,
      middle: title,
      backgroundColor: backgroundColor,
    );
  }
}
