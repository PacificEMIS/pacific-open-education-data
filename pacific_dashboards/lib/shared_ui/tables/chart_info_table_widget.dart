import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';

const double _kBorderWidth = 1.0;
const Color _kBorderColor = AppColors.kGeyser;

class ChartInfoTableWidget extends StatefulWidget {
  final List<ChartData> _data;
  final String _titleName;
  final String _titleValue;
  final bool _showColor;

  ChartInfoTableWidget(this._data, this._titleName, this._titleValue, this._showColor);

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
        ),
      ),
      child: _buildColumns(),
    );
  }

  Column _buildColumns() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _SortingTitle(
              title: widget._titleName,
              icon: _sortType.iconFor(ValueType.domain),
              onTap: () => _onSortTap(ValueType.domain),
            ),
            Expanded(
              child: _SortingDomain(
                title: widget._titleValue,
                icon: _sortType.iconFor(ValueType.measure),
                onTap: () => _onSortTap(ValueType.measure),
              ),
            )
          ],
        ),
        _ColumnFutureBuilder(sortedRowDatas: _sortedRowDatas, showColors: widget._showColor),
      ],
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

  _RowData _convertToRowData(int index, ChartData chartData) => _RowData(
        index: index,
        domain: chartData.domain,
        measure: chartData.measure,
        color: chartData.color,
      );

  Future<List<_RowData>> get _sortedRowDatas {
    return Future.microtask(() {
      switch (_sortType) {
        case SortType.measureInc:
          return widget._data
              .chainSort((lv, rv) => lv.measure.compareTo(rv.measure))
              .mapIndexed(_convertToRowData)
              .toList();
        case SortType.measureDec:
          return widget._data
              .chainSort((lv, rv) => rv.measure.compareTo(lv.measure))
              .mapIndexed(_convertToRowData)
              .toList();
        case SortType.domainInc:
          return widget._data
              .chainSort((lv, rv) => lv.domain.compareTo(rv.domain))
              .mapIndexed(_convertToRowData)
              .toList();
        case SortType.domainDec:
          return widget._data
              .chainSort((lv, rv) => rv.domain.compareTo(lv.domain))
              .mapIndexed(_convertToRowData)
              .toList();
        case SortType.none:
          return widget._data
              .mapIndexed(_convertToRowData)
              .toList();
      }

      throw FallThroughError();
    });
  }
}

class _ColumnFutureBuilder extends StatelessWidget {
  const _ColumnFutureBuilder({
    Key key,
    @required Future<List<_RowData>> sortedRowDatas,
    @required bool showColors,
  })  : _sortedRowDatas = sortedRowDatas, _showColors = showColors,
        super(key: key);

  final Future<List<_RowData>> _sortedRowDatas;
  final bool _showColors;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _sortedRowDatas,
      builder: (context, AsyncSnapshot<List<_RowData>> snapshot) {
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
            ...snapshot.data.map((it) => _Row(rowData: it, showColors: _showColors,)).toList(),
          ],
        );
      },
    );
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
    return TextButton(
      onPressed: _onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            _title,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: AppColors.kTextMinor),
          ),
          _icon,
        ],
      ),
    );
  }
}

class _SortingDomain extends StatelessWidget {
  const _SortingDomain({
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
    return TextButton(
      onPressed: _onTap,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _icon,
          Expanded(
            child: Text(
              _title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: AppColors.kTextMinor),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final _RowData _rowData;
  final bool _showColors;

  const _Row({Key key, @required _RowData rowData, @required bool showColors})
      : assert(rowData != null),
        _rowData = rowData,
        _showColors = showColors,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ((_rowData.index % 2 == 0)
          ? Colors.transparent
          : AppColors.kGrayLight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0,),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _showColors  ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(1.0)),
                        color: _rowData.color,
                      ),
                      height: 8.0,
                      width: 8.0,
                    ),
                  ) : Container(),
                  Expanded(
                    child: Text(
                      _rowData.domain,
                      style: Theme.of(context).textTheme.subtitle1,
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
                      style: Theme.of(context).textTheme.subtitle1,
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
  final Color color;

  _RowData({
    @required this.domain,
    @required this.measure,
    @required this.index,
    @required this.color,
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
      color: AppColors.kTextMinor,
    );
    const upIcon = const Icon(
      Icons.expand_less,
      color: AppColors.kTextMinor,
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
