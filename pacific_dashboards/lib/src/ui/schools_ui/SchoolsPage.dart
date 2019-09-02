import 'package:flutter/material.dart';
import 'package:pacific_dashboards/src/utils/Localizations.dart';
import '../../config/Constants.dart';
import '../../models/SchoolModel.dart';
import '../../models/SchoolsModel.dart';
import '../../blocs/SchoolsBloc.dart';
import '../BaseTileWidget.dart';
import '../ChartFactory.dart';
import '../ChartInfoTable.dart';
import '../FilterPage.dart';
import '../InfoTable.dart';
import '../PlatformAppBar.dart';
import '../TitleWidget.dart';
import '../../blocs/FilterBloc.dart';

class SchoolsPage extends StatefulWidget {
  static String _kPageName = AppLocalizations.schools;
  static String _measureName = AppLocalizations.schoolsEnrollment;

  final SchoolsBloc bloc;

  final Color _filterIconColor = AppColors.kWhite;

  final Widget _dividerWidget = Divider(
    height: 16.0,
    color: Colors.white,
  );

  SchoolsModel _dataLink = null;

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
    if (widget._dataLink != null) {
      List<FilterBloc> filterBlocsList = List<FilterBloc>();

      filterBlocsList.add(FilterBloc(
          filter: widget._dataLink.yearFilter,
          defaultSelectedKey: widget._dataLink.yearFilter.getMax()));
      filterBlocsList.add(FilterBloc(
          filter: widget._dataLink.stateFilter,
          defaultSelectedKey: AppLocalizations.displayAllStates));
      filterBlocsList.add(FilterBloc(
          filter: widget._dataLink.authorityFilter,
          defaultSelectedKey: AppLocalizations.displayAllAuthority));
      filterBlocsList.add(FilterBloc(
          filter: widget._dataLink.govtFilter,
          defaultSelectedKey: AppLocalizations.displayAllGovernment));
      filterBlocsList.add(FilterBloc(
          filter: widget._dataLink.schoolLevelFilter,
          defaultSelectedKey: AppLocalizations.displayAllLevelFilters));

      debugPrint('FilterPage route created');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return FilterPage(blocs: filterBlocsList);
        }),
      );
    }
  }

  Widget _buildList(AsyncSnapshot<SchoolsModel> snapshot) {
    widget._dataLink = snapshot.data;

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
            title: TitleWidget(
                AppLocalizations.schoolsEnrollmentByState, AppColors.kRacingGreen),
            body: Column(
              children: <Widget>[
                ChartFactory.getBarChartViewByData(
                    _generateMapOfSum(data.getSortedByState())),
                widget._dividerWidget,
                ChartInfoTable<SchoolModel>(
                    data.getSortedByState().keys.toList(),
                    _generateMapOfSum(data.getSortedWithFiltersByState()),
                    AppLocalizations.state,
                    SchoolsPage._measureName,
                    data.stateFilter.selectedKey),
              ],
            ));
        break;
      case 1:
        return BaseTileWidget(
            title: TitleWidget(
                AppLocalizations.schoolsEnrollmentByAuthority, AppColors.kRacingGreen),
            body: Column(
              children: <Widget>[
                ChartFactory.getPieChartViewByData(
                    _generateMapOfSum(data.getSortedByAuthority())),
                widget._dividerWidget,
                ChartInfoTable<SchoolModel>(
                    data.getSortedByAuthority().keys.toList(),
                    _generateMapOfSum(data.getSortedWithFiltersByAuthority()),
                    AppLocalizations.authority,
                    SchoolsPage._measureName,
                    data.authorityFilter.selectedKey),
              ],
            ));
        break;
      case 2:
        return BaseTileWidget(
            title: TitleWidget(
                AppLocalizations.schoolsEnrollmentGovtNonGovt, AppColors.kRacingGreen),
            body: Column(
              children: <Widget>[
                ChartFactory.getPieChartViewByData(
                    _generateMapOfSum(data.getSortedByGovt())),
                widget._dividerWidget,
                ChartInfoTable<SchoolModel>(
                    data.getSortedByGovt().keys.toList(),
                    _generateMapOfSum(data.getSortedWithFiltersByGovt()),
                    AppLocalizations.publicPrivate,
                    SchoolsPage._measureName,
                    data.govtFilter.selectedKey),
              ],
            ));
        break;
      case 3:
        var statesKeys = [
          AppLocalizations.earlyChildhood,
          AppLocalizations.primary,
          AppLocalizations.secondary,
          AppLocalizations.postSecondary
        ];
        List<Widget> widgets = List<Widget>();

        widgets.add(InfoTable(
            _generateInfoTableData(data.getSortedByAge(0), AppLocalizations.total, false),
            AppLocalizations.total,
            AppLocalizations.age));

        for (var i = 0; i < statesKeys.length; ++i) {
          widgets.add(widget._dividerWidget);
          widgets.add(InfoTable(
              _generateInfoTableData(
                  data.getSortedByAge(i + 1), statesKeys[i], false),
              statesKeys[i],
              AppLocalizations.age));
        }

        return BaseTileWidget(
            title: TitleWidget(
                AppLocalizations.schoolsEnrollmentByAgeEducationLevel,
                AppColors.kRacingGreen),
            body: Column(
              children: widgets,
            ));
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
            title: TitleWidget(
                AppLocalizations.schoolsEnrollmentBySchoolTypeStateAndGender,
                AppColors.kRacingGreen),
            body: Column(
              children: widgets,
            ));
        break;
    }
  }

  Map<dynamic, int> _generateMapOfSum(Map<dynamic, List<SchoolModel>> listMap) {
    Map<dynamic, int> countMap = new Map<dynamic, int>();
    int sum = 0;

    listMap.forEach((k, v) {
      sum = 0;

      listMap[k].forEach((school) {
        sum += school.enrolFemale + school.enrolMale;
      });

      countMap[k] = sum;
    });

    return countMap;
  }

  Map<dynamic, InfoTableData> _generateInfoTableData(
      Map<dynamic, List<SchoolModel>> rawMapData,
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
          maleCount += model[j].enrolMale;
          femaleCount += model[j].enrolFemale;
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
