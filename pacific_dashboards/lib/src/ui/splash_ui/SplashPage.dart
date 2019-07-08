import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pacific_dashboards/src/utils/Globals.dart';

String _currentCountry = "Marshall Islands";

class SplashPage extends StatefulWidget {
  String get currentCountry => _currentCountry;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _kDefaultCountry = "Federated States of Micronesia";
  
  startTime() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    setState(() {
      _currentCountry = _sharedPreferences
          .getString("country" ?? _kDefaultCountry);
    });

    Globals().currentCountry = _currentCountry;
    var _duration = Duration(seconds: 3);

    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Home');
  }

  void initState() {
    super.initState();
    startTime(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("images/logos/$_currentCountry.png"),
      ),
    );
  }
}
