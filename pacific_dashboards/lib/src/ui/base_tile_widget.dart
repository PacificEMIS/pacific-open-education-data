import 'package:flutter/material.dart';

class BaseTileWidget extends StatelessWidget {
  final Widget title;
  final Widget body;

  BaseTileWidget(this.title, this.body);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        title,
        body,
      ],
    );
  }
}