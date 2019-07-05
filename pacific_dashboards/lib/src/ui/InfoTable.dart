import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/config/Constants.dart';

class _Data {
  static const String _kZeroSymbol = "-";

  final int _maleAmount;
  final int _femaleAmount;

  String get maleAmount => _maleAmount != 0 ? _maleAmount.toString() : _kZeroSymbol;
  String get femaleAmount => _femaleAmount != 0 ? _femaleAmount.toString() : _kZeroSymbol;
  String get total => (_maleAmount + _femaleAmount) != 0 ? (_maleAmount + _femaleAmount).toString() : _kZeroSymbol;

  _Data(this._maleAmount, this._femaleAmount);
}

class InfoTable<T> extends StatefulWidget {
  static const double _kBorderWidth = 1.0;

  final Map<dynamic, List<T>> _data;

  final String _keyName;
  bool _isSubTable;

  Color _borderColor = AppColors.kGeyser;
  Color _textColor = AppColors.kTimberGreen;
  Color _subTitleTextColor = AppColors.kNevada;
  Color _evenRowColor = AppColors.kWhite;
  Color _oddRowColor = AppColors.kAthensGray;
  Color _titleTextColor = AppColors.kEndeavour;

  InfoTable(this._data, this._keyName) {
    this._isSubTable = false;
  }

  InfoTable.subTable(this._data, this._keyName) {
    this._isSubTable = true;
  }

  @override
  State<InfoTable<T>> createState() => _InfoTableState<T>();
}

class _InfoTableState<T> extends State<InfoTable<T>> {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: _getTableBorder(widget._borderColor, InfoTable._kBorderWidth),
      children: _generateTableBody(widget._data, _generateTableTitle(widget._borderColor, InfoTable._kBorderWidth),
          _generateSubTableTitle(widget._borderColor, InfoTable._kBorderWidth)),
    );
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              children: <Widget>[
                Text(
                  widget._keyName,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: widget._titleTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "",
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "",
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "",
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              children: <Widget>[
                Text(
                  "School \nType",
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
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

  List<TableRow> _generateTableBody(Map<dynamic, List<T>> data, TableRow title, TableRow subTitle) {
    var rowsList = List<TableRow>();
    var dataMap = Map<String, _Data>();

    var totalMaleCount = 0;
    var totalFemaleCount = 0;
    data.forEach((k, v) {
      var maleCount = 0;
      var femaleCount = 0;
      for (var j = 0; j < v.length; ++j) {
        dynamic model = v;
        if ((!widget._isSubTable) || ((widget._isSubTable) && (widget._keyName == model[j].districtCode))) {
          maleCount += model[j].numTeachersM;
          femaleCount += model[j].numTeachersF;
        }
      }

      totalMaleCount += maleCount;
      totalFemaleCount += femaleCount;

      dataMap[k] = _Data(maleCount, femaleCount);
    });

    dataMap["Total"] = _Data(totalMaleCount, totalFemaleCount);

    rowsList.add(title);
    rowsList.add(subTitle);

    int i = 0;
    dataMap.forEach((domain, measure) {
      rowsList.add(_generateTableRow(domain, measure, i));
      i++;
    });

    return rowsList;
  }

  TableRow _generateTableRow(String domain, _Data measure, int index) {
    return TableRow(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? widget._evenRowColor : widget._oddRowColor,
      ),
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
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
