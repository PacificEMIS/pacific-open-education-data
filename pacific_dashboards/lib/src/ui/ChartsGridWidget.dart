import 'package:flutter/material.dart';
import '../models/TeachersModel.dart';
import 'ChartFactory.dart';

class ChartsGridWidget extends StatefulWidget {
  final bloc;

  ChartsGridWidget({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChartsGridWidgetState();
  }
}

class ChartsGridWidgetState extends State<ChartsGridWidget> {
  @override
  void initState() {
    super.initState();
    widget.bloc.fetchData();
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.bloc.data,
      builder: (context, AsyncSnapshot<TeachersModel> snapshot) {
        if (snapshot.hasData) {
          return buildGrid(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget buildGrid(AsyncSnapshot<TeachersModel> snapshot) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.builder(
          padding: EdgeInsets.all(38.0),
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: getTilesAmountInRowByScreenSize(orientation)),
          itemBuilder: (BuildContext context, int index) {
            return GridTile(
              child: InkResponse(
                enableFeedback: true,
                child: generateChart(snapshot.data, index),
                onTap: () => print('tap'),
              ),
            );
          },
        );
      },
    );
  }

  Widget generateChart(TeachersModel data, int index) {
    switch (index) {
      case 0:
        return ChartFactory.getBarChartViewByData(data.getSortedByState());
        break;
      case 1:
        return ChartFactory.getPieChartViewByData(data.getSortedByGovt());
        break;
      default:
        return ChartFactory.getPieChartViewByData(data.getSortedByAuthority());
    }
  }

  int getTilesAmountInRowByScreenSize(Orientation orientation) {
    var isLandscape = orientation == Orientation.landscape;
    var screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
    if (isLandscape) {
      if (screenWidth > 700) {
        return 3;
      }

      return 2;
    } else {
      if (screenWidth > 600) {
        return 2;
      }

      return 1;
    }
  }
}
