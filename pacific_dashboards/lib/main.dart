import 'dart:async';

import 'package:arch/arch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pacific_dashboards/app.dart';
import 'package:pacific_dashboards/service_locator.dart';
import 'package:pacific_dashboards/shared_ui/error_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  await serviceLocator.prepare();

  defaultErrorListener = ErrorListener();

  final prefs = await SharedPreferences.getInstance();
  final hideOnboarding = prefs.getBool('hideOnboarding') ?? false;
  runApp(App(hideOnboarding: hideOnboarding));
}
