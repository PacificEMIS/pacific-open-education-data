import 'package:flutter/material.dart';
import '../config/Constants.dart';
import '../resources/Filter.dart';
import './FilterWidget.dart';

class TitleWidget extends StatelessWidget {
  final String _titleName;
  final Color _textColor;
  final Color _filterIconColor = AppColors.kTuna;

  bool _hasFiler = false;
  Filter _filter;

  TitleWidget(this._titleName, this._textColor);

  TitleWidget.withFilter(this._titleName, this._textColor , Filter filter) {
    _filter = filter;
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
        onTap: () => {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FilterWidget(data : _filter)),
        )},
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }
}
