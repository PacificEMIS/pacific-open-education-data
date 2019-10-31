import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';

//TODO: refactor required
class AccreditationTableData {
  static const String _kZeroSymbol = "-";
  final int level1;
  final int level2;
  final int level3;
  final int level4;

  String get level1Amount => level1 != 0 ? level1.toString() : _kZeroSymbol;
  String get level2Amount => level2 != 0 ? level2.toString() : _kZeroSymbol;
  String get level3Amount => level3 != 0 ? level3.toString() : _kZeroSymbol;
  String get level4Amount => level4 != 0 ? level4.toString() : _kZeroSymbol;

  String get total => (level1 + level2 + level3 + level4).toString();

  String get accreditated => (level2 + level3 + level4).toString();

  AccreditationTableData(this.level1, this.level2, this.level3, this.level4);
}

class AccreditationTableWidget extends StatefulWidget {
  static const double _kBorderWidth = 1.0;

  final Map<dynamic, AccreditationTableData> data;

  final String keyName;
  final String firstColumnName;

  final Color _borderColor = AppColors.kGeyser;
  final Color _textColor = AppColors.kTimberGreen;
  final Color _subTitleTextColor = AppColors.kNevada;
  final Color _evenRowColor = AppColors.kWhite;
  final Color _oddRowColor = AppColors.kAthensGray;
  final Color _titleTextColor = AppColors.kEndeavour;

  AccreditationTableWidget(
      {Key key,
      @required this.data,
      @required this.keyName,
      @required this.firstColumnName})
      : super(key: key);

  @override
  State<AccreditationTableWidget> createState() => _AccreditationTableWidgetState();
}

class _AccreditationTableWidgetState extends State<AccreditationTableWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Table(
        columnWidths: {
          0: FlexColumnWidth(2.2),
          1: FlexColumnWidth(1),
        },
        border: _getTableBorder(
            widget._borderColor, AccreditationTableWidget._kBorderWidth),
        children: [
          _generateTableTitle(
              widget._borderColor, AccreditationTableWidget._kBorderWidth)
        ],
      ),
      Table(
        columnWidths: {
          0: FlexColumnWidth(2.2),
          1: FlexColumnWidth(1),
        },
        border: _getTableBorder(
            widget._borderColor, AccreditationTableWidget._kBorderWidth),
        children: _generateTableBody(
            widget.data,
            _generateSubTableTitle(
                widget._borderColor, AccreditationTableWidget._kBorderWidth)),
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
                  widget.keyName,
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
                  widget.firstColumnName,
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "1",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: widget._subTitleTextColor,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.red,
                      size: 13.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "2",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: widget._subTitleTextColor,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 13.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "3",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: widget._subTitleTextColor,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.lightGreen,
                      size: 13.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "4",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: widget._subTitleTextColor,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.green,
                      size: 13.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              "Total",
              style: TextStyle(
                fontSize: 12.0,
                color: widget._subTitleTextColor,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              "Accreditated",
              style: TextStyle(
                fontSize: 12.0,
                color: widget._subTitleTextColor,
              ),
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
      Map<dynamic, AccreditationTableData> data, TableRow subTitle) {
    var rowsList = List<TableRow>();
    rowsList.add(subTitle);

    int i = 0;
    data.forEach((domain, measure) {
      rowsList.add(_generateTableRow(domain, measure, i));
      i++;
    });

    return rowsList;
  }

  TableRow _generateTableRow(
      String domain, AccreditationTableData measure, int index) {
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
                Expanded(
                  child: Text(
                    domain,
                    maxLines: 3,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 9.0,
                      color: widget._textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  measure.level1Amount.toString(),
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  measure.level2Amount.toString(),
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  measure.level3Amount.toString(),
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  measure.level4Amount.toString(),
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  measure.accreditated.toString(),
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
