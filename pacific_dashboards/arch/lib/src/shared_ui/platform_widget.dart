import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatformWidget<I extends Widget, A extends Widget>
    extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return createAndroidWidget(context);
    } else if (Platform.isIOS) {
      return createIosWidget(context);
    }
    // platform not supported returns an empty widget
    return Container();
  }

  I createIosWidget(BuildContext context);

  A createAndroidWidget(BuildContext context);
}
