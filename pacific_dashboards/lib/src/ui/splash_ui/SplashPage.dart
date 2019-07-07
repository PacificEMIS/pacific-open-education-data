import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/ui/home_ui/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pacific_dashboards/src/utils/Globals.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  startTime() async {
    var _duration = Duration(seconds: 3);
    var _country = Globals().getCurrentCountry();

    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Home');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    var currentCountry = Globals().currentCountry;
    
    return Scaffold(
      body: Center(
        child: Image.asset("images/logos/$currentCountry.png"),
      ),
    );
  }
}