import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/utils/collections.dart';

typedef int KeySortFunc(String lv, String rv);

const Color _kBorderColor = AppColors.kGeyser;
const double _kBorderWidth = 1.0;

class GenderTableWidget extends StatelessWidget {
  GenderTableWidget({
    Key key,
    @required Map<String, GenderTableData> data,
    @required String firstColumnName,
    String title,
    KeySortFunc keySortFunc,
  })  : assert(data != null),
        assert(firstColumnName != null),
        _data = data,
        _title = title,
        _firstColumnName = firstColumnName,
        _keySortFunc = keySortFunc,
        super(key: key);

  final Map<String, GenderTableData> _data;
  final KeySortFunc _keySortFunc;
  final String _title;
  final String _firstColumnName;

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
                      horizontal: 16.0, vertical: 13.0),
                  child: Text(
                    _title ?? 'null',
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
            children: <Widget>[
              _SubTitleCell(name: _firstColumnName),
              _SubTitleCell(name: AppLocalizations.male),
              _SubTitleCell(name: AppLocalizations.female),
              _SubTitleCell(name: AppLocalizations.total),
            ],
          ),
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
                                  : AppColors.kAthensGray,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _Cell(value: it.domain),
                                _Cell(value: it.measure.maleAmount),
                                _Cell(value: it.measure.femaleAmount),
                                _Cell(value: it.measure.total),
                              ],
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              _value,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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

class _CellData {
  final String domain;
  final GenderTableData measure;
  final int index;

  const _CellData({
    @required this.domain,
    @required this.measure,
    @required this.index,
  });
}
