import 'package:flutter/material.dart';

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
    return GridView.builder(
      itemCount: snapshot.data.teachers.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
          child: InkResponse(
            enableFeedback: true,
            child: generateChart(snapshot.data, index),
            onTap: () => {print('tap')},
          ),
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
}
