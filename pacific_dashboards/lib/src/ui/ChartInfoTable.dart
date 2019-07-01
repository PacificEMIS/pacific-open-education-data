import 'package:flutter/material.dart';
import '../utils/HexColor.dart';

class ChartInfoTable<T> extends StatelessWidget {
  final Map<dynamic, List<T>> _data;
  final String _titleName;
  final String _titleValue;

  ChartInfoTable(this._data, this._titleName, this._titleValue);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: _generateSubList(_data),
    );
  }

  List<TableRow> _generateSubList(Map<dynamic, List<T>> data) {
    var l = List<TableRow>();
    var map = Map<String, int>();
    data.forEach((k, v) {
      map[k] = v.length;
    });

    l.add(
      TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  Text(_titleName),
                  InkResponse(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: HexColor("#33373D"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  Text(_titleValue),
                  InkResponse(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: HexColor("#33373D"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    map.forEach((k, v) {
      l.add(TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 8.0,
                    width: 8.0,
                    color: HexColor.fromStringHash(k),
                  ),
                  Text(k),
                ],
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: Text(v.toString()),
            ),
          ),
        ],
      ));
    });

    return l;
  }
}
