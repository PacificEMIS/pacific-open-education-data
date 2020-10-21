import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pacific_dashboards/shared_ui/tile_widget.dart';

import 'multi_table_widget.dart';

class MultiTable extends StatelessWidget {
  const MultiTable({
    Key key,
    String title,
    @required List<String> columnNames,
    @required List<int> columnFlex,
    @required Map<String, Map<String, dynamic>> data,
    KeySortFunc keySortFunc,
  })  :
        assert(columnNames != null),
        assert(columnFlex != null),
        assert(data != null),
        _title = title,
        _columnNames = columnNames,
        _columnFlex = columnFlex,
        _data = data,
        _keySortFunc = keySortFunc,
        super(key: key);

  final String _title;
  final List<String> _columnNames;
  final List<int> _columnFlex;
  final Map<String, Map<String, dynamic>> _data;
  final KeySortFunc _keySortFunc;

  @override
  Widget build(BuildContext context) {
    return TileWidget(
      title: _title == null ? Container() : Text(
        _title,
        style: Theme.of(context).textTheme.headline4,
      ),
      body: Column(
        children: _data.keys.map((key) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: MultiTableWidget(
              data: _data[key],
              columnNames: _columnNames,
              columnFlex: _columnFlex,
              title: key,
              keySortFunc: _keySortFunc,
            ),
          );
        }).toList(),
      ),
    );
  }
}
