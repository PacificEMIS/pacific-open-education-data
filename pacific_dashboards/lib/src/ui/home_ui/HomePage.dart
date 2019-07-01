import 'package:flutter/material.dart';
import "../CategoryGridWidget.dart";

class HomePage extends StatelessWidget {
  final bloc;

  HomePage({this.bloc});

  _choiceCountry(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: new Container(
        decoration: BoxDecoration(color: Colors.white),
        // margin: const EdgeInsets.fromLTRB(47, 134, 47, 210),

        child: new ListView(children: <Widget>[
          Container(
            height: 80,
            alignment: Alignment.centerRight,
            child: _choiceCountry(context),
          ),
          Container(
              height: 160,
              width: 160,
              child: Image.asset("images/logos/mainlogo.png")),
          Container(
            height: 96,
            width: 266,
            alignment: Alignment.center,
            child: Center(
                child: Text(
              'FEDERATED STATES\nof Micronesia',
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
                        print('Card tapped.');
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Image.asset(
                            "images/logos/mainlogo.png",
                            width: 40,
                            height: 40,
                          )),
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
                      print('Card tapped.');
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset(
                            "images/logos/marshalllogo.png",
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
}
