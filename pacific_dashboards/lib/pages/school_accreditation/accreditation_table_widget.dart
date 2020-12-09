import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';

class AccreditationTableData {
  const AccreditationTableData(
    this.level1,
    this.level2,
    this.level3,
    this.level4,
  );

  static const String _kZeroSymbol = '-';
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
}

class AccreditationTableWidget extends StatefulWidget {
  const AccreditationTableWidget({
    Key key,
    @required this.data,
    @required this.title,
    @required this.firstColumnName,
  }) : super(key: key);

  static const double _kBorderWidth = 1.0;

  final Map<String, AccreditationTableData> data;

  final String title;
  final String firstColumnName;

  final Color _borderColor = AppColors.kGeyser;
  final Color _evenRowColor = Colors.white;
  final Color _oddRowColor = AppColors.kGrayLight;

  @override
  State<AccreditationTableWidget> createState() =>
      _AccreditationTableWidgetState();
}

class _AccreditationTableWidgetState extends State<AccreditationTableWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Table(
          columnWidths: const {
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
        color: Colors.black.withOpacity(0.05),
      ),
      children: [
        TableCell(
          child: _SubTitleCell(
            name: widget.firstColumnName,
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
          ),
        ),
        const TableCell(
          child: _SubTitleCell(
            name: '1',
            padding: EdgeInsets.symmetric(vertical: 10.0),
            icon: Icon(Icons.star, color: Colors.red, size: 13.0),
          ),
        ),
        const TableCell(
          child: _SubTitleCell(
            name: '2',
            padding: EdgeInsets.symmetric(vertical: 10.0),
            icon: Icon(Icons.star, color: Colors.yellow, size: 13.0),
          ),
        ),
        const TableCell(
          child: _SubTitleCell(
            name: '3',
            padding: EdgeInsets.symmetric(vertical: 10.0),
            icon: Icon(Icons.star, color: Colors.lightGreen, size: 13.0),
          ),
        ),
        const TableCell(
          child: _SubTitleCell(
            name: '4',
            padding: EdgeInsets.symmetric(vertical: 10.0),
            icon: Icon(Icons.star, color: Colors.green, size: 13.0),
          ),
        ),
        const TableCell(
          child: _SubTitleCell(
            name: 'Total',
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
        ),
        const TableCell(
          child: _SubTitleCell(
            name: 'Accreditated',
            padding: EdgeInsets.symmetric(vertical: 10.0),
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
    Map<dynamic, AccreditationTableData> data,
    TableRow subTitle,
  ) {
    final rowsList = <TableRow>[subTitle];

    var i = 0;
    data.forEach((domain, measure) {
      rowsList.add(_generateTableRow(domain, measure, i));
      i++;
    });

    return rowsList;
  }

  TableRow _generateTableRow(
    String domain,
    AccreditationTableData measure,
    int index,
  ) {
    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? widget._evenRowColor : widget._oddRowColor,
      ),
      children: [
        TableCell(
          child: _Cell(
            value: domain,
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
            customFontSize: 9.0,
          ),
        ),
        TableCell(
          child: _Cell(
            value: measure.level1Amount.toString(),
          ),
        ),
        TableCell(
          child: _Cell(
            value: measure.level2Amount.toString(),
          ),
        ),
        TableCell(
          child: _Cell(
            value: measure.level3Amount.toString(),
          ),
        ),
        TableCell(
          child: _Cell(
            value: measure.level4Amount.toString(),
          ),
        ),
        TableCell(
          child: _Cell(
            value: measure.total.toString(),
          ),
        ),
        TableCell(
          child: _Cell(
            value: measure.accreditated.toString(),
          ),
        ),
      ],
    );
  }
}

class _SubTitleCell extends StatelessWidget {
  const _SubTitleCell({
    Key key,
    @required String name,
    Icon icon,
    EdgeInsets padding = const EdgeInsets.only(),
  })  : _name = name,
        _icon = icon,
        _padding = padding,
        super(key: key);

  final String _name;
  final Icon _icon;
  final EdgeInsets _padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (_icon == null)
            Expanded(
              child: _SubTitle(name: _name),
            ),
          if (_icon != null) _SubTitle(name: _name),
          if (_icon != null) _icon,
        ],
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({
    Key key,
    @required String name,
  })  : _name = name,
        super(key: key);

  final String _name;

  @override
  Widget build(BuildContext context) {
    return Text(
      _name,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    Key key,
    @required String value,
    EdgeInsets padding = const EdgeInsets.symmetric(vertical: 10.0),
    double customFontSize,
  })  : _value = value,
        _padding = padding,
        _customFontSize = customFontSize,
        super(key: key);

  final String _value;
  final EdgeInsets _padding;
  final double _customFontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: _padding,
        child: Row(
          children: [
            Expanded(
              child: Text(
                _value.isEmpty ? '-' : _value,
                overflow: TextOverflow.fade,
                style: _customFontSize == null
                    ? Theme.of(context).textTheme.subtitle2
                    : Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontSize: 9.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
