import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ChartWithTable(
                    key: ObjectKey(state.data.enrollmentByState),
                    title: AppLocalizations.schoolsEnrollmentByState,
                    data: state.data.enrollmentByState,
                    chartType: ChartType.bar,
                    tableKeyName: AppLocalizations.state,
                    tableValueName: AppLocalizations.schoolsEnrollment,
                  ),
                  ChartWithTable(
                    key: ObjectKey(state.data.enrollmentByAuthority),
                    title: AppLocalizations.schoolsEnrollmentByAuthority,
                    data: state.data.enrollmentByAuthority,
                    chartType: ChartType.pie,
                    tableKeyName: AppLocalizations.authority,
                    tableValueName: AppLocalizations.schoolsEnrollment,
                  ),
                  ChartWithTable(
                    key: ObjectKey(state.data.enrollmentByPrivacy),
                    title: AppLocalizations.schoolsEnrollmentGovtNonGovt,
                    data: state.data.enrollmentByPrivacy,
                    chartType: ChartType.pie,
                    tableKeyName: AppLocalizations.publicPrivate,
                    tableValueName: AppLocalizations.schoolsEnrollment,
                  ),
                  MultiTable(
                    key: ObjectKey(state.data.enrollmentByAgeAndEducation),
                    title:
                        AppLocalizations.schoolsEnrollmentByAgeEducationLevel,
                    firstColumnName: AppLocalizations.age,
                    data: state.data.enrollmentByAgeAndEducation,
                  ),
                  MultiTable(
                    key: ObjectKey(state.data.enrollmentBySchoolLevelAndState),
                    title: AppLocalizations
                        .schoolsEnrollmentBySchoolTypeStateAndGender,
                    firstColumnName: AppLocalizations.schoolType,
                    data: state.data.enrollmentBySchoolLevelAndState,
                  )
                ],
              ),
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
}

class MultiTable extends StatelessWidget {
  const MultiTable(
      {Key key,
      @required String title,
      @required String firstColumnName,
      @required Map<String, Map<String, InfoTableData>> data})
      : assert(title != null),
        assert(firstColumnName != null),
        assert(data != null),
        _title = title,
        _firstColumnName = firstColumnName,
        _data = data,
        super(key: key);

  final String _title;
  final String _firstColumnName;
  final Map<String, Map<String, InfoTableData>> _data;

  @override
  Widget build(BuildContext context) {
    return TileWidget(
        title: TitleWidget(_title, AppColors.kRacingGreen),
        body: Column(
          children: _data.keys.map((key) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: InfoTableWidget(
                _data[key],
                key,
                _firstColumnName,
              ),
            );
          }).toList(),
        ));
  }
}
