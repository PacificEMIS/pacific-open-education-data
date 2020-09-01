import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import "package:intl/intl.dart";

typedef int KeySortFunc(String lv, String rv);

const Color _kBorderColor = AppColors.kGeyser;
const double _kBorderWidth = 1.0;

class MultiTableWidget<T> extends StatelessWidget {
  MultiTableWidget({
    Key key,
    @required Map<String, T> data,
    @required List<String> columnNames,
    @required List<int> columnFlex,
    String title,
    String type,
    KeySortFunc keySortFunc,
  })  : assert(data != null),
        assert(columnNames != null),
        _data = data,
        _title = title,
        _type = type,
        _columnNames = columnNames,
        _columnFlex = columnFlex,
        _keySortFunc = keySortFunc,
        super(key: key);

  final Map<String, T> _data;
  final KeySortFunc _keySortFunc;
  final String _title;
  final String _type;
  final List<String> _columnNames;
  final List<int> _columnFlex;

  bool get _haveTitle => _title != null && _title.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
        border: Border.all(
          width: _kBorderWidth,
          color: _kBorderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (_haveTitle)
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 13.0),
                  child: Text(
                    _title?.localized(context) ?? 'null',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          if (_haveTitle)
            Container(
              height: _kBorderWidth,
              color: _kBorderColor,
            ),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getColumnTitles(_columnNames, _columnFlex, context)),
          FutureBuilder(
            future: Future.microtask(() {
              final keys = _data.keys.toList();
              if (_keySortFunc != null) {
                keys.sort(_keySortFunc);
              }

              return keys
                  .mapIndexed((index, key) => _CellData(
                        domain: key,
                        measure: _data[key],
                        index: index,
                      ))
                  .toList();
            }),
            builder: (context, AsyncSnapshot<List<_CellData>> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: _kBorderWidth,
                    color: _kBorderColor,
                  ),
                  ...snapshot.data
                      .map((it) => Container(
                            decoration: BoxDecoration(
                              color: it.index % 2 == 0
                                  ? Colors.transparent
                                  : AppColors.kGrayLight,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: generateColumnCells(
                                  _columnNames,
                                  it,
                                  (it.index - 1) == snapshot.data.length
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ))
                      .toList(),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  List<Widget> getColumnTitles(List<String> titles, List<int> flex, context) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < titles.length; i++) {
      list.add(
          new _SubTitleCell(flex: flex[i], name: titles[i].localized(context)));
    }
    return list;
  }

  List<Widget> generateColumnCells(
      List<String> strings, _CellData cellData, FontWeight fontWeight) {
    var numberFormat = new NumberFormat('###,###,###', 'eu');
    List<Widget> list = new List<Widget>();
    if (_type == 'Govt') {
      list.add(_Cell(flex: _columnFlex[0], value: cellData.domain.toString()));
      list.add(_Cell(
          flex: _columnFlex[1],
          value: numberFormat.format(cellData.measure.govtExpense)));
      list.add(_Cell(
          flex: _columnFlex[2],
          value: numberFormat.format(cellData.measure.edExpense)));
      list.add(_Cell(
          flex: _columnFlex[3],
          value: cellData.measure.percentageEdGovt.toStringAsFixed(1)));
    } else if (_type == 'GNP') {
      list.add(_Cell(flex: _columnFlex[0], value: cellData.domain.toString()));
      list.add(_Cell(
          flex: _columnFlex[1],
          value: numberFormat.format(cellData.measure.gNP)));
      list.add(_Cell(
          flex: _columnFlex[2],
          value: numberFormat.format(cellData.measure.edExpense)));
      list.add(_Cell(
          flex: _columnFlex[3],
          value: cellData.measure.percentageEdGnp.toStringAsFixed(1)));
    } else if (_type == 'ECE') {
      list.add(_Cell(flex: _columnFlex[0], value: cellData.domain.toString()));
      list.add(_Cell(
          flex: _columnFlex[1],
          value: numberFormat.format(cellData.measure.eceActual)));
      list.add(_Cell(
          flex: _columnFlex[2],
          value: numberFormat.format(cellData.measure.eceBudget)));
    } else if (_type == 'Primary') {
      list.add(_Cell(flex: _columnFlex[0], value: cellData.domain.toString()));
      list.add(_Cell(
          flex: _columnFlex[1],
          value: numberFormat.format(cellData.measure.primaryActual)));
      list.add(_Cell(
          flex: _columnFlex[2],
          value: numberFormat.format(cellData.measure.primaryBudget)));
    } else if (_type == 'Secondary') {
      list.add(_Cell(flex: _columnFlex[0], value: cellData.domain.toString()));
      list.add(_Cell(
          flex: _columnFlex[1],
          value: numberFormat.format(cellData.measure.secondaryActual)));
      list.add(_Cell(
          flex: _columnFlex[2],
          value: numberFormat.format(cellData.measure.secondaryBudget)));
    } else if (_type == 'Total') {
      list.add(_Cell(flex: _columnFlex[0], value: cellData.domain.toString()));
      list.add(_Cell(
          flex: _columnFlex[1],
          value: numberFormat.format(cellData.measure.totalActual)));
      list.add(_Cell(
          flex: _columnFlex[2],
          value: numberFormat.format(cellData.measure.totalBudget)));
    } else {
      list.add(_Cell(flex: _columnFlex[0], value: cellData.domain.toString()));
      list.add(_Cell(
          flex: _columnFlex[1], value: cellData.measure.maleAmount.toString()));
      list.add(_Cell(
          flex: _columnFlex[2],
          value: cellData.measure.femaleAmount.toString()));
      list.add(_Cell(
          flex: _columnFlex[3], value: cellData.measure.total.toString()));
    }

    return list;
  }
}

class _Cell extends StatelessWidget {
  const _Cell(
      {Key key, @required String value, int flex, FontWeight fontWeight})
      : _value = value,
        _flex = flex,
        _fontWeight = fontWeight,
        super(key: key);

  final String _value;
  final int _flex;
  final FontWeight _fontWeight;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              _value.localized(context),
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(fontWeight: _fontWeight),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubTitleCell extends StatelessWidget {
  const _SubTitleCell({Key key, @required String name, int flex})
      : _name = name,
        _flex = flex,
        super(key: key);

  final String _name;
  final int _flex;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _flex,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              _name,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: AppColors.kTextMinor),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderTableData {
  static const String _kZeroSymbol = "-";

  final int _maleAmount;
  final int _femaleAmount;

  const GenderTableData(this._maleAmount, this._femaleAmount);

  String get maleAmount =>
      _maleAmount != 0 ? _maleAmount.toString() : _kZeroSymbol;

  String get femaleAmount =>
      _femaleAmount != 0 ? _femaleAmount.toString() : _kZeroSymbol;

  String get total => (_maleAmount + _femaleAmount) != 0
      ? (_maleAmount + _femaleAmount).toString()
      : _kZeroSymbol;
}

class _CellData<T> {
  final String domain;
  final T measure;
  final int index;

  const _CellData({
    @required this.domain,
    @required this.measure,
    @required this.index,
  });
}
