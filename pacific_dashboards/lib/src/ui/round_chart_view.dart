import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../utils/hex_color_converter.dart' show HexColor;

class RoundChartView extends StatefulWidget {
  //final List<charts.Series> seriesList;
  final bool animate;
  final data;

  RoundChartView({Key key, this.data, this.animate}) : super(key: key);

  @override
  RoundChartViewState createState() => new RoundChartViewState();
}

class RoundChartViewState extends State<RoundChartView> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<LinearSales> data = [];
    for (var i = 0; i < widget.data.series.length; ++i) {
      data.add(new LinearSales(widget.data.series[i].year,
          widget.data.series[i].sales, HexColor(widget.data.series[i].color)));
    }

    var series = [
      new charts.Series(
        id: "${widget.data.chartName} + 1",
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales + _counter,
        colorFn: (LinearSales sales, _) => sales.color,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      ),
    ];

    return new charts.PieChart(
      series,
      animate: true,
      // Configure the width of the pie slices to 60px. The remaining space in
      // the chart will be left as a hole in the center.
      //
      // [ArcLabelDecorator] will automatically position the label inside the
      // arc if the label will fit. If the label will not fit, it will draw
      // outside of the arc with a leader line. Labels can always display
      // inside or outside using [LabelPosition].
      //
      // Text style for inside / outside can be controlled independently by
      // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
      //
      // Example configuring different styles for inside/outside:
      //       new charts.ArcLabelDecorator(
      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
      defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 60,
          arcRendererDecorators: [new charts.ArcLabelDecorator()]),

      /// Assign a custom style for the measure axis.
    );

//    var chartWidget = new Padding(
//      padding: new EdgeInsets.all(5.0),
//      child: new SizedBox(
//        height: 150.0,
//        width: 150.0,
//        child: chart,
//      ),
//    );

//    return new Center(
//      child: new Column(
//        //mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          new Text(
//            '$_counter',
//            style: Theme.of(context).textTheme.display1,
//          ),
//          chartWidget,
//          new FloatingActionButton(
//            onPressed: _incrementCounter,
//            tooltip: 'Increment',
//            child: new Icon(Icons.add),
//          ),
//        ],
//      ),
//    );
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;
  final charts.Color color;

  LinearSales(this.year, this.sales, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
