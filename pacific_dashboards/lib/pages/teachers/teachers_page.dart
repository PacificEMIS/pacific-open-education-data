import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page_data.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/chart_factory.dart';
import 'package:pacific_dashboards/shared_ui/chart_with_table.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:pacific_dashboards/shared_ui/multi_table.dart';
import 'package:pacific_dashboards/shared_ui/page_note_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class TeachersPage extends MvvmStatefulWidget {
  static const String kRoute = '/Teachers';

  TeachersPage({
    Key key,
  }) : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createTeachersViewModel(ctx),
        );

  @override
  State<StatefulWidget> createState() {
    return TeachersPageState();
  }
}

class TeachersPageState extends MvvmState<TeachersViewModel, TeachersPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppBar(
        title: Text('teachersDashboardsTitle'.localized(context)),
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
            StreamBuilder<TeachersPageData>(
              stream: viewModel.dataStream,
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 1.3,
                    alignment: Alignment.center,
                    child: SizedBox(
                      child: PlatformProgressIndicator(),
                    ),
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('teachersCharts'.localized(context),
                          style: Theme.of(context).textTheme.headline3.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      MiniTabLayout(
                        tabs: _DashboardsTab.values,
                        padding: 0.0,
                        tabNameBuilder: (tab) {
                          switch (tab) {
                            case _DashboardsTab.byAuthority:
                              return 'schoolsByAuthority'.localized(context);
                            case _DashboardsTab.byState:
                              return 'schoolsByState'.localized(context);
                            case _DashboardsTab.byGovtNonGovt:
                              return 'schoolsByGovtNonGovt'.localized(context);
                          }
                          throw FallThroughError();
                        },
                        builder: (ctx, tab) {
                          switch (tab) {
                            case _DashboardsTab.byAuthority:
                              return ChartWithTable(
                                key:
                                    ValueKey(snapshot.data.teachersByAuthority),
                                title: '',
                                data: snapshot.data.teachersByAuthority,
                                chartType: ChartType.pie,
                                tableKeyName: 'schoolsDashboardsStateDomain'
                                    .localized(context),
                                tableValueName: 'schoolsDashboardsMeasureEnroll'
                                    .localized(context),
                              );
                            case _DashboardsTab.byGovtNonGovt:
                              return ChartWithTable(
                                key: ValueKey(snapshot.data.teachersByPrivacy),
                                title: '',
                                data: snapshot.data.teachersByPrivacy,
                                chartType: ChartType.pie,
                                tableKeyName: 'schoolsDashboardsAuthorityDomain'
                                    .localized(context),
                                tableValueName: 'schoolsDashboardsMeasureEnroll'
                                    .localized(context),
                              );
                            case _DashboardsTab.byState:
                              return ChartWithTable(
                                key: ValueKey(snapshot.data.teachersByDistrict),
                                title: '',
                                data: snapshot.data.teachersByDistrict,
                                chartType: ChartType.pie,
                                tableKeyName: 'schoolsDashboardsPrivacyDomain'
                                    .localized(context),
                                tableValueName: 'schoolsDashboardsMeasureEnroll'
                                    .localized(context),
                              );
                          }
                          throw FallThroughError();
                        },
                      ),
                      Text('certifiedAndQualified'.localized(context),
                          style: Theme.of(context).textTheme.headline3.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      ChartFactory.getStackedHorizontalBarChartViewByData(
                      chartData:  snapshot.data.teachersByCertification, //past data here
                      colorFunc: _levelIndexToColor,
                      ),
                      MultiTable(
                        key: ObjectKey(
                            snapshot.data.teachersBySchoolLevelStateAndGender),
                        title: 'teachersDashboardsEnrollByLevelStateGenderTitle'
                            .localized(context),
                        columnNames: [
                          'teachersDashboardsSchoolLevelDomain',
                          'labelMale',
                          'labelFemale',
                          'labelTotal'
                        ],
                        columnFlex: [3, 3, 3, 3],
                        data: snapshot.data.teachersBySchoolLevelStateAndGender,
                        keySortFunc: (lv, rv) => lv.compareTo(rv),
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

  Color _levelIndexToColor(int index) {
    return AppColors.kCertification[index];
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

enum _DashboardsTab { byAuthority, byGovtNonGovt, byState }
