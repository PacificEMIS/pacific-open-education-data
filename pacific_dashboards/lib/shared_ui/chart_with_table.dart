import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/chart_info_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/tile_widget.dart';

class ChartWithTable extends StatelessWidget {
  const ChartWithTable({
    Key key,
    @required String title,
    @required Map<String, int> data,
    @required ChartType chartType,
    @required String tableKeyName,
    @required String tableValueName,
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
        super(key: key);

  final String _title;
  final Map<String, int> _data;
  final ChartType _chartType;
  final String _tableKeyName;
  final String _tableValueName;

  @override
  Widget build(BuildContext context) {
    if (_title.isEmpty) return Column(
      children: <Widget>[
        ChartFactory.createChart(_chartType, _data),
        const SizedBox(height: 16),
        ChartInfoTableWidget(
          _data,
          _tableKeyName,
          _tableValueName,
        ),
      ],
    );

    return TileWidget(
      title: Text(
        _title,
        style: Theme.of(context).textTheme.headline4,
      ),
      body: Column(
        children: <Widget>[
          ChartFactory.createChart(_chartType, _data),
          const SizedBox(height: 16),
          ChartInfoTableWidget(
            _data,
            _tableKeyName,
            _tableValueName,
          ),
        ],
      ),
    );
  }
}
