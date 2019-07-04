import 'package:flutter/material.dart';
import '../../config/Constants.dart';
import '../../models/TeacherModel.dart';
import '../../models/TeachersModel.dart';
import '../../blocs/TeachersBloc.dart';
import '../../utils/HexColor.dart';
import '../BaseTileWidget.dart';
import '../ChartFactory.dart';
import '../ChartInfoTable.dart';
import '../InfoTable.dart';
import '../TitleWidget.dart';

class TeachersPage extends StatefulWidget {
  final TeachersBloc bloc;

  final Widget _dividerWidget =  Divider(
    height: 16.0,
    color: Colors.white,
  );

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
          itemCount: 4,
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
            title: TitleWidget.withFilter("Teachers by Authority", HexColor(kTitleTextColor)),
            body: Column(
              children: <Widget>[
                ChartFactory.getPieChartViewByData(data.getSortedByAuthority()),
                widget._dividerWidget,
                ChartInfoTable<TeacherModel>(data.getSortedByAuthority(), "Authority", "Teachers"),
              ],
            ));

        break;
      case 1:
        return BaseTileWidget(
            title: TitleWidget("Schools Enrollment Govt / \nNon-govt", HexColor(kTitleTextColor)),
            body: Column(
              children: <Widget>[
                ChartFactory.getPieChartViewByData(data.getSortedByGovt()),
                widget._dividerWidget,
                ChartInfoTable<TeacherModel>(data.getSortedByGovt(), "Public/Private", "Teachers"),
              ],
            ));
        break;
      case 2:
        return BaseTileWidget(
            title: TitleWidget.withFilter("Teachers by State", HexColor(kTitleTextColor)),
            body: Column(
              children: <Widget>[
                ChartFactory.getBarChartViewByData(data.getSortedByState()),
                widget._dividerWidget,
                ChartInfoTable<TeacherModel>(data.getSortedByState(), "State", "Teachers"),
              ],
            ));
        break;
      default:
        var statesKeys = data.getDistrictCodeKeysList();
        List<Widget> widgets = List<Widget>();
        widgets.add(InfoTable<TeacherModel>(data.getSortedBySchoolType(), "Total"));
        for (var i = 0; i < statesKeys.length; ++i) {
          widgets.add(widget._dividerWidget);
          widgets.add(InfoTable<TeacherModel>.subTable(data.getSortedBySchoolType(), statesKeys[i]));
        }

        return BaseTileWidget(
            title: TitleWidget.withFilter("Teachers by School type, State and \nGender", HexColor(kTitleTextColor)),
            body: Column(
              children: widgets,
            ));
        break;
    }
  }
}
