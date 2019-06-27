import 'package:flutter/material.dart';

import '../charts_grid_widget.dart';

class TeachersPage extends StatelessWidget {
  final bloc;

  TeachersPage({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Charts')),
      ),
      body: ChartsGridWidget(
        bloc: bloc,
      ),
    );
  }
}
