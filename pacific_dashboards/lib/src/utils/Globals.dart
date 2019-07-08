import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globals extends InheritedWidget {
  String currentCountry = "Marshall Islands";

  static Globals of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(Globals);

  Future<String> getCurrentCountry() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    currentCountry = _sharedPreferences
        .getString("country" ?? "Federated States of Micronesia");
        print("CURRENT COUNTRY$currentCountry");
    return currentCountry;
  }

  setCurrentCountry(String country) async {
    currentCountry = country;
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.setString("country", country);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return null;
  }
}
