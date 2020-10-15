import 'package:flutter/material.dart';

class TileWidget extends StatelessWidget {
  final Widget title;
  final Widget body;

  const TileWidget({this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        title,
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: body,
        ),
      ],
    );
  }
}
