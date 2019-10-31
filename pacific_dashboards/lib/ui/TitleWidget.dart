import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String _titleName;
  final Color _textColor;

  TitleWidget(this._titleName, this._textColor);

  @override
  Widget build(BuildContext context) {
    var widgets = List<Widget>();
    widgets.add(
      Text(
        _titleName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          fontFamily: "Noto Sans",
          letterSpacing: 0.25,
          fontStyle: FontStyle.normal,
          color: _textColor,
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }
}
