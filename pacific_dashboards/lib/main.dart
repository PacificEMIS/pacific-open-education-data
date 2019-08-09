import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import 'src/App.dart';
import 'src/ui/InjectorWidget.dart';
import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, 
    statusBarColor: Colors.white10, 
  ));
  var appSecret = Platform.isAndroid
      ? "3c6d3883-667f-434e-861a-1e168197aefb"
      : "a1e06c9c-d224-4549-9e3c-26564d781a52";
  await AppCenter.start(appSecret,
      [AppCenterAnalytics.id, AppCenterCrashes.id]);
  var injector = InjectorWidget(child : App());
  await injector.init();
  runApp(injector);
}