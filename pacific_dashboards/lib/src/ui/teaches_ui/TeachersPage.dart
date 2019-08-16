import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/utils/Localizations.dart';
import '../../blocs/FilterBloc.dart';
import '../../config/Constants.dart';
import '../../models/TeacherModel.dart';
import '../../models/TeachersModel.dart';
import '../../blocs/TeachersBloc.dart';
import '../BaseTileWidget.dart';
import '../ChartFactory.dart';
import '../ChartInfoTable.dart';
import '../FilterPage.dart';
import '../InfoTable.dart';
import '../PlatformAppBar.dart';
import '../TitleWidget.dart';

class TeachersPage extends StatefulWidget {
  static String _kPageName = AppLocalizations.teachers;
  static String _measureName = AppLocalizations.teachers;

  final TeachersBloc bloc;

  final Color _filterIconColor = AppColors.kWhite;

  final Widget _dividerWidget = Divider(
    height: 16.0,
    color: Colors.white,
  );

  TeachersModel _dataLink = null;

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
    if (widget._dataLink != null) {
      List<FilterBloc> filterBlocsList = List<FilterBloc>();

      filterBlocsList.add(FilterBloc(
          filter: widget._dataLink.yearFilter,
          defaultSelectedKey: widget._dataLink.yearFilter.getMax()));
      filterBlocsList.add(FilterBloc(
          filter: widget._dataLink.stateFilter,
          defaultSelectedKey: AppLocalizations.dislplayAllStates));
      filterBlocsList.add(FilterBloc(
          filter: widget._dataLink.authorityFilter,
          defaultSelectedKey: AppLocalizations.displayAllAutority));
      filterBlocsList.add(FilterBloc(
          filter: widget._dataLink.govtFilter,
          defaultSelectedKey: AppLocalizations.displayAllGovermantFilters));
      filterBlocsList.add(FilterBloc(
          filter: widget._dataLink.schoolLevelFilter,
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
    widget._dataLink = snapshot.data;

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
          title: TitleWidget(AppLocalizations.teachersByAutority, AppColors.kRacingGreen),
          body: Column(
            children: <Widget>[
              ChartFactory.getPieChartViewByData(
                  _generateMapOfSum(data.getSortedByAuthority())),
              widget._dividerWidget,
              ChartInfoTable<TeacherModel>(
                  data.getSortedByAuthority().keys.toList(),
                  _generateMapOfSum(data.getSortedWithFiltersByAuthority()),
                  AppLocalizations.autority,
                  TeachersPage._measureName,
                  data.authorityFilter.selectedKey),
            ],
          ),
        );
        break;
      case 1:
        return BaseTileWidget(
          title: TitleWidget(
              AppLocalizations.schoolsEnrollmentGovtNonGovt, AppColors.kRacingGreen),
          body: Column(
            children: <Widget>[
              ChartFactory.getPieChartViewByData(
                  _generateMapOfSum(data.getSortedByGovt())),
              widget._dividerWidget,
              ChartInfoTable<TeacherModel>(
                  data.getSortedByGovt().keys.toList(),
                  _generateMapOfSum(data.getSortedWithFiltersByGovt()),
                  AppLocalizations.publicPrivate,
                  TeachersPage._measureName,
                  data.stateFilter.selectedKey),
            ],
          ),
        );
        break;
      case 2:
        return BaseTileWidget(
          title: TitleWidget(AppLocalizations.teachersByState, AppColors.kRacingGreen),
          body: Column(
            children: <Widget>[
              ChartFactory.getBarChartViewByData(
                  _generateMapOfSum(data.getSortedByState())),
              widget._dividerWidget,
              ChartInfoTable<TeacherModel>(
                  data.getSortedByState().keys.toList(),
                  _generateMapOfSum(data.getSortedWithFiltersByState()),
                  AppLocalizations.state,
                  TeachersPage._measureName,
                  data.stateFilter.selectedKey),
            ],
          ),
        );
        break;
      default:
        var statesKeys = data.getDistrictCodeKeysList();
        List<Widget> widgets = List<Widget>();

        widgets.add(InfoTable(
            _generateInfoTableData(
                data.getSortedWithFilteringBySchoolType(), AppLocalizations.total, false),
            AppLocalizations.total,
            AppLocalizations.schoolType));

        for (var i = 0; i < statesKeys.length; ++i) {
          widgets.add(widget._dividerWidget);
          widgets.add(InfoTable(
              _generateInfoTableData(data.getSortedWithFilteringBySchoolType(),
                  statesKeys[i], true),
              data.lookupsModel.getFullState(statesKeys[i]),
              AppLocalizations.schoolType));
        }

        return BaseTileWidget(
          title: TitleWidget(AppLocalizations.schoolsEnrollmentBySchoolTypeStateAndGender,
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

    convertedData[AppLocalizations.total] = InfoTableData(totalMaleCount, totalFemaleCount);

    return convertedData;
  }
}
