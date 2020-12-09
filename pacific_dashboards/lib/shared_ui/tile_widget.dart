import 'package:flutter/material.dart';

class TileWidget extends StatelessWidget {
  const TileWidget({
    Key key,
    this.title,
    this.body,
  }) : super(key: key);

  final Widget title;
  final Widget body;

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
