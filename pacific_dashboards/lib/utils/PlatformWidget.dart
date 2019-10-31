import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatformWidget<I extends Widget, A extends Widget>
    extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return createAndroidWidget(context);
    } else if (Platform.isIOS) {
      return createAndroidWidget(context);
    }
    // platform not supported returns an empty widget
    return Container();
  }

  I createIosWidget(BuildContext context);

  A createAndroidWidget(BuildContext context);
}
