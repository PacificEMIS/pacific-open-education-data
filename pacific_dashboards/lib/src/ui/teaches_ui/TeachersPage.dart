import 'package:flutter/material.dart';
import '../../models/TeacherModel.dart';
import '../../models/TeachersModel.dart';
import '../../blocs/TeachersBloc.dart';
import '../../utils/HexColor.dart';
import '../BaseTileWidget.dart';
import '../ChartFactory.dart';
import '../ChartInfoTable.dart';

class TeachersPage extends StatefulWidget {
  final TeachersBloc bloc;

  TeachersPage({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TeachersPageState();
  }
}

class TeachersPageState extends State<TeachersPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Teachers",
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: "Noto Sans",
          ),
        ),
      ),
      body: StreamBuilder(
        stream: widget.bloc.data,
        builder: (context, AsyncSnapshot<TeachersModel> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildList(snapshot),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildList(AsyncSnapshot<TeachersModel> snapshot) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
              subtitle: _generateGridTile(snapshot.data, index),
            );
          },
        );
      },
    );
  }

  Widget _generateGridTile(TeachersModel data, int index) {
    switch (index) {
      case 0:
        return BaseTileWidget(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Teachers by Authority",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    fontFamily: "Noto Sans",
                    letterSpacing: 0.25,
                    fontStyle: FontStyle.normal,
                    color: HexColor("#132826"),
                  ),
                ),
                InkResponse(
                  child: Icon(
                    Icons.tune,
                    color: HexColor("#132826"),
                  ),
                  onTap: () => {},
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                ChartFactory.getPieChartViewByData(data.getSortedByAuthority()),
                ChartInfoTable<TeacherModel>(data.getSortedByAuthority(), "Authority", "Teachers"),
              ],
            ));

        break;
      case 1:
        return BaseTileWidget(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Schools Enrollment Govt / Non-govt",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    fontFamily: "Noto Sans",
                    letterSpacing: 0.25,
                    fontStyle: FontStyle.normal,
                    color: HexColor("#132826"),
                  ),
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                ChartFactory.getPieChartViewByData(data.getSortedByGovt()),
                ChartInfoTable<TeacherModel>(data.getSortedByGovt(), "Public/Private", "Teachers"),
              ],
            ));
        break;
      default:
        return BaseTileWidget(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Teachers by State",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    fontFamily: "Noto Sans",
                    letterSpacing: 0.25,
                    fontStyle: FontStyle.normal,
                    color: HexColor("#132826"),
                  ),
                ),
                InkResponse(
                  child: Icon(
                    Icons.tune,
                    color: HexColor("#132826"),
                  ),
                  onTap: () => {},
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                ChartFactory.getBarChartViewByData(data.getSortedByState()),
                ChartInfoTable<TeacherModel>(data.getSortedByState(), "State", "Teachers"),
              ],
            ));
    }
  }
}
