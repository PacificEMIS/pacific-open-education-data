import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/pair.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/utils/hex_color.dart';
import 'package:pacific_dashboards/utils/collections.dart';

const double _kBorderWidth = 1.0;
const Color _kBorderColor = AppColors.kGeyser;

class ChartInfoTableWidget extends StatefulWidget {
  final BuiltMap<String, int> _data;
  final String _titleName;
  final String _titleValue;

  ChartInfoTableWidget(this._data, this._titleName, this._titleValue);

  @override
  _ChartInfoTableWidgetState createState() => _ChartInfoTableWidgetState();
}

class _ChartInfoTableWidgetState<T> extends State<ChartInfoTableWidget> {
  SortType _sortType = SortType.domainInc;

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          border: Border.all(
            width: _kBorderWidth,
            color: _kBorderColor,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _SortingTitle(
                title: widget._titleName,
                icon: _sortType.iconFor(ValueType.domain),
                onTap: () => _onSortTap(ValueType.domain),
              ),
              _SortingTitle(
                title: widget._titleValue,
                icon: _sortType.iconFor(ValueType.measure),
                onTap: () => _onSortTap(ValueType.measure),
              )
            ],
          ),
          FutureBuilder(
              future: _sortedRowDatas,
              builder: (context, AsyncSnapshot<BuiltList<_RowData>> snapshot) {
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
                    ...snapshot.data.map((it) => _Row(rowData: it)).toList(),
                  ],
                );
              })
        ],
      ),
    );
  }

  void _onSortTap(ValueType valueType) {
    var newSortType = _sortType;
    switch (valueType) {
      case ValueType.domain:
        switch (_sortType) {
          case SortType.domainInc:
            newSortType = SortType.domainDec;
            break;
          case SortType.domainDec:
            newSortType = SortType.domainInc;
            break;
          case SortType.measureInc:
          case SortType.measureDec:
          case SortType.none:
            newSortType = SortType.domainInc;
            break;
        }
        break;
      case ValueType.measure:
        switch (_sortType) {
          case SortType.measureInc:
            newSortType = SortType.measureDec;
            break;
          case SortType.measureDec:
            newSortType = SortType.measureInc;
            break;
          case SortType.domainInc:
          case SortType.domainDec:
          case SortType.none:
            newSortType = SortType.measureInc;
            break;
        }
        break;
    }

    setState(() {
      _sortType = newSortType;
    });
  }

  Future<BuiltList<_RowData>> get _sortedRowDatas {
    return Future.microtask(() {
      final convertToRowData = (int index, Pair<String, int> pair) => _RowData(
            index: index,
            domain: pair.v1,
            measure: pair.v2,
          );
      switch (_sortType) {
        case SortType.measureInc:
          return widget._data
              .mapToList((domain, measure) => Pair(domain, measure))
              .sort((lv, rv) => lv.v2.compareTo(rv.v2))
              .mapIndexed(convertToRowData)
              .toBuiltList();
        case SortType.measureDec:
          return widget._data
              .mapToList((domain, measure) => Pair(domain, measure))
              .sort((lv, rv) => rv.v2.compareTo(lv.v2))
              .mapIndexed(convertToRowData)
              .toBuiltList();
        case SortType.domainInc:
          return widget._data
              .mapToList((domain, measure) => Pair(domain, measure))
              .sort((lv, rv) => lv.v1.compareTo(rv.v1))
              .mapIndexed(convertToRowData)
              .toBuiltList();
        case SortType.domainDec:
          return widget._data
              .mapToList((domain, measure) => Pair(domain, measure))
              .sort((lv, rv) => rv.v1.compareTo(lv.v1))
              .mapIndexed(convertToRowData)
              .toBuiltList();
        case SortType.none:
          return widget._data
              .mapToList((domain, measure) => Pair(domain, measure))
              .mapIndexed(convertToRowData)
              .toBuiltList();
      }

      throw FallThroughError();
    });
  }
}

class _SortingTitle extends StatelessWidget {
  const _SortingTitle({
    Key key,
    @required String title,
    @required Icon icon,
    @required GestureTapCallback onTap,
  })  : _title = title,
        _icon = icon,
        _onTap = onTap,
        super(key: key);

  final String _title;
  final Icon _icon;
  final GestureTapCallback _onTap;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: _onTap,
      child: Row(
        children: <Widget>[
          Text(
            _title,
            style: Theme.of(context)
                .textTheme
                .body2
                .copyWith(color: AppColors.kNevada),
          ),
          _icon,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final _RowData _rowData;

  const _Row({Key key, @required _RowData rowData})
      : assert(rowData != null),
        _rowData = rowData,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ((_rowData.index % 2 == 0)
          ? Colors.transparent
          : AppColors.kAthensGray),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(1.0)),
                        color: HexColor.fromStringHash(_rowData.domain),
                      ),
                      height: 8.0,
                      width: 8.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _rowData.domain,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _rowData.measure.toString(),
                      style: Theme.of(context).textTheme.subhead,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowData {
  final String domain;
  final int measure;
  final int index;

  _RowData({
    @required this.domain,
    @required this.measure,
    @required this.index,
  });
}

enum SortType {
  measureInc,
  measureDec,
  domainInc,
  domainDec,
  none,
}

enum ValueType { domain, measure }

extension SortTypeIcon on SortType {
  Icon iconFor(ValueType valueType) {
    const downIcon = const Icon(
      Icons.expand_more,
      color: AppColors.kNevada,
    );
    const upIcon = const Icon(
      Icons.expand_less,
      color: AppColors.kNevada,
    );
    const noneIcon = const Icon(
      Icons.minimize,
      color: Colors.transparent,
    );
    switch (valueType) {
      case ValueType.domain:
        switch (this) {
          case SortType.domainInc:
            return downIcon;
          case SortType.domainDec:
            return upIcon;
          case SortType.measureInc:
          case SortType.measureDec:
          case SortType.none:
            return noneIcon;
        }
        throw FallThroughError();
      case ValueType.measure:
        switch (this) {
          case SortType.measureInc:
            return downIcon;
          case SortType.measureDec:
            return upIcon;
          case SortType.domainInc:
          case SortType.domainDec:
          case SortType.none:
            return noneIcon;
        }
        throw FallThroughError();
    }
    throw FallThroughError();
  }
}
