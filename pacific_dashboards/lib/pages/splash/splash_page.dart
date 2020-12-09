import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/home/home_page.dart';
import 'package:pacific_dashboards/res/strings.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key key,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void startTimer() {
    Timer(const Duration(seconds: 3), _navigateToHome);
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed(HomePage.kRoute);
  }

  @override
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
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Image.asset(
                'images/splash/Splash.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
            ),
            Center(
              child: Text(
                'splash'.localized(context),
                textAlign: TextAlign.center,
                softWrap: true,
                style: Theme.of(context).textTheme.headline2,
              ),
            )
          ]),
        ),
        backgroundColor: Theme.of(context).primaryColor);
  }
}
