import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/teacher_model.dart';
import 'package:pacific_dashboards/models/teachers_model.dart';
import 'package:pacific_dashboards/pages/filter/filter_bloc.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_bloc.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/chart_info_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/tile_widget.dart';
import 'package:pacific_dashboards/shared_ui/title_widget.dart';

class TeachersPage extends StatefulWidget {
  static String _kPageName = AppLocalizations.teachers;
  static String _measureName = AppLocalizations.teachers;

  final TeachersBloc bloc;

  final Color _filterIconColor = AppColors.kWhite;

  final Widget _dividerWidget = Divider(
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
  TeachersModel _dataLink;

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
      resizeToAvoidBottomPadding: true,
      appBar: PlatformAppBar(
        iconTheme: new IconThemeData(color: AppColors.kWhite),
        backgroundColor: AppColors.kAppBarBackground,
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
          TeachersPage._kPageName,
          style: TextStyle(
            color: AppColors.kWhite,
            fontSize: 18.0,
            fontFamily: "Noto Sans",
          ),
        ),
      ),
      body: StreamBuilder(
        stream: widget.bloc.data,
        builder: (context, AsyncSnapshot<TeachersModel> snapshot) {
          if (snapshot.hasData) {
            return _buildList(snapshot);
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
    if (_dataLink != null) {
      List<FilterBloc> filterBlocsList = List<FilterBloc>();

      filterBlocsList.add(FilterBloc(
          filter: _dataLink.yearFilter,
          defaultSelectedKey: _dataLink.yearFilter.getMax()));
      filterBlocsList.add(FilterBloc(
          filter: _dataLink.stateFilter,
          defaultSelectedKey: AppLocalizations.displayAllStates));
      filterBlocsList.add(FilterBloc(
          filter: _dataLink.authorityFilter,
          defaultSelectedKey: AppLocalizations.displayAllAuthority));
      filterBlocsList.add(FilterBloc(
          filter: _dataLink.govtFilter,
          defaultSelectedKey: AppLocalizations.displayAllGovernmentFilters));
      filterBlocsList.add(FilterBloc(
          filter: _dataLink.schoolLevelFilter,
          defaultSelectedKey: AppLocalizations.displayAllLevel));

      debugPrint('FilterPage route created');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return FilterPage(blocs: filterBlocsList);
        }),
      );
    }
  }

  Widget _buildList(AsyncSnapshot<TeachersModel> snapshot) {
    _dataLink = snapshot.data;

    return OrientationBuilder(
      builder: (context, orientation) {
        return ListView.builder(
          itemCount: 4,
          padding: EdgeInsets.all(16.0),
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
        return TileWidget(
          title: TitleWidget(
              AppLocalizations.teachersByAuthority, AppColors.kRacingGreen),
          body: Column(
            children: <Widget>[
              ChartFactory.createPieChartViewByData(
                  _generateMapOfSum(data.getSortedByAuthority())),
              widget._dividerWidget,
              ChartInfoTableWidget(
                  _generateMapOfSum(data.getSortedWithFiltersByAuthority()),
                  AppLocalizations.authority,
                  TeachersPage._measureName),
            ],
          ),
        );
        break;
      case 1:
        return TileWidget(
          title: TitleWidget(AppLocalizations.teachersEnrollmentGovtNonGovt,
              AppColors.kRacingGreen),
          body: Column(
            children: <Widget>[
              ChartFactory.createPieChartViewByData(
                  _generateMapOfSum(data.getSortedByGovt())),
              widget._dividerWidget,
              ChartInfoTableWidget(
                  _generateMapOfSum(data.getSortedWithFiltersByGovt()),
                  AppLocalizations.publicPrivate,
                  TeachersPage._measureName),
            ],
          ),
        );
        break;
      case 2:
        return TileWidget(
          title: TitleWidget(
              AppLocalizations.teachersByState, AppColors.kRacingGreen),
          body: Column(
            children: <Widget>[
              ChartFactory.createBarChartViewByData(
                  _generateMapOfSum(data.getSortedWithFiltersByState())),
              widget._dividerWidget,
              ChartInfoTableWidget(
                  _generateMapOfSum(data.getSortedWithFiltersByState()),
                  AppLocalizations.state,
                  TeachersPage._measureName),
            ],
          ),
        );
        break;
      default:
        final statesKeys = data.getDistrictCodeKeysList();
        List<Widget> widgets = List<Widget>();

        widgets.add(InfoTableWidget(
          data: _generateInfoTableData(
              data.getSortedWithFilteringBySchoolType(),
              AppLocalizations.total,
              false),
          title: AppLocalizations.total,
          firstColumnName: AppLocalizations.schoolLevels,
        ));

        for (var i = 0; i < statesKeys.length; ++i) {
          widgets.add(widget._dividerWidget);
          widgets.add(InfoTableWidget(
            data: _generateInfoTableData(
                data.getSortedWithFilteringBySchoolType(), statesKeys[i], true),
            title: data.lookupsModel.getFullState(statesKeys[i]),
            firstColumnName: AppLocalizations.schoolLevels,
          ));
        }

        return TileWidget(
          title: TitleWidget(AppLocalizations.teacherBySchoolTypeStateAndGender,
              AppColors.kRacingGreen),
          body: Column(
            children: widgets,
          ),
        );
        break;
    }
  }

  static Map<dynamic, int> _generateMapOfSum(
      Map<dynamic, List<TeacherModel>> listMap) {
    Map<dynamic, int> mapOfSum = new Map<dynamic, int>();
    int sum = 0;

    listMap.forEach((k, v) {
      sum = 0;

      listMap[k].forEach((school) {
        sum += school.numTeachersM + school.numTeachersF;
      });

      mapOfSum[k] = sum;
    });

    return mapOfSum;
  }

  Map<dynamic, InfoTableData> _generateInfoTableData(
      Map<dynamic, List<TeacherModel>> rawMapData,
      String keyName,
      bool isSubTitle) {
    var convertedData = Map<dynamic, InfoTableData>();
    var totalMaleCount = 0;
    var totalFemaleCount = 0;

    rawMapData.forEach((k, v) {
      var maleCount = 0;
      var femaleCount = 0;

      for (var j = 0; j < v.length; ++j) {
        var model = v;
        if (!isSubTitle ||
            (isSubTitle && (keyName == model[j].districtCode)) ||
            keyName == null) {
          maleCount += model[j].numTeachersM;
          femaleCount += model[j].numTeachersF;
        }
      }

      totalMaleCount += maleCount;
      totalFemaleCount += femaleCount;
      convertedData[k] = InfoTableData(maleCount, femaleCount);
    });

    convertedData[AppLocalizations.total] =
        InfoTableData(totalMaleCount, totalFemaleCount);

    return convertedData;
  }
}
