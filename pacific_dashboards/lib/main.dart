import 'dart:async';

import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pacific_dashboards/app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pacific_dashboards/service_locator.dart';
import 'package:pacific_dashboards/shared_ui/error_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));

  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  await serviceLocator.prepare();

  defaultErrorListener = ErrorListener();

  runApp(App());
}
