import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/teachers_model.dart';
import '../blocs/teachers_bloc.dart';
import 'chart_factory.dart';

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
    bloc.fetchAllTeachers();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allTeachers,
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
          gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: getTilesAmountInRowByScreenSize(orientation)),
          itemBuilder: (BuildContext context, int index) {
            return GridTile(
              child: InkResponse(
                enableFeedback: true,
                child: generateChart(snapshot.data, index),
                onTap: () => { print('tap') },
              ),
            );
          },
        );
      },
    );
  }

  Widget generateChart(TeachersModel data, int index) {
    if (index == 0) {
      return ChartFactory.getBarChartViewByData(data.getEnrollmentByState());
    } else if (index == 1) {
      return ChartFactory.getPieChartViewByData(data.getEnrollmentByGovt());
    } else {
      return ChartFactory.getPieChartViewByData(
          data.getEnrollmentByAuthority());
    }
  }

  int getTilesAmountInRowByScreenSize(Orientation orientation) {
    var isLandscape = orientation == Orientation.landscape;
    var screenWidth = ScreenUtil.getInstance().width;
    if (isLandscape) {
      if ( screenWidth > 1920 ) {
        return 3;
      }

      return 2;
    } else {
      if ( screenWidth > 1080 ) {
        return 2;
      }

      return 1;
    }
  }
}
