import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/schools/schools_page_data.dart';
import 'package:pacific_dashboards/pages/schools/schools_view_model.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/chart_with_table.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:pacific_dashboards/shared_ui/multi_table.dart';
import 'package:pacific_dashboards/shared_ui/page_note_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/tile_widget.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class SchoolsPage extends MvvmStatefulWidget {
  static const String kRoute = '/Schools';

  SchoolsPage({Key key})
      : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createSchoolsViewModel(ctx),
        );

  @override
  State<StatefulWidget> createState() => SchoolsPageState();
}

class SchoolsPageState extends MvvmState<SchoolsViewModel, SchoolsPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppBar(
        title: Text('schoolsDashboardsTitle'.localized(context)),
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
        physics: const AlwaysScrollableScrollPhysics(),
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
                  // return buildMultiTable(snapshot, context);
                  return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('enrolment'.localized(context),
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                        MiniTabLayout(
                          tabs: _DashboardsTab.values,
                          padding: 0.0,
                          tabNameBuilder: (tab) {
                            switch (tab) {
                              case _DashboardsTab.byState:
                                return '${'schoolsByState'.localized(context)} ${snapshot.data.year}';
                              case _DashboardsTab.byAuthority:
                                return '${'schoolsByAuthority'.localized(context)} ${snapshot.data.year}';
                              case _DashboardsTab.byGovtNonGovt:
                              return '${'schoolsByGovtNonGovt'.localized(context)} ${snapshot.data.year}';
                            }
                            throw FallThroughError();
                          },
                          builder: (ctx, tab) {
                            switch (tab) {
                              case _DashboardsTab.byState:
                                return ChartWithTable(
                                  key: ValueKey(snapshot.data.enrolByDistrict),
                                  title: '',
                                  data: snapshot.data.enrolByDistrict,
                                  chartType: ChartType.pie,
                                  tableKeyName: 'schoolsDashboardsStateDomain'
                                      .localized(context),
                                  tableValueName:
                                      'schoolsDashboardsMeasureEnroll'
                                          .localized(context),
                                );
                              case _DashboardsTab.byAuthority:
                                return ChartWithTable(
                                  key: ValueKey(snapshot.data.enrolByAuthority),
                                  title: '',
                                  data: snapshot.data.enrolByAuthority,
                                  chartType: ChartType.pie,
                                  tableKeyName:
                                      'schoolsDashboardsAuthorityDomain'
                                          .localized(context),
                                  tableValueName:
                                      'schoolsDashboardsMeasureEnroll'
                                          .localized(context),
                                );
                              case _DashboardsTab.byGovtNonGovt:
                                return ChartWithTable(
                                  key: ValueKey(snapshot.data.enrolByPrivacy),
                                  title: '',
                                  data: snapshot.data.enrolByPrivacy,
                                  chartType: ChartType.pie,
                                  tableKeyName: 'schoolsDashboardsPrivacyDomain'
                                      .localized(context),
                                  tableValueName:
                                      'schoolsDashboardsMeasureEnroll'
                                          .localized(context),
                                );
                            }
                            throw FallThroughError();
                          },
                        ),
                        MultiTable(
                          key: ValueKey(snapshot.data.enrolByAgeAndEducation),
                          title: 'schoolsDashboardsEnrollByAgeLevelGenderTitle'
                              .localized(context),
                          columnNames: [
                            'schoolsDashboardsAgeDomain',
                            'labelMale',
                            'labelFemale',
                            'labelTotal'
                          ],
                          columnFlex: [3, 3, 3, 3],
                          data: snapshot.data.enrolByAgeAndEducation,
                          keySortFunc: _compareEnrollmentByAgeAndEducation,
                        ),
                        MultiTable(
                          key: ValueKey(
                              snapshot.data.enrolBySchoolLevelAndDistrict),
                          title: 'schoolsDashboardsEnrollByLevelStateGenderTitle'
                              .localized(context),
                          columnNames: [
                            'schoolsDashboardsSchoolLevelDomain',
                            'labelMale',
                            'labelFemale',
                            'labelTotal'
                          ],
                          columnFlex: [3, 3, 3, 3],
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

enum _DashboardsTab { byState, byAuthority, byGovtNonGovt }
