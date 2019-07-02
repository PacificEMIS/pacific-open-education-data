import 'package:flutter/material.dart';
import '../utils/HexColor.dart';

class ChartInfoTable<T> extends StatelessWidget {
  static const String TABLE_BORDER_COLOR = "#DBE0E4";

  final Map<dynamic, List<T>> _data;
  final String _titleName;
  final String _titleValue;

  ChartInfoTable(this._data, this._titleName, this._titleValue);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          width: 1.0,
          color: HexColor(TABLE_BORDER_COLOR),
        ),
        top: BorderSide(
          width: 1.0,
          color: HexColor(TABLE_BORDER_COLOR),
        ),
        right: BorderSide(
          width: 1.0,
          color: HexColor(TABLE_BORDER_COLOR),
        ),
        left: BorderSide(
          width: 1.0,
          color: HexColor(TABLE_BORDER_COLOR),
        ),
        bottom: BorderSide(
          width: 1.0,
          color: HexColor(TABLE_BORDER_COLOR),
        ),
      ),
      children: _generateSubList(_data),
    );
  }

  List<TableRow> _generateSubList(Map<dynamic, List<T>> data) {
    var rowsList = List<TableRow>();
    var dataMap = Map<String, int>();
    data.forEach((k, v) {
      dataMap[k] = v.length;
    });

    rowsList.add(
      TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  Text(
                    _titleName,
                    style: TextStyle(
                      color: HexColor("#132826"),
                    ),
                  ),
                  InkResponse(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: HexColor("#33373D"),
                    ),
                    onTap: () => {},
                    highlightShape: BoxShape.rectangle,
                  ),
                ],
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    _titleValue,
                    style: TextStyle(
                      color: HexColor("#132826"),
                    ),
                  ),
                  InkResponse(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: HexColor("#33373D"),
                    ),
                    onTap: () => {},
                    highlightShape: BoxShape.rectangle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    dataMap.forEach((domain, measure) {
      rowsList.add(TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(1.0)),
                        color: HexColor.fromStringHash(domain),
                      ),
                      height: 8.0,
                      width: 8.0,
                    ),
                  ),
                  Text(
                    domain,
                    style: TextStyle(
                      color: HexColor("#132826"),
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    measure.toString(),
                    style: TextStyle(
                      color: HexColor("#132826"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
    });
    return rowsList;
  }
}
