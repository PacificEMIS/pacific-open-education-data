import 'dart:math';

import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../utils/hex_color_converter.dart' show HexColor;

class BarChartView extends StatefulWidget {
  final data;
  final title;

  BarChartView({Key key, this.title, this.data}) : super(key: key);

  @override
  BarChartViewState createState() => new BarChartViewState();
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class BarChartViewState extends State<BarChartView> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ClicksPerYear> data = [];
    for (var i = 0; i < widget.data.series.length; ++i) {
      data.add(new ClicksPerYear(widget.data.series[i].year,
          widget.data.series[i].clicks, HexColor(widget.data.series[i].color)));
    }

    var series = [
      new charts.Series(
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks + _counter,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        id: "${widget.data.chartName} + 1",
        data: data,
      ),
    ];

    //var chart = new charts.BarChart(
    return new charts.BarChart(
      series,
      animate: true,

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 8, // size in Pts.
                  color: charts.MaterialPalette.white),
              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.blue.shadeDefault))),

      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
            // Tick and Label styling here.
            labelStyle: new charts.TextStyleSpec(
                fontSize: 12, // size in Pts.
                color: charts.MaterialPalette.deepOrange.shadeDefault),
            // Change the line colors to match text color.
            lineStyle: new charts.LineStyleSpec(
                color: charts.MaterialPalette.green.shadeDefault)),
      ),
    );

//    var chartWidget = new Padding(
//      padding: new EdgeInsets.all(5.0),
//      child: new SizedBox(
//        height: 60.0,
//        width: 150.0,
//        child: chart,
//      ),
//    );
//
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
