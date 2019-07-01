import 'package:flutter/material.dart';

class ChartInfoTable extends StatelessWidget {
  final Map<String, int> data;
  final String titleName;
  final String titleValue;

  ChartInfoTable(this.data, this.titleName, this.titleValue);

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            Text(''),
          ]
        ),
      ],
    );
  }

}