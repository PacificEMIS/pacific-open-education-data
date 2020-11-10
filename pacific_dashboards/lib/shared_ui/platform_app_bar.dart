import 'package:arch/arch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAppBar extends PlatformWidget<AppBar, AppBar>
    implements PreferredSizeWidget {
  PlatformAppBar({
    this.leading,
    this.title,
    this.iconTheme,
    this.backgroundColor,
    this.actions,
  });

  final Widget leading;
  final Widget title;
  final IconThemeData iconTheme;
  final Color backgroundColor;
  final List<Widget> actions;

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  AppBar createAndroidWidget(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title,
      iconTheme: iconTheme,
      backgroundColor: backgroundColor,
      brightness: Brightness.dark,
      actions: actions,
    );
  }

  @override
  AppBar createIosWidget(BuildContext context) {
    /// ignore Cupertino style
    return createAndroidWidget(context);
  }
}
