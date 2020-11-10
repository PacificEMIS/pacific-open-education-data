import 'dart:async';

import 'package:arch/arch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pacific_dashboards/app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pacific_dashboards/service_locator.dart';
import 'package:pacific_dashboards/shared_ui/error_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));

  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await serviceLocator.prepare();

  defaultErrorListener = ErrorListener();

  runApp(App());
}
