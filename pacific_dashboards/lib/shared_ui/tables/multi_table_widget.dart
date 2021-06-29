import 'dart:ui';

import 'package:arch/arch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';

typedef int KeySortFunc(String lv, String rv);
typedef CellData DomainValueBuilder<T>(int index, _CellData<T> data);

const Color _kBorderColor = AppColors.kGeyser;
const double _kBorderWidth = 1.0;

class MultiTableWidget<T> extends StatelessWidget {
  final Map<String, T> _data;
  final KeySortFunc _keySortFunc;
  final String _title;
  final List<String> _columnNames;
  final List<int> _columnFlex;
  final DomainValueBuilder _domainValueBuilder;

  MultiTableWidget({
    Key key,
    @required Map<String, T> data,
    @required List<String> columnNames,
    @required List<int> columnFlex,
    @required DomainValueBuilder<T> domainValueBuilder,
    String title,
    KeySortFunc keySortFunc,
  })  : assert(data != null),
        assert(columnNames != null),
        assert(domainValueBuilder != null),
        assert(columnNames.length == columnFlex.length),
        _data = data,
        _title = title,
        _columnNames = columnNames,
        _columnFlex = columnFlex,
        _keySortFunc = keySortFunc,
        _domainValueBuilder = domainValueBuilder,
        super(key: key);

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
                    horizontal: 13.0,
                    vertical: 13.0,
                  ),
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
            children: _columnNames.mapIndexed((i, columnName) {
              return _SubTitleCell(
                flex: _columnFlex[i],
                name: columnName.localized(context),
              );
            }).toList(),
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
                      .map(
                        (it) => Container(
                          decoration: BoxDecoration(
                            color: it.index % 2 == 0
                                ? Colors.transparent
                                : AppColors.kGrayLight,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _columnNames.mapIndexed(
                              (index, columnName) {
                                return _Cell(
                                  flex: _columnFlex[index],
                                  value: _domainValueBuilder(index, it),
                                  fontWeight: _getFontWeight(it.domain)
                                );
                              },
                            ).toList(),
                            //_generateColumnCells(_columnNames, it),
                          ),
                        ),
                      )
                      .toList(),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  FontWeight _getFontWeight(String domainValue) {
    return domainValue == 'labelTotal' ? FontWeight.bold : FontWeight.normal;
  }
}

class CellData{
  final String value;
  final String svgImagePath;
  final double imageX;
  final double imageY;
  final bool isLabel;

  const CellData({
    @required this.value,
    this.svgImagePath,
    this.imageX = 0,
    this.imageY = 0,
    this.isLabel = false,
  });
}

class _Cell extends StatelessWidget {
  const _Cell({
    Key key,
    @required CellData value,
    int flex,
    FontWeight fontWeight,
  })
      : _value = value,
        _flex = flex,
        _fontWeight = fontWeight,
        super(key: key);

  final CellData _value;
  final int _flex;
  final FontWeight _fontWeight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _value.isLabel ? 1000000 : _flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Text(
                  _value.value.localized(context),
                  textAlign: _value.isLabel ? TextAlign.center : TextAlign
                      .start,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(
                      fontWeight: _value.isLabel
                          ? FontWeight.bold
                          : _fontWeight),
                )
            ),
            _value.svgImagePath != null ? Container(
                alignment: Alignment.centerLeft,
                width: _value.imageX,
                height: _value.imageY,
                child: SvgPicture.asset(
                  _value.svgImagePath,
                )
            ) : Container(),
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
  static DomainValueBuilder sDomainValueBuilder = (index, data) {
    switch (index) {
      case 0:
        return CellData(value: data.domain);
      case 1:
        return CellData(value: data.measure.maleAmount.toString());
      case 2:
        return CellData(value: data.measure.femaleAmount.toString());
      case 3:
        return CellData(value: data.measure.total.toString());
    }
    throw FallThroughError();
  };
  
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
