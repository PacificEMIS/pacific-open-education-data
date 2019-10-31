import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pacific_dashboards/App.dart';
import 'package:pacific_dashboards/ui/InjectorWidget.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: Colors.white10,
  ));

  var injector = InjectorWidget(child: App());
  await injector.init();

  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  
  runApp(injector);
}
