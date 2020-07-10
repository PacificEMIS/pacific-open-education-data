import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/mvvm/mvvm.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/schools/schools_page_data.dart';
import 'package:pacific_dashboards/pages/schools/schools_view_model.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/chart_with_table.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/shared_ui/multi_table.dart';
import 'package:pacific_dashboards/shared_ui/page_note_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class SchoolsPage extends MvvmStatefulWidget {
  static const String kRoute = '/Schools';

  SchoolsPage({Key key})
      : super(
          key: key,
          viewModelBuilder: (ctx) => ViewModelFactory.instance.schools,
        );

  @override
  State<StatefulWidget> createState() => SchoolsPageState();
}

class SchoolsPageState extends MvvmState<SchoolsViewModel, SchoolsPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppBar(
        title: Text(AppLocalizations.schools),
        actions: <Widget>[
          StreamBuilder<List<Filter>>(
            stream: viewModel.filtersStream,
            builder: (ctx, snapshot) {
              return Visibility(
                visible: snapshot.hasData,
                child: IconButton(
                  icon: SvgPicture.asset('images/filter.svg'),
                  onPressed: () {
                    _openFilters(snapshot.data);
                  },
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            PageNoteWidget(noteStream: viewModel.noteStream),
            StreamBuilder<SchoolsPageData>(
              stream: viewModel.dataStream,
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: PlatformProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      ChartWithTable(
                        key: ValueKey(snapshot.data.enrolByDistrict),
                        title: AppLocalizations.schoolsEnrollmentByState,
                        data: snapshot.data.enrolByDistrict,
                        chartType: ChartType.bar,
                        tableKeyName: AppLocalizations.state,
                        tableValueName: AppLocalizations.schoolsEnrollment,
                      ),
                      ChartWithTable(
                        key: ValueKey(snapshot.data.enrolByAuthority),
                        title: AppLocalizations.schoolsEnrollmentByAuthority,
                        data: snapshot.data.enrolByAuthority,
                        chartType: ChartType.pie,
                        tableKeyName: AppLocalizations.authority,
                        tableValueName: AppLocalizations.schoolsEnrollment,
                      ),
                      ChartWithTable(
                        key: ValueKey(snapshot.data.enrolByPrivacy),
                        title: AppLocalizations.schoolsEnrollmentGovtNonGovt,
                        data: snapshot.data.enrolByPrivacy,
                        chartType: ChartType.pie,
                        tableKeyName: AppLocalizations.publicPrivate,
                        tableValueName: AppLocalizations.schoolsEnrollment,
                      ),
                      MultiTable(
                        key: ValueKey(snapshot.data.enrolByAgeAndEducation),
                        title: AppLocalizations
                            .schoolsEnrollmentByAgeEducationLevel,
                        firstColumnName: AppLocalizations.age,
                        data: snapshot.data.enrolByAgeAndEducation,
                        keySortFunc: _compareEnrollmentByAgeAndEducation,
                      ),
                      MultiTable(
                        key: ValueKey(snapshot.data.enrolBySchoolLevelAndDistrict),
                        title: AppLocalizations
                            .schoolsEnrollmentBySchoolTypeStateAndGender,
                        firstColumnName: AppLocalizations.schoolType,
                        data: snapshot.data.enrolBySchoolLevelAndDistrict,
                        keySortFunc: _compareEnrollmentBySchoolLevelAndState,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  int _compareEnrollmentBySchoolLevelAndState(String lv, String rv) {
    return lv.compareTo(rv);
  }

  int _compareEnrollmentByAgeAndEducation(String lv, String rv) {
    // formats like 1-12
    final lvParts = lv.split('-');
    if (lvParts.length < 1) {
      return -1;
    }

    final rvParts = rv.split('-');
    if (rvParts.length < 1) {
      return 1;
    }

    try {
      final lvNum = int.tryParse(lvParts.first);
      final rvNum = int.tryParse(rvParts.first);
      return lvNum.compareTo(rvNum);
    } catch (_) {
      return lvParts.first.compareTo(rvParts.first);
    }
  }

  void _openFilters(List<Filter> filters) {
    Navigator.push<List<Filter>>(
      context,
      MaterialPageRoute(builder: (context) {
        return FilterPage(
          filters: filters,
        );
      }),
    ).then((filters) => _applyFilters(context, filters));
  }

  void _applyFilters(BuildContext context, List<Filter> filters) {
    if (filters == null) {
      return;
    }
    viewModel.onFiltersChanged(filters);
  }
}
