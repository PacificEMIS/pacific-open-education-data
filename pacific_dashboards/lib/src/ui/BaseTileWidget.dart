import 'package:flutter/material.dart';

class BaseTileWidget extends StatelessWidget {
  final Widget title;
  final Widget body;

  BaseTileWidget({this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        title,
        body,
      ],
    );
  }
}
