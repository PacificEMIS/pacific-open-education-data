import 'package:flutter/material.dart';

import 'ui/home_ui/home_page.dart';
import 'ui/injector_widget.dart';
import 'ui/teaches_ui/teachers_page.dart';

class App extends StatelessWidget {
  final _appName = 'Custom Charts';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appName,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.deepOrangeAccent[100],
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      initialRoute: "/teachers",
      routes: {
        "/": (context) => HomePage(
            bloc:
                InjectorWidget.of(context).getTeachersBloc(forceCreate: true)),
        "/teachers": (context) => TeachersPage(
            bloc:
                InjectorWidget.of(context).getTeachersBloc(forceCreate: true)),
        "/schools": (context) => Text("Schools"),
      },
    );
  }
}
