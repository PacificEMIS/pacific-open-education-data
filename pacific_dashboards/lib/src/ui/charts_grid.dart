import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../blocs/charts_bloc.dart';
import 'chart_factory.dart';
import '../models/chart_model.dart';

class ChartsGrid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChartsGridState();
  }
}

class ChartsGridState extends State<ChartsGrid> {

  @override
  void initState() {
    super.initState();
    bloc.fetchAllCharts();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: bloc.allCharts,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            return buildGrid(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(
            child: CircularProgressIndicator(
              //valueColor: Colors.blueGrey[400],
            ),
          );
        },
    );
  }

  Widget buildGrid(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data.charts.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
          child: InkResponse(
            enableFeedback: true,
            child: ChartFactory.getChartViewByData(snapshot.data.charts[index]),
            onTap: () => { print('tap') },
          ),
        );
      },
    );
  }

  openDetailPage(ChartModel data, ) {
//    Navigator.push(context,
//    MaterialPageRoute(builder: (context) {
//      return ChartDetailBlocProvider(
//        child: ChartDetail(
//          title: data.chartName,
//          series: data.series,
//          type: data.chartType,
//        ),
//      );
//    }
//    )
//    ),
  }
}
