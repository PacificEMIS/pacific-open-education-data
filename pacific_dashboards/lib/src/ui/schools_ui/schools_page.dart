import 'package:flutter/material.dart';

class SchoolsPage extends StatelessWidget {
  final bloc;

  SchoolsPage({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Charts')),
      ),
      body: Text('SchoolsPage'),
    );
  }
}
