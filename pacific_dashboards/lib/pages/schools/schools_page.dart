import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacific_dashboards/models/school_model.dart';
import 'package:pacific_dashboards/models/schools_model.dart';
import 'package:pacific_dashboards/pages/filter/filter_bloc.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/schools/bloc/bloc.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/chart_with_table.dart';
import 'package:pacific_dashboards/shared_ui/info_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';
import 'package:pacific_dashboards/shared_ui/tile_widget.dart';
import 'package:pacific_dashboards/shared_ui/title_widget.dart';

class SchoolsPage extends StatefulWidget {
  SchoolsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SchoolsPageState();
  }
}

class SchoolsPageState extends State<SchoolsPage> {
  SchoolsModel _dataLink;

  SchoolsBloc _schoolsBloc;

  @override
  void initState() {
    super.initState();
    _schoolsBloc = BlocProvider.of<SchoolsBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _schoolsBloc.close();
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
              color: AppColors.kWhite,
            ),
            onPressed: () {
              _createFilterPageRoute(context);
            },
          ),
        ],
        title: Text(
          AppLocalizations.schools,
          style: TextStyle(
            color: AppColors.kWhite,
            fontSize: 18.0,
            fontFamily: "Noto Sans",
          ),
        ),
      ),
      body: BlocBuilder<SchoolsBloc, SchoolsState>(
        builder: (context, state) {
          if (state is LoadingSchoolsState) {
            return Center(
              child: PlatformProgressIndicator(),
            );
          }

          if (state is LoadedSchoolsState) {
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                ChartWithTable(
                  title: AppLocalizations.schoolsEnrollmentByState,
                  data: state.data.enrollmentByState,
                  chartType: ChartType.bar, 
                  tableKeyName: AppLocalizations.state, 
                  tableValueName: AppLocalizations.schoolsEnrollment,
                ),
                ChartWithTable(
                  title: AppLocalizations.schoolsEnrollmentByAuthority,
                  data: state.data.enrollmentByAuthority,
                  chartType: ChartType.pie, 
                  tableKeyName: AppLocalizations.authority, 
                  tableValueName: AppLocalizations.schoolsEnrollment,
                ),
                ChartWithTable(
                  title: AppLocalizations.schoolsEnrollmentGovtNonGovt,
                  data: state.data.enrollmentByPrivacy,
                  chartType: ChartType.pie, 
                  tableKeyName: AppLocalizations.publicPrivate, 
                  tableValueName: AppLocalizations.schoolsEnrollment,
                ),
              ],
            );
          }

          throw FallThroughError();
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
          defaultSelectedKey: AppLocalizations.displayAllGovernment));
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

  // Widget _generateGridTile(SchoolsModel data, int index) {
  //   switch (index) {
  //     case 0:
  //       break;
  //     case 1:
  //       break;
  //     case 2:
  //       break;
  //     case 3:
  //       var statesKeys = [
  //         AppLocalizations.earlyChildhood,
  //         AppLocalizations.primary,
  //         AppLocalizations.secondary,
  //         AppLocalizations.postSecondary
  //       ];
  //       List<Widget> widgets = List<Widget>();

  //       widgets.add(InfoTableWidget(
  //           _generateInfoTableData(
  //               data.getSortedByAge(0), AppLocalizations.total, false),
  //           AppLocalizations.total,
  //           AppLocalizations.age));

  //       for (var i = 0; i < statesKeys.length; ++i) {
  //         widgets.add(widget._dividerWidget);
  //         widgets.add(InfoTableWidget(
  //             _generateInfoTableData(
  //                 data.getSortedByAge(i + 1), statesKeys[i], false),
  //             statesKeys[i],
  //             AppLocalizations.age));
  //       }

  //       return TileWidget(
  //           title: TitleWidget(
  //               AppLocalizations.schoolsEnrollmentByAgeEducationLevel,
  //               AppColors.kRacingGreen),
  //           body: Column(
  //             children: widgets,
  //           ));
  //       break;
  //     default:
  //       var statesKeys = data.getDistrictCodeKeysList();
  //       List<Widget> widgets = List<Widget>();

  //       final filteredDataBySchoolType =
  //           data.getSortedWithFilteringBySchoolType();
  //       widgets.add(InfoTableWidget(
  //           _generateInfoTableData(
  //               filteredDataBySchoolType, AppLocalizations.total, false),
  //           AppLocalizations.total,
  //           AppLocalizations.schoolType));

  //       for (var i = 0; i < statesKeys.length; ++i) {
  //         widgets.add(widget._dividerWidget);
  //         widgets.add(InfoTableWidget(
  //             _generateInfoTableData(
  //                 filteredDataBySchoolType, statesKeys[i], true),
  //             data.lookupsModel.getFullState(statesKeys[i]),
  //             AppLocalizations.schoolType));
  //       }

  //       return TileWidget(
  //           title: TitleWidget(
  //               AppLocalizations.schoolsEnrollmentBySchoolTypeStateAndGender,
  //               AppColors.kRacingGreen),
  //           body: Column(
  //             children: widgets,
  //           ));
  //       break;
  //   }
  // }

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

    convertedData[AppLocalizations.total] =
        InfoTableData(totalMaleCount, totalFemaleCount);

    return convertedData;
  }
}