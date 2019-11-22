import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/shared_ui/platform_widget.dart';

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