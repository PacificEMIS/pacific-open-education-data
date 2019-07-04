import 'package:flutter/material.dart';
import '../config/Constants.dart';

class TitleWidget extends StatelessWidget {
  final String _titleName;
  final Color _textColor;
  final Color _filterIconColor = AppColors.kTuna;

  bool _hasFiler = false;
  Future<Object> _func;

  TitleWidget(this._titleName, this._textColor);

  TitleWidget.withFilter(this._titleName, this._textColor /*, Future<Object> func*/) {
    //_func = func;
    _hasFiler = true;
  }

  @override
  Widget build(BuildContext context) {
    var widgets = new List<Widget>();
    widgets.add(Text(
      _titleName,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        fontFamily: "Noto Sans",
        letterSpacing: 0.25,
        fontStyle: FontStyle.normal,
        color: _textColor,
      ),
    ));

    if (_hasFiler) {
      widgets.add(InkResponse(
        child: Icon(
          Icons.tune,
          color: _filterIconColor,
        ),
        onTap: () => {},
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }
}
