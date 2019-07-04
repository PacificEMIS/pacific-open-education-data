import 'package:flutter/material.dart';
import '../config/Constants.dart';
import '../utils/HexColor.dart';
import 'enums/SortType.dart';

class ChartInfoTable<T> extends StatefulWidget {
  static const double _kBorderWidth = 1.0;

  final Map<dynamic, List<T>> _data;
  final String _titleName;
  final String _titleValue;

  Color _borderColor = AppColors.kGeyser;
  Color _textColor = AppColors.kTimberGreen;
  Color _titleTextColor = AppColors.kNevada;
  Color _evenRowColor = AppColors.kWhite;
  Color _oddRowColor = AppColors.kAthensGray;
  Color _iconArrowColor = AppColors.kTuna;

  bool _domainSortedByIncreasing = true;
  bool _measureSortedByIncreasing = true;
  SortType _sortType = SortType.NotSorted;

  ChartInfoTable(this._data, this._titleName, this._titleValue);

  @override
  _ChartInfoTableState createState() => _ChartInfoTableState<T>();
}

class _ChartInfoTableState<T> extends State<ChartInfoTable<T>> {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: _getTableBorder(widget._borderColor, ChartInfoTable._kBorderWidth),
      children: _generateTableBody(widget._data, _generateTableTitle(widget._borderColor, ChartInfoTable._kBorderWidth)),
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
                  widget._titleName,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: widget._titleTextColor,
                  ),
                ),
                InkResponse(
                  child: Icon(
                    (widget._domainSortedByIncreasing ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                    color: widget._iconArrowColor,
                  ),
                  onTap: () {
                    setState(() {
                      widget._sortType = SortType.Domain;
                      widget._domainSortedByIncreasing = !widget._domainSortedByIncreasing;
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
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
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
                    (widget._measureSortedByIncreasing ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                    color: widget._iconArrowColor,
                  ),
                  onTap: () {
                    setState(() {
                      widget._sortType = SortType.Measure;
                      widget._measureSortedByIncreasing = !widget._measureSortedByIncreasing;
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

  List<TableRow> _generateTableBody(Map<dynamic, List<T>> data, TableRow title) {
    var rowsList = List<TableRow>();
    var dataMap = Map<String, int>();
    data.forEach((k, v) {
      dataMap[k] = v.length;
    });

    List<String> sortedKeys = dataMap.keys.toList();
    List<int> sortedValues = dataMap.values.toList();

    rowsList.add(title);

    switch (widget._sortType) {
      case SortType.Domain:
        if (widget._domainSortedByIncreasing) {
          sortedKeys.sort((a, b) => a.compareTo(b));
        } else {
          sortedKeys.sort((a, b) => b.compareTo(a));
        }

        for (int i = 0; i < sortedKeys.length; ++i) {
          rowsList.add(_generateTableRow(sortedKeys[i], dataMap[sortedKeys[i]], i));
        }
        break;
      case SortType.Measure:
        if (widget._measureSortedByIncreasing) {
          sortedValues.sort((a, b) => a.compareTo(b));
        } else {
          sortedValues.sort((a, b) => b.compareTo(a));
        }

        for (int i = 0; i < sortedValues.length; ++i) {
          var key = dataMap.keys.firstWhere((k) => dataMap[k] == sortedValues[i], orElse: () => null);
          rowsList.add(_generateTableRow(key, dataMap[key], i));
        }
        break;
      default:
        int i = 0;
        dataMap.forEach((domain, measure) {
          rowsList.add(_generateTableRow(domain, measure, i));
          i++;
        });
    }

    return rowsList;
  }

  TableRow _generateTableRow(String domain, int measure, int index) {
    // crutch for correcting the names of the govt/non-govt chart table domains
    var generatedDomain = "";
    if (domain == "G") {
      generatedDomain = "Gonverenment";
    } else if (domain == "N") {
      generatedDomain = "Non-Gonverenment";
    } else {
      generatedDomain = domain;
    }

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
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      color: HexColor.fromStringHash(domain),
                    ),
                    height: 8.0,
                    width: 8.0,
                  ),
                ),
                Text(
                  generatedDomain,
                  style: TextStyle(
                    fontSize: 14.0,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  measure.toString(),
                  style: TextStyle(
                    fontSize: 14.0,
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
