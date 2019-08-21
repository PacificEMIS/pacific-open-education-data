import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/config/Constants.dart';
import 'package:pacific_dashboards/src/utils/GlobalSettings.dart';

class SplashPage extends StatefulWidget {
  final GlobalSettings globalSettings;

  @override
  _SplashPageState createState() => _SplashPageState();

  SplashPage({
    Key key,
    this.globalSettings,
  }) : super(key: key);
}

class _SplashPageState extends State<SplashPage> {
  startTimer() async {
    Timer(Duration(seconds: 5), _navigateToHome);
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed("/Home");
  }

  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(color: Colors.red),
        child:
            Image.asset("images/splash/splash.png", fit: BoxFit.fitHeight),
      ),
      backgroundColor: AppColors.kAppBarBackground,
    );
  }
}