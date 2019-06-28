import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final bloc;

  HomePage({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Charts')),
      ),
      body: Text(
        "bloc: bloc"
      ),
    );
  }
}