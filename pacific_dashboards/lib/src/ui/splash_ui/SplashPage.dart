import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/config/Constants.dart';
import 'package:pacific_dashboards/src/utils/GlobalSettings.dart';
import 'package:pacific_dashboards/src/utils/Localizations.dart';

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
    Timer(Duration(seconds: 3), _navigateToHome);
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
        body: Center(
          child: Stack(children: <Widget>[
            Container(
              decoration: new BoxDecoration(color: AppColors.kAppBarBackground),
              child: Image.asset(
                "images/splash/Splash.png",
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
            ),
            Center(
              child: Text(
                AppLocalizations.splash,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontFamily: "NotoSans",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ]),
        ),
        backgroundColor: AppColors.kAppBarBackground);
  }
}
