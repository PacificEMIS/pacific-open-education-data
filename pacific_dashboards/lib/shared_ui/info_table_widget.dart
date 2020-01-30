import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';

typedef int KeySortFunc(String lv, String rv);

class InfoTableData {
  static const String _kZeroSymbol = "-";

  final int _maleAmount;
  final int _femaleAmount;

  const InfoTableData(this._maleAmount, this._femaleAmount);

  String get maleAmount =>
      _maleAmount != 0 ? _maleAmount.toString() : _kZeroSymbol;

  String get femaleAmount =>
      _femaleAmount != 0 ? _femaleAmount.toString() : _kZeroSymbol;

  String get total => (_maleAmount + _femaleAmount) != 0
      ? (_maleAmount + _femaleAmount).toString()
      : _kZeroSymbol;
}

class InfoTableWidget extends StatefulWidget {
  InfoTableWidget({
    Key key,
    @required BuiltMap<String, InfoTableData> data,
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

  final BuiltMap<String, InfoTableData> _data;
  final KeySortFunc _keySortFunc;

  final String _title;
  final String _firstColumnName;

  final Color _borderColor = AppColors.kGeyser;

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
            child: Text(
              widget._title ?? 'null',
              style: Theme.of(context).textTheme.body2,
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
          child: _SubTitleCell(name: widget._firstColumnName),
        ),
        TableCell(
          child: _SubTitleCell(name: 'Male'),
        ),
        TableCell(
          child: _SubTitleCell(name: 'Female'),
        ),
        TableCell(
          child: _SubTitleCell(name: 'Total'),
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
      BuiltMap<String, InfoTableData> data, TableRow subTitle) {
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
        color: index % 2 == 0 ? Colors.white : AppColors.kAthensGray,
      ),
      children: [
        TableCell(
          child: _Cell(value: domain),
        ),
        TableCell(
          child: _Cell(value: measure.maleAmount.toString()),
        ),
        TableCell(
          child: _Cell(value: measure.femaleAmount.toString()),
        ),
        TableCell(
          child: _Cell(value: measure.total.toString()),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    Key key,
    @required String value,
  })  : _value = value,
        super(key: key);

  final String _value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            _value,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ],
      ),
    );
  }
}

class _SubTitleCell extends StatelessWidget {
  const _SubTitleCell({
    Key key,
    @required String name,
  })  : _name = name,
        super(key: key);

  final String _name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            _name,
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(color: AppColors.kNevada),
          ),
        ],
      ),
    );
  }
}
