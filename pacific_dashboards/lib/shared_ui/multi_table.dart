import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pacific_dashboards/shared_ui/gender_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/tile_widget.dart';

class MultiTable extends StatelessWidget {
  const MultiTable({
    Key key,
    @required String title,
    @required String firstColumnName,
    @required Map<String, Map<String, GenderTableData>> data,
    KeySortFunc keySortFunc,
  })  : assert(title != null),
        assert(firstColumnName != null),
        assert(data != null),
        _title = title,
        _firstColumnName = firstColumnName,
        _data = data,
        _keySortFunc = keySortFunc,
        super(key: key);

  final String _title;
  final String _firstColumnName;
  final Map<String, Map<String, GenderTableData>> _data;
  final KeySortFunc _keySortFunc;

  @override
  Widget build(BuildContext context) {
    return TileWidget(
        title: Text(
          _title,
          style: Theme.of(context).textTheme.headline4,
        ),
        body: Column(
          children: _data.keys.map((key) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GenderTableWidget(
                data: _data[key],
                title: key,
                firstColumnName: _firstColumnName,
                keySortFunc: _keySortFunc,
              ),
            );
          }).toList(),
        ));
  }
}
