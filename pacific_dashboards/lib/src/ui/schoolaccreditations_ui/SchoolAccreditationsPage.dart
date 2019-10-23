import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/src/blocs/FilterBloc.dart';
import 'package:pacific_dashboards/src/blocs/SchoolAccreditationBloc.dart';
import 'package:pacific_dashboards/src/config/Constants.dart';
import 'package:pacific_dashboards/src/models/SchoolAccrediatationModel.dart';
import 'package:pacific_dashboards/src/models/SchoolAccreditationsModel.dart';
import 'package:pacific_dashboards/src/ui/BaseTileWidget.dart';
import 'package:pacific_dashboards/src/ui/FilterPage.dart';
import 'package:pacific_dashboards/src/ui/PlatformAppBar.dart';
import 'package:pacific_dashboards/src/ui/TitleWidget.dart';
import 'package:pacific_dashboards/src/utils/Localizations.dart';
import '../AccreditationTable.dart';
import '../ChartFactory.dart';
import '../ChartInfoTable.dart';
import '../StackedHorizontalBarChartAccreditations.dart';

class SchoolAccreditationsPage extends StatefulWidget {
  static String _kPageName = AppLocalizations.schoolAccreditations;
  static String _measureName = AppLocalizations.schoolAccreditations;

  final SchoolAccreditationBloc bloc;

  final Color _filterIconColor = AppColors.kWhite;

  final Widget _dividerWidget = Divider(
    height: 16.0,
    color: Colors.white,
  );

  SchoolAccreditationsPage({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SchoolsPageState();
  }
}

class SchoolsPageState extends State<SchoolAccreditationsPage> {
  SchoolAccreditationsModel _dataLink;

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
          SchoolAccreditationsPage._kPageName,
          style: TextStyle(
            color: AppColors.kWhite,
            fontSize: 18.0,
            fontFamily: "Noto Sans",
          ),
        ),
      ),
      body: StreamBuilder(
        stream: widget.bloc.data,
        builder: (context, AsyncSnapshot<SchoolAccreditationsModel> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildList(snapshot),
            );
          } else if (snapshot.hasError) {
            debugPrint("ERROR");
            return Text(snapshot.error.toString());
          } else
            debugPrint("No data");

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
          filter: _dataLink.govtFilter,
          defaultSelectedKey: AppLocalizations.displayAllGovernment));
      filterBlocsList.add(FilterBloc(
          filter: _dataLink.authorityFilter,
          defaultSelectedKey: AppLocalizations.displayAllAuthority));
      filterBlocsList.add(FilterBloc(
          filter: _dataLink.schoolLevelFilter,
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

  Widget _buildList(AsyncSnapshot<SchoolAccreditationsModel> snapshot) {
    _dataLink = snapshot.data;

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

  Widget _generateGridTile(SchoolAccreditationsModel data, int index) {
    var selectedYear = data.yearFilter.selectedKey;
    if (selectedYear == "") selectedYear = data.yearFilter.getMax();
    switch (index) {
      case 0:
        return BaseTileWidget(
            title: TitleWidget(
                AppLocalizations.accreditationProgress, AppColors.kRacingGreen),
            body: Column(
              children: <Widget>[
                ChartFactory.getHorizontalBarChartViewByData(
                    _generateMapOfSum(data.getSortedByYear())),
                widget._dividerWidget,
              ],
            ));
        break;
      case 1:
        return BaseTileWidget(
            title: TitleWidget(
                AppLocalizations.districtStatus, AppColors.kRacingGreen),
            body: Column(
              children: <Widget>[
                ChartFactory.getHorizontalBarChartViewByData(
                    _generateMapOfSum(data.getSortedByState())),
                widget._dividerWidget,
              ],
            ));
        break;
      case 2:
        List<Widget> widgets = List<Widget>();
        widgets.add(AccreditationTable(
            _generateAccreditationTableData(
                data.getSortedByStandart(), false, false, selectedYear),
            "Evaluated in $selectedYear",
            AppLocalizations.state));
        widgets.add(AccreditationTable(
            _generateAccreditationTableData(
                data.getSortedByStandart(), true, false, selectedYear),
            "Cumulative up to $selectedYear",
            AppLocalizations.state));
        return BaseTileWidget(
            title: TitleWidget(AppLocalizations.accreditationStatusByState,
                AppColors.kRacingGreen),
            body: Column(
              children: widgets,
            ));
        break;
      case 3:
        List<Widget> widgets = List<Widget>();
        widgets.add(AccreditationTable(
            _generateAccreditationTableData(
                data.getSortedByStandart(), false, true, selectedYear),
            "Evaluated in $selectedYear",
            AppLocalizations.state));
        widgets.add(AccreditationTable(
            _generateAccreditationTableData(
                data.getSortedByStandart(), true, true, selectedYear),
            "Cumulative up to $selectedYear",
            AppLocalizations.state));
        return BaseTileWidget(
            title: TitleWidget(
                AppLocalizations.accreditationPerfomancebyStandard,
                AppColors.kRacingGreen),
            body: Column(
              children: widgets,
            ));
        break;
      default:
    }
  }

  Map<dynamic, int> _generateMapOfSum(
      Map<dynamic, List<SchoolAccreditationModel>> listMap) {
    Map<dynamic, int> countMap = new Map<dynamic, int>();
    int sum = 0;

    listMap.forEach((k, v) {
      sum = 0;

      listMap[k].forEach((district) {
        if (district.result != null && district.result != "Level 1")
          sum += district.numThisYear;
      });

      countMap[k] = sum;
    });

    return countMap;
  }

  Map<dynamic, AccreditationTableData> _generateAccreditationTableData(
      Map<dynamic, List<SchoolAccreditationModel>> rawMapData,
      bool isCumulative,
      bool isByStandard,
      String currentYear) {
    var convertedData = Map<dynamic, AccreditationTableData>();

    rawMapData.forEach((k, v) {
      var levels = [0, 0, 0, 0, 0, 0, 0, 0];
      String fullName;

      for (var j = 0; j < v.length; ++j) {
        var model = v;
        var inspectionResult = model[j].inspectionResult;
        var numThisYear = 0;
        var numSum = 0;
        // fullName =  _dataLink.lookupsModel.getFullStandart(model[j].standartFull) ?? "";
        if (model[j].surveyYear.toString() == currentYear) {
          if (isByStandard) {
            inspectionResult = model[j].result;
            numThisYear += model[j].numInYear ?? 0;
            numSum += model[j].numSum ?? 0;
          } else {
            inspectionResult = model[j].inspectionResult;
            numThisYear += model[j].numThisYear ?? 0;
            numSum += model[j].numSum ?? 0;
          }
          if (inspectionResult == "Level 1") {
            levels[0] += numThisYear;
            levels[4] += numSum;
          } else if (inspectionResult == "Level 2") {
            levels[1] += numThisYear;
            levels[5] += numSum;
          } else if (inspectionResult == "Level 3") {
            levels[2] += numThisYear;
            levels[6] += numSum;
          } else if (inspectionResult == "Level 4") {
            levels[3] += numThisYear;
            levels[7] += numSum;
          }
        }
        // }
      }

      if (isCumulative)
        convertedData[k] =
            AccreditationTableData(levels[4], levels[5], levels[6], levels[7]);
      else
        convertedData[k] =
            AccreditationTableData(levels[0], levels[1], levels[2], levels[3]);
    });

    return convertedData;
  }
}
