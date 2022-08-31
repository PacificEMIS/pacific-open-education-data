import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/tables/chart_info_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/tile_widget.dart';

class ChartWithTable extends StatelessWidget {
  const ChartWithTable({
    Key key,
    @required String title,
    @required List<ChartData> data,
    @required ChartType chartType,
    @required String tableKeyName,
    @required String tableValueName,
    bool showColors,
  })  : assert(title != null),
        assert(data != null),
        assert(chartType != null),
        assert(tableKeyName != null),
        assert(tableValueName != null),
        _title = title,
        _data = data,
        _chartType = chartType,
        _tableKeyName = tableKeyName,
        _tableValueName = tableValueName,
        _showColors = showColors ?? true,
        super(key: key);

  final String _title;
  final List<ChartData> _data;
  final ChartType _chartType;
  final String _tableKeyName;
  final String _tableValueName;
  final bool _showColors;
  @override
  Widget build(BuildContext context) {
    if (_title.isEmpty)
      return ChartColumn(
        chartType: _chartType,
        data: _data,
        tableKeyName: _tableKeyName,
        tableValueName: _tableValueName,
        showColors: _showColors,
      );

    return TileWidget(
      title: Text(
        _title,
        style: Theme.of(context).textTheme.headline4,
      ),
      body: ChartColumn(
        chartType: _chartType,
        data: _data,
        tableKeyName: _tableKeyName,
        tableValueName: _tableValueName,
        showColors: _showColors,
      ),
    );
  }
}

class ChartColumn extends StatelessWidget {
  const ChartColumn({
    Key key,
    @required ChartType chartType,
    @required List<ChartData> data,
    @required String tableKeyName,
    @required String tableValueName,
    @required bool showColors,
  })  : _chartType = chartType,
        _data = data,
        _tableKeyName = tableKeyName,
        _tableValueName = tableValueName,
        _showColors = showColors,
        super(key: key);

  final ChartType _chartType;
  final List<ChartData> _data;
  final String _tableKeyName;
  final String _tableValueName;
  final bool _showColors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ChartFactory.createChart(_chartType, _data),
        const SizedBox(height: 16),
        ChartInfoTableWidget(
          _data,
          _tableKeyName,
          _tableValueName,
          _showColors
        ),
      ],
    );
  }
}
