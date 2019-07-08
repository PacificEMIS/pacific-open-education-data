import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globals extends InheritedWidget {
  String currentCountry = "Marshall Islands";
  SharedPreferences sharedPreferences;

  static Globals of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(Globals);

  Future<String> getCurrentCountry() async { sharedPreferences =
        await SharedPreferences.getInstance();
    currentCountry = sharedPreferences
        .getString("country" ?? "Federated States of Micronesia");
        print("CURRENT COUNTRY$currentCountry");
    return currentCountry;
  }

  setCurrentCountry(String country) async {
    currentCountry = country;
    sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString("country", country);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return null;
  }
}
