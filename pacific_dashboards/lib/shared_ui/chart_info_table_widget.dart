import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/utils/hex_color.dart';

// TODO: REFACTOR THIS
class ChartInfoTableWidget extends StatefulWidget {
  static const double _kBorderWidth = 1.0;

  final List<String> _keys;
  final Map<String, int> _data;
  final String _titleName;
  final String _titleValue;

  final Color _borderColor = AppColors.kGeyser;
  final Color _textColor = AppColors.kTimberGreen;
  final Color _titleTextColor = AppColors.kNevada;
  final Color _evenRowColor = AppColors.kWhite;
  final Color _oddRowColor = AppColors.kAthensGray;
  final Color _iconArrowColor = AppColors.kTuna;

  ChartInfoTableWidget(this._data, this._titleName, this._titleValue)
      : _keys = _data.keys.toList();

  @override
  _ChartInfoTableWidgetState createState() => _ChartInfoTableWidgetState();
}

class _ChartInfoTableWidgetState<T> extends State<ChartInfoTableWidget> {
  bool _domainSortedByIncreasing = true;
  bool _measureSortedByIncreasing = true;
  SortType _sortType = SortType.notSorted;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Table(
        border: _getTableBorder(
            widget._borderColor, ChartInfoTableWidget._kBorderWidth, true),
        children: [
          _generateTableTitle(
              widget._borderColor, ChartInfoTableWidget._kBorderWidth, true)
        ],
      ),
      Table(
        columnWidths: {
          0: FlexColumnWidth(1.7),
          1: FlexColumnWidth(1),
        },
        border: _getTableBorder(
            widget._borderColor, ChartInfoTableWidget._kBorderWidth, false),
        children: _generateTableBody(widget._keys, widget._data),
      )
    ]);
  }

  TableRow _generateTableTitle(
      Color borderColor, double borderWidth, bool top) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border.all(
          width: borderWidth,
          color: borderColor,
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
                  widget._titleName,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: widget._titleTextColor,
                  ),
                ),
                InkResponse(
                  child: Icon(
                    (_domainSortedByIncreasing
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up),
                    color: widget._iconArrowColor,
                  ),
                  onTap: () {
                    setState(() {
                      _sortType = SortType.domain;
                      _domainSortedByIncreasing = !_domainSortedByIncreasing;
                    });
                  },
                  highlightShape: BoxShape.rectangle,
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 6.0, right: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  widget._titleValue,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: widget._titleTextColor,
                  ),
                ),
                InkResponse(
                  child: Icon(
                    (_measureSortedByIncreasing
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up),
                    color: widget._iconArrowColor,
                  ),
                  onTap: () {
                    setState(() {
                      _sortType = SortType.measure;
                      _measureSortedByIncreasing = !_measureSortedByIncreasing;
                    });
                  },
                  highlightShape: BoxShape.rectangle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TableBorder _getTableBorder(Color borderColor, double borderWidth, bool top) {
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
        width: top ? 0 : borderWidth,
        color: borderColor,
      ),
    );
  }

  List<TableRow> _generateTableBody(
      List<dynamic> keys, Map<dynamic, int> dataMap) {
    final rowsList = List<TableRow>();
    List<int> sortedValues = dataMap.values.toList();

    switch (_sortType) {
      case SortType.domain:
        if (_domainSortedByIncreasing) {
          keys.sort((a, b) => a.compareTo(b));
        } else {
          keys.sort((a, b) => b.compareTo(a));
        }

        for (int i = 0; i < keys.length; ++i) {
          if (dataMap.containsKey(keys[i])) {
            rowsList.add(_generateTableRow(keys[i], dataMap[keys[i]], i));
          } else {
            rowsList.add(_generateTableRow(keys[i], 0, i));
          }
        }
        break;
      case SortType.measure:
        if (_measureSortedByIncreasing) {
          sortedValues.sort((a, b) => a.compareTo(b));
        } else {
          sortedValues.sort((a, b) => b.compareTo(a));
        }

        var globalIndex = 0;

        if (_measureSortedByIncreasing) {
          for (var i = 0; i < keys.length; ++i) {
            if (!dataMap.containsKey(keys[i])) {
              rowsList.add(_generateTableRow(keys[i], 0, globalIndex));
              globalIndex++;
            }
          }

          for (int i = 0; i < sortedValues.length; ++i) {
            var key = dataMap.keys.firstWhere(
                (k) => dataMap[k] == sortedValues[i],
                orElse: () => null);
            rowsList.add(_generateTableRow(key, dataMap[key], globalIndex));

            globalIndex++;
          }
        } else {
          for (int i = 0; i < sortedValues.length; ++i) {
            var key = dataMap.keys.firstWhere(
                (k) => dataMap[k] == sortedValues[i],
                orElse: () => null);
            rowsList.add(_generateTableRow(key, dataMap[key], globalIndex));

            globalIndex++;
          }

          for (var i = 0; i < keys.length; ++i) {
            if (!dataMap.containsKey(keys[i])) {
              rowsList.add(_generateTableRow(keys[i], 0, globalIndex));

              globalIndex++;
            }
          }
        }
        break;
      case SortType.notSorted:
        for (int i = 0; i < keys.length; ++i) {
          if (dataMap.containsKey(keys[i])) {
            rowsList.add(_generateTableRow(keys[i], dataMap[keys[i]], i));
          } else {
            rowsList.add(_generateTableRow(keys[i], 0, i));
          }
        }
        break;
    }

    return rowsList;
  }

  TableRow _generateTableRow(String domain, int measure, int index) {
    final rowTextStyle = TextStyle(
      fontSize: 14.0,
      color: widget._textColor,
    );

    return TableRow(
      decoration: BoxDecoration(
        color: ((index % 2 == 0) ? widget._evenRowColor : widget._oddRowColor),
      ),
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 8.0, right: 7.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      color: HexColor.fromStringHash(domain),
                      // AppColors.kGridColors[index] ?? "#1A73E8"),
                    ),
                    height: 8.0,
                    width: 8.0,
                  ),
                ),
                Expanded(
                  child: Text(
                    domain,
                    style: rowTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  measure.toString(),
                  style: rowTextStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum SortType {
  measure,
  domain,
  notSorted,
}
