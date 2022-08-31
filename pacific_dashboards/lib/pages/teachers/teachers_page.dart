import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/pages/filter/filter_page.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page_data.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/stacked_horizontal_bar_chart_widget_extended.dart';
import 'package:pacific_dashboards/shared_ui/loading_stack.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:pacific_dashboards/shared_ui/page_note_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

import '../special_education/componnets/special_education_component.dart';
import 'components/teachers_multi_table.dart';

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
      body: LoadingStack(
        loadingStateStream: viewModel.activityIndicatorStream,
        child: SingleChildScrollView(
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
                    return Container();
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'teachersDashboardsChartTitle'.localized(context),
                          style: Theme.of(context).textTheme.headline3.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
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
                                return 'schoolsByGovtNonGovt'
                                    .localized(context);
                            }
                            throw FallThroughError();
                          },
                          builder: (ctx, tab) {
                            switch (tab) {
                              case _DashboardsTab.byAuthority:
                                return Column(children: [
                                  SpecialEducationComponent(
                                    data:   snapshot.data.teachersByAuthority, showTabs: false
                                  ),
                                ]);
                              case _DashboardsTab.byGovtNonGovt:
                                return Column(children: [
                                  SpecialEducationComponent(
                                      data:   snapshot.data.teachersByPrivacy, showTabs: false
                                  ),
                                ]);
                              case _DashboardsTab.byState:
                                return Column(children: [
                                  SpecialEducationComponent(
                                      data:   snapshot.data.teachersByDistrict, showTabs: false
                                  ),
                                ]);
                            }
                            throw FallThroughError();
                          },
                        ),
                        Text('certifiedAndQualified'.localized(context),
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                          child: Text(
                            'Female  Male',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        (snapshot.data.teachersByCertification.length == 0)
                            ? Container()
                            : StackedHorizontalBarChartWidgetExtended(
                                data: snapshot.data.teachersByCertification,
                                legend: [
                                  'schoolsCertifiedQualified',
                                  'qualifiedNotCertified',
                                  'certifiedNotQualified',
                                  'other'
                                ],
                                colorFunc: _levelIndexToColor,
                              ),
                        SizedBox(height: 10.0),
                        Text(
                          'teachersDashboardsEnrollByLevelStateGenderTitle'
                              .localized(context),
                          style: Theme.of(context).textTheme.headline3.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                    TeachersMultiTableWidget(
                                    objectKey: ObjectKey(snapshot.data
                                        .enrollTeachersBySchoolLevelStateAndGender),
                                    selectedTabData: snapshot
                                        .data
                                        .enrollTeachersBySchoolLevelStateAndGender
                                        .all)
                      ],
                    );
                  }
                },
              ),
            ],
          ),
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

class TeachersMultiTableWidget extends StatelessWidget {
  const TeachersMultiTableWidget({
    Key key,
    @required this.selectedTabData,
    @required this.objectKey,
  }) : super(key: key);

  final List selectedTabData;
  final Key objectKey;

  @override
  Widget build(BuildContext context) {
    return TeachersMultiTable(
      key: objectKey,
      columnNames: [
        'teachersDashboardsSchoolLevelDomain',
        'labelMale',
        'labelFemale',
        'labelTotal'
      ],
      columnFlex: [3, 3, 3, 3],
      data: selectedTabData,
      keySortFunc: (lv, rv) => lv.compareTo(rv),
      domainValueBuilder: GenderTableData.sDomainValueBuilder,
    );
  }
}

enum _DashboardsTab { byAuthority, byGovtNonGovt, byState }