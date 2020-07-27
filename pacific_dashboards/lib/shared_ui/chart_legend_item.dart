import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/themes.dart';

class ChartLegendItem extends StatelessWidget {
  final Color _color;
  final String _value;

  const ChartLegendItem({
    Key key,
    @required Color color,
    @required String value,
  })  : assert(color != null),
        assert(value != null),
        _color = color,
        _value = value,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: _color,
          ),
        ),
        SizedBox(
          width: 6,
        ),
        Text(
          _value,
          style: Theme.of(context).textTheme.chartLegend,
        )
      ],
    );
  }
}
