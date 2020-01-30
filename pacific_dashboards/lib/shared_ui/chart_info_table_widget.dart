import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/utils/hex_color.dart';

class ChartInfoTableWidget extends StatefulWidget {
  static const double _kBorderWidth = 1.0;

  final BuiltList<String> _keys;
  final BuiltMap<String, int> _data;
  final String _titleName;
  final String _titleValue;

  final Color _borderColor = AppColors.kGeyser;

  ChartInfoTableWidget(this._data, this._titleName, this._titleValue)
      : _keys = _data.keys.toBuiltList();

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
        children: _generateTableBody(widget._keys.toList(), widget._data),
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
          child: _SortingTitle(
            title: widget._titleName,
            useUpArrowIcon: !_domainSortedByIncreasing,
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 16.0,
              right: 16.0,
            ),
            onTap: () {
              setState(() {
                _sortType = SortType.domain;
                _domainSortedByIncreasing = !_domainSortedByIncreasing;
              });
            },
          ),
        ),
        TableCell(
          child: _SortingTitle(
            title: widget._titleValue,
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 6.0,
              right: 8.0,
            ),
            alignment: MainAxisAlignment.end,
            useUpArrowIcon: !_measureSortedByIncreasing,
            onTap: () {
              setState(() {
                _sortType = SortType.measure;
                _measureSortedByIncreasing = !_measureSortedByIncreasing;
              });
            },
          ),
        ),
      ],
    );
  }

  TableBorder _getTableBorder(
      Color borderColor, double borderWidth, bool isTop) {
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
        width: isTop ? 0 : borderWidth,
        color: borderColor,
      ),
    );
  }

  List<TableRow> _generateTableBody(
      List<dynamic> keys, BuiltMap<dynamic, int> dataMap) {
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
    return TableRow(
      decoration: BoxDecoration(
        color: ((index % 2 == 0) ? Colors.white : AppColors.kAthensGray),
      ),
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 8.0,
              right: 7.0,
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(1.0)),
                      color: HexColor.fromStringHash(domain),
                    ),
                    height: 8.0,
                    width: 8.0,
                  ),
                ),
                Expanded(
                  child: Text(
                    domain,
                    style: Theme.of(context).textTheme.subhead,
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
              top: 10.0,
              bottom: 10.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  measure.toString(),
                  style: Theme.of(context).textTheme.subhead,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SortingTitle extends StatelessWidget {
  const _SortingTitle({
    Key key,
    @required String title,
    @required bool useUpArrowIcon,
    @required GestureTapCallback onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.only(),
    MainAxisAlignment alignment = MainAxisAlignment.start,
  })  : _title = title,
        _useUpArrowIcon = useUpArrowIcon,
        _onTap = onTap,
        _padding = padding,
        _alignment = alignment,
        super(key: key);

  final MainAxisAlignment _alignment;
  final EdgeInsetsGeometry _padding;
  final String _title;
  final bool _useUpArrowIcon;
  final GestureTapCallback _onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Row(
        mainAxisAlignment: _alignment,
        children: <Widget>[
          Text(
            _title,
            style: Theme.of(context)
                .textTheme
                .body2
                .copyWith(color: AppColors.kNevada),
          ),
          InkResponse(
            child: Icon(
              (_useUpArrowIcon
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              color: AppColors.kTuna,
            ),
            onTap: _onTap,
            highlightShape: BoxShape.rectangle,
          ),
        ],
      ),
    );
  }
}

enum SortType {
  measure,
  domain,
  notSorted,
}
