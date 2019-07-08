import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/ui/splash_ui/SplashPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "../CategoryGridWidget.dart";
import 'package:pacific_dashboards/src/utils/Globals.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentCountry = SplashPage().currentCountry;
  @override
  Widget build(BuildContext context) {
    print("Current country $currentCountry");
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: new Container(
        decoration: BoxDecoration(color: Colors.white),
        // margin: const EdgeInsets.fromLTRB(47, 134, 47, 210),

        child: new ListView(children: <Widget>[
          Container(
            height: 80,
            alignment: Alignment.centerRight,
            child: _buildChooseCountry(context),
          ),
          Container(
              height: 160,
              width: 160,
              child: Image.asset("images/logos/$currentCountry.png")),
          Container(
            height: 96,
            width: 266,
            alignment: Alignment.center,
            child: Center(
                child: Text(
              currentCountry,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  fontFamily: "NotoSans"),
            )),
          ),
          Container(
              height: 500,
              width: 328,
              alignment: Alignment.center,
              child: CategoryGridWidget())
        ]),
      ),
    );
  }

  _buildChooseCountry(BuildContext context) {
    return FlatButton(
      color: Colors.white,
      textColor: Color.fromRGBO(26, 129, 204, 0.8),
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(8.0),
      splashColor: Colors.lightBlue,
      onPressed: () {
        _showDialog(context);
      },
      child: Text(
        "Change country",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 280,
          height: 244,
          child: Container(
            width: 280,
            height: 244,
            child: AlertDialog(
              title: Text(
                "Choice country",
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    fontFamily: "NotoSans"),
              ),
              content: Container(
                height: 200,
                width: 400,
                child: Column(children: <Widget>[
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        setState(() {
                         _setCurrentCountry ("Federated States of Micronesia", context);
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Image.asset(
                                  "images/logos/Federated States of Micronesia.png",
                                  width: 40,
                                  height: 40)),
                          Expanded(
                            child: Text("Federated States\n of Micronesia",
                                style: TextStyle(fontFamily: "NotoSans")),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      setState(() {
                        _setCurrentCountry ("Marshall Islands", context);
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset(
                            "images/logos/Marshall Islands.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Expanded(
                          child: Text("Marshall Islands",
                              style: TextStyle(fontFamily: "NotoSans")),
                        ),
                      ],
                    ),
                  ))
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  _setCurrentCountry(String country, BuildContext context) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.setString("country", country);
    setState(() {
      print("Country $country");
      currentCountry = country;
    });
     Navigator.of(context).pop();
  }

  init() async {
    print("HOME PAGE");

    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
   currentCountry = _sharedPreferences
        .getString("country" ?? "Federated States of Micronesia");
     }
}

  // void _setCurrentCountry(String country, BuildContext context) async {
  //   currentCountry = country;
  //   SharedPreferences _sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   await _sharedPreferences.setString("country", country);
  //    currentCountry = country;
  //   Navigator.of(context).pop();
  // }
// }5
