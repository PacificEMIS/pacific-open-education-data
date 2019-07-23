import 'package:flutter/material.dart';
import '../../config/Constants.dart';
import '../../models/SchoolModel.dart';
import '../../models/SchoolsModel.dart';
import '../../blocs/SchoolsBloc.dart';
import '../BaseTileWidget.dart';
import '../ChartFactory.dart';
import '../ChartInfoTable.dart';
import '../InfoTable.dart';
import '../PlatformAppBar.dart';
import '../TitleWidget.dart';

class SchoolsPage extends StatefulWidget {
  static const String _kPageName = "Schools";
  static const String _measureName = "Schools Enrollment";

  final SchoolsBloc bloc;

  final Widget _dividerWidget = Divider(
    height: 16.0,
    color: Colors.white,
  );

  SchoolsPage({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SchoolsPageState();
  }
}

class SchoolsPageState extends State<SchoolsPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.fetchData();
  }

  @override
  void dispose() {
    debugPrint("disposing");
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppBar(
        iconTheme: new IconThemeData(color: AppColors.kWhite),
        backgroundColor: AppColors.kDenim,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.tune,
            ),
            onPressed: () => {
//              Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => FilterPage(bloc : FilterBloc(filter: _filter), )),
//            )
            },
          ),
        ],
        title: Text(
          SchoolsPage._kPageName,
          style: TextStyle(
            color: AppColors.kWhite,
            fontSize: 18.0,
            fontFamily: "Noto Sans",
          ),
        ),
      ),
      body: StreamBuilder(
        stream: widget.bloc.data,
        builder: (context, AsyncSnapshot<SchoolsModel> snapshot) {
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

  Widget _buildList(AsyncSnapshot<SchoolsModel> snapshot) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return ListView.builder(
          itemCount: 5,
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

  Widget _generateGridTile(SchoolsModel data, int index) {
    switch (index) {
      case 0:
        return BaseTileWidget(
            title: TitleWidget.withFilter(
                "Schools Enrollment by State", AppColors.kRacingGreen, data.stateFilter),
            body: Column(
              children: <Widget>[
                ChartFactory.getBarChartViewByData(_getCountFromList(data.getSortedByState())),
                widget._dividerWidget,
                ChartInfoTable<SchoolModel>(_getCountFromList(data.getSortedByState()), "State",
                    SchoolsPage._measureName),
              ],
            ));
        break;
      case 1:
        return BaseTileWidget(
            title: TitleWidget.withFilter("Schools Enrollment by Authority",
                AppColors.kRacingGreen, data.authorityFilter),
            body: Column(
              children: <Widget>[
                ChartFactory.getPieChartViewByData(_getCountFromList(data.getSortedByAuthority())),
                widget._dividerWidget,
                ChartInfoTable<SchoolModel>(_getCountFromList(data.getSortedByAuthority()),
                    "Authority", SchoolsPage._measureName),
              ],
            ));

        break;
      case 2:
        return BaseTileWidget(
            title: TitleWidget(
                "Schools Enrollment Govt / \nNon-govt", AppColors.kRacingGreen),
            body: Column(
              children: <Widget>[
                ChartFactory.getPieChartViewByData(_getCountFromList(data.getSortedByGovt())),
                widget._dividerWidget,
                ChartInfoTable<SchoolModel>(_getCountFromList(data.getSortedByGovt()),
                    "Public/Private", SchoolsPage._measureName),
              ],
            ));
        break;
      case 3:
        var statesKeys = ['Early Childhood', 'Primary', 'Secondary', 'Post Secondary'];
        List<Widget> widgets = List<Widget>();

        widgets.add(InfoTable<SchoolModel>(
            data.getSortedByAge(0), "Total", "Age"));

        for (var i = 0; i < statesKeys.length; ++i) {
          widgets.add(widget._dividerWidget);
          widgets.add(InfoTable<SchoolModel>(
              data.getSortedByAge(i + 1), statesKeys[i], "Age"));
        }

        return BaseTileWidget(
            title: TitleWidget.withFilter(
                "Schools Enrollment by Age, Education Level \nand Gender",
                AppColors.kRacingGreen,
                data.ageFilter),
            body: Column(
              children: widgets,
            ));
        break;
      default:
        var statesKeys = data.getDistrictCodeKeysList();
        List<Widget> widgets = List<Widget>();

        widgets.add(InfoTable<SchoolModel>(
            data.getSortedBySchoolType(), "Total", "School \nType"));

        for (var i = 0; i < statesKeys.length; ++i) {
          widgets.add(widget._dividerWidget);
          widgets.add(InfoTable<SchoolModel>.subTable(
              data.getSortedBySchoolType(), statesKeys[i], "School \nType"));
        }

        return BaseTileWidget(
            title: TitleWidget.withFilter(
                "Schools Enrollment by School type, State and \nGender",
                AppColors.kRacingGreen,
                data.schoolTypeFilter),
            body: Column(
              children: widgets,
            ));
        break;
    }
  }

  static Map<dynamic, int> _getCountFromList(Map<dynamic, List<SchoolModel>> listMap) {
    Map<dynamic, int> countMap = new Map<dynamic, int>();
    int sum = 0;
    listMap.forEach((k, v) =>{
      sum = 0,
      listMap[k].forEach((teacher){sum += teacher.numTeachersM + teacher.numTeachersF;}),
      countMap[k] = sum
    });
    return countMap;
  }
}
