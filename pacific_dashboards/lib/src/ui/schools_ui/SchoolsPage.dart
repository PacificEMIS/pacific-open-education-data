import 'package:flutter/material.dart';
import '../../config/Constants.dart';
import '../../models/SchoolModel.dart';
import '../../models/SchoolsModel.dart';
import '../../blocs/SchoolsBloc.dart';
import '../BaseTileWidget.dart';
import '../ChartFactory.dart';
import '../ChartInfoTable.dart';
import '../FilterPage.dart';
import '../FilterWidget.dart';
import '../InfoTable.dart';
import '../PlatformAppBar.dart';
import '../TitleWidget.dart';
import '../../blocs/FilterBloc.dart';

class SchoolsPage extends StatefulWidget {
  static const String _kPageName = "Schools";
  static const String _measureName = "Schools Enrollment";

  final SchoolsBloc bloc;

  final Color _filterIconColor = AppColors.kWhite;

  final Widget _dividerWidget = Divider(
    height: 16.0,
    color: Colors.white,
  );

  SchoolsModel d = null;

  Function barF;

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
              color: widget._filterIconColor,
            ),
            onPressed: () {
              _createFilterPageRoute(context);
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

  void _createFilterPageRoute(BuildContext context) {
    if (widget.d != null) {
      var maxYear = () {
        var m = "0";
        widget.d.yearFilter.getFilter().forEach((k, v) {
          if (int.parse(k) > int.parse(m)) {
            m = k;
          }
        });

        return m;
      };

      List<FilterBloc> filterBlocsList = List<FilterBloc>();
      filterBlocsList.add(FilterBloc(filter: widget.d.yearFilter, defaultSelectedKey: maxYear()));
      filterBlocsList.add(FilterBloc(filter: widget.d.stateFilter, defaultSelectedKey: 'Display All States'));
      filterBlocsList.add(FilterBloc(filter: widget.d.authorityFilter, defaultSelectedKey: 'Display All Authority'));
      filterBlocsList.add(FilterBloc(filter: widget.d.govtFilter, defaultSelectedKey: 'Display all Govermant filters'));

      debugPrint('route created');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return FilterPage(blocs: filterBlocsList);
        }),
      );
    }
  }

  Widget _buildList(AsyncSnapshot<SchoolsModel> snapshot) {
    widget.d = snapshot.data;

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
            title: TitleWidget("Schools Enrollment by State", AppColors.kRacingGreen),
            body: Column(
              children: <Widget>[
                ChartFactory.getBarChartViewByData(_generateMapOfSum(data.getSortedByState())),
                widget._dividerWidget,
                ChartInfoTable<SchoolModel>(data.getSortedByState().keys.toList(), _generateMapOfSum(data.getSortedWithFiltersByState()),
                    "State", SchoolsPage._measureName, data.stateFilter.selectedKey),
              ],
            ));
        break;
      case 1:
        return BaseTileWidget(
            title: TitleWidget("Schools Enrollment by Authority", AppColors.kRacingGreen),
            body: Column(
              children: <Widget>[
                ChartFactory.getPieChartViewByData(_generateMapOfSum(data.getSortedByAuthority())),
                widget._dividerWidget,
                ChartInfoTable<SchoolModel>(
                    data.getSortedByAuthority().keys.toList(),
                    _generateMapOfSum(data.getSortedWithFiltersByAuthority()),
                    "Authority",
                    SchoolsPage._measureName,
                    data.authorityFilter.selectedKey),
              ],
            ));
        break;
      case 2:
        return BaseTileWidget(
            title: TitleWidget("Schools Enrollment Govt / \nNon-govt", AppColors.kRacingGreen),
            body: Column(
              children: <Widget>[
                ChartFactory.getPieChartViewByData(_generateMapOfSum(data.getSortedByGovt())),
                widget._dividerWidget,
                ChartInfoTable<SchoolModel>(data.getSortedByGovt().keys.toList(), _generateMapOfSum(data.getSortedWithFiltersByGovt()),
                    "Public/Private", SchoolsPage._measureName, data.govtFilter.selectedKey),
              ],
            ));
        break;
      case 3:
        var statesKeys = ['Early Childhood', 'Primary', 'Secondary', 'Post Secondary'];
        List<Widget> widgets = List<Widget>();

        widgets.add(InfoTable<SchoolModel>(data.getSortedByAge(0), "Total", "Age"));

        for (var i = 0; i < statesKeys.length; ++i) {
          widgets.add(widget._dividerWidget);
          widgets.add(InfoTable<SchoolModel>(data.getSortedByAge(i + 1), statesKeys[i], "Age"));
        }

        return BaseTileWidget(
            title:
                TitleWidget("Schools Enrollment by Age, Education Level \nand Gender", AppColors.kRacingGreen),
            body: Column(
              children: widgets,
            ));
        break;
      default:
        var statesKeys = data.getDistrictCodeKeysList();
        List<Widget> widgets = List<Widget>();

        widgets.add(InfoTable<SchoolModel>(data.getSortedWithFilteringBySchoolType(), "Total", "School \nType"));

        for (var i = 0; i < statesKeys.length; ++i) {
          widgets.add(widget._dividerWidget);
          widgets.add(InfoTable<SchoolModel>.subTable(data.getSortedWithFilteringBySchoolType(), statesKeys[i], "School \nType"));
        }

        return BaseTileWidget(
            title: TitleWidget(
                "Schools Enrollment by School type, State and \nGender",
                AppColors.kRacingGreen),
            body: Column(
              children: widgets,
            ));
        break;
    }
  }

  static Map<dynamic, int> _generateMapOfSum(Map<dynamic, List<SchoolModel>> listMap) {
    Map<dynamic, int> countMap = new Map<dynamic, int>();
    int sum = 0;

    listMap.forEach((k, v) {
      sum = 0;

      listMap[k].forEach((school) {
        sum += school.enrolF + school.enrolM;
      });

      countMap[k] = sum;
    });

    return countMap;
  }
}
