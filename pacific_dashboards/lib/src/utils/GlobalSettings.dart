import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings {
  String currentCountry = "Marshall Islands";
  final SharedPreferences sharedPreferences;

  GlobalSettings({ this.sharedPreferences });

  Future<String> getCurrentCountry() async {
    currentCountry = sharedPreferences
        .getString("country" ?? "Federated States of Micronesia");
        print("CURRENT COUNTRY$currentCountry");
    return currentCountry;
  }

  setCurrentCountry(String country) async {
    currentCountry = country;
    await sharedPreferences.setString("country", country);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return null;
  }
}
