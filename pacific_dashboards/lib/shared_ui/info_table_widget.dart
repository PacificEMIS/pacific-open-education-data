import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';

typedef int KeySortFunc(String lv, String rv);

class InfoTableData {
  static const String _kZeroSymbol = "-";

  final int _maleAmount;
  final int _femaleAmount;

  String get maleAmount =>
      _maleAmount != 0 ? _maleAmount.toString() : _kZeroSymbol;

  String get femaleAmount =>
      _femaleAmount != 0 ? _femaleAmount.toString() : _kZeroSymbol;

  String get total => (_maleAmount + _femaleAmount) != 0
      ? (_maleAmount + _femaleAmount).toString()
      : _kZeroSymbol;

  InfoTableData(this._maleAmount, this._femaleAmount);
}

class InfoTableWidget extends StatefulWidget {
  InfoTableWidget({
    Key key,
    @required Map<String, InfoTableData> data,
    @required String title,
    @required String firstColumnName,
    KeySortFunc keySortFunc,
  })  : assert(data != null),
        assert(firstColumnName != null),
        _data = data,
        _title = title,
        _firstColumnName = firstColumnName,
        _keySortFunc = keySortFunc,
        super(key: key);

  static const double _kBorderWidth = 1.0;

  final Map<String, InfoTableData> _data;
  final KeySortFunc _keySortFunc;

  final String _title;
  final String _firstColumnName;

  final Color _borderColor = AppColors.kGeyser;
  final Color _textColor = AppColors.kTimberGreen;
  final Color _subTitleTextColor = AppColors.kNevada;
  final Color _evenRowColor = AppColors.kWhite;
  final Color _oddRowColor = AppColors.kAthensGray;
  final Color _titleTextColor = AppColors.kEndeavour;

  @override
  State<InfoTableWidget> createState() => _InfoTableWidgetState();
}

class _InfoTableWidgetState extends State<InfoTableWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Table(
        border:
            _getTableBorder(widget._borderColor, InfoTableWidget._kBorderWidth),
        children: [
          _generateTableTitle(
              widget._borderColor, InfoTableWidget._kBorderWidth)
        ],
      ),
      Table(
        border:
            _getTableBorder(widget._borderColor, InfoTableWidget._kBorderWidth),
        children: _generateTableBody(
            widget._data,
            _generateSubTableTitle(
                widget._borderColor, InfoTableWidget._kBorderWidth)),
      ),
    ]);
  }

  TableRow _generateTableTitle(Color borderColor, double borderWidth) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
          bottom: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
          left: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
          right: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
        ),
      ),
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              children: <Widget>[
                Text(
                  widget._title ?? 'null',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: widget._titleTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TableRow _generateSubTableTitle(Color borderColor, double borderWidth) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
          bottom: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
          left: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
          right: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
        ),
      ),
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              children: <Widget>[
                Text(
                  widget._firstColumnName,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: widget._subTitleTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Male",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: widget._subTitleTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Female",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: widget._subTitleTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: widget._subTitleTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TableBorder _getTableBorder(Color borderColor, double borderWidth) {
    return TableBorder(
      top: BorderSide(
        width: borderWidth,
        color: borderColor,
      ),
      right: BorderSide(
        width: borderWidth,
        color: borderColor,
      ),
      left: BorderSide(
        width: borderWidth,
        color: borderColor,
      ),
      bottom: BorderSide(
        width: borderWidth,
        color: borderColor,
      ),
    );
  }

  List<TableRow> _generateTableBody(
      Map<String, InfoTableData> data, TableRow subTitle) {
    final rows = List<TableRow>();
    rows.add(subTitle);

    final keys = data.keys.toList();
    if (widget._keySortFunc != null) {
      keys.sort(widget._keySortFunc);
    }

    for (var i = 0; i < keys.length; i++) {
      final key = keys[i];
      rows.add(_generateTableRow(key, data[key], i));
    }

    return rows;
  }

  TableRow _generateTableRow(String domain, InfoTableData measure, int index) {
    return TableRow(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? widget._evenRowColor : widget._oddRowColor,
      ),
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              children: <Widget>[
                Text(
                  domain,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: widget._textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  measure.maleAmount.toString(),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: widget._textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  measure.femaleAmount.toString(),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: widget._textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  measure.total.toString(),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: widget._textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
