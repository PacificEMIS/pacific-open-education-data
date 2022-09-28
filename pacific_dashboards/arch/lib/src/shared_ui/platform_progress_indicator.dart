import 'package:arch/src/shared_ui/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformProgressIndicator extends PlatformWidget {

  @override
  Widget createAndroidWidget(BuildContext context) {
    return CircularProgressIndicator();
  }

  @override
  Widget createIosWidget(BuildContext context) {
    return CupertinoActivityIndicator();
  }

}