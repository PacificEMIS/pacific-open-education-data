import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/exams/components/exams_filters.dart';
import 'package:pacific_dashboards/pages/exams/exams_navigator.dart';
import 'package:pacific_dashboards/pages/exams/components/exams_stacked_horizontal_bar_chart.dart';
import 'package:pacific_dashboards/pages/exams/exams_view_model.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/loading_stack.dart';
import 'package:pacific_dashboards/shared_ui/page_note_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

import '../../models/exam/exam_separated.dart';
import '../../res/colors.dart';
import '../../shared_ui/charts/chart_legend_item.dart';
import 'components/exams_stacked_horizontal_bar_gender_chart.dart';
import 'exams_filter_data.dart';

class ExamsPage extends MvvmStatefulWidget {
  static const String kRoute = "/Exams";

  ExamsPage({Key key})
      : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createExamsViewModel(ctx),
        );

  @override
  State<StatefulWidget> createState() {
    return ExamsPageState();
  }
}

class ExamsPageState extends MvvmState<ExamsViewModel, ExamsPage> {
  @override
  Widget buildWidget(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: PlatformAppBar(
        title: Text('examsDashboardsTitle'.localized(context)),
      ),
      body: LoadingStack(
        loadingStateStream: viewModel.activityIndicatorStream,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PageNoteWidget(noteStream: viewModel.noteStream),
              StreamBuilder<Map<String, Map<String, List<ExamSeparated>>>>(
                stream: viewModel.dataStream,
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return _PopulatedContent(
                      examResults: snapshot.data,
                      viewModel: viewModel,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: ExamsFiltersWidget(
        bottomInset: bottomInset,
        viewModel: viewModel,
      ),
    );
  }
}

class _PopulatedContent extends StatelessWidget {
  final Map<String, Map<String, List<ExamSeparated>>> _examResults;
  final ExamsViewModel _viewModel;

  const _PopulatedContent({
    Key key,
    @required Map<String, Map<String, List<ExamSeparated>>> examResults,
    @required ExamsViewModel viewModel,
  })
      : assert(examResults != null),
        _examResults = examResults,
        _viewModel = viewModel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final allUngrouped = _examResults.values.fold<List<ExamSeparated>>(
        [], (previousValue, element) =>
    previousValue
        + element.values.reduce((v, e) => v + e));
    return StreamBuilder<ExamsFilterData>(
      stream: _viewModel.filtersStream,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ..._examResults.keys.map((it) {
                final results = _examResults[it];
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        it,
                        style: Theme
                            .of(context)
                            .textTheme
                            .subtitle2,
                        textAlign: TextAlign.left,
                        maxLines: 5,
                      ),
                      ...results.keys.map((it) {
                        final chart =
                        ExamsStackedHorizontalBarChart.fromModel(
                            results[it], snapshot.data.showModeId);
                        if (it != ExamsNavigator.kNoTitleKey) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                child: Text(
                                  it,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(fontSize: 12.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              chart,
                            ],
                          );
                        }
                        return chart;
                      }).toList(),
                    ],
                  ),
                );
              }).toList(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Text(
                  'achievementByGenderLabel'.localized(context),
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 12.0),
                  textAlign: TextAlign.left,
                ),
              ),
              ExamsStackedHorizontalBarGenderChart.fromModel(
                  allUngrouped, context, snapshot.data.showModeId),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ChartLegendItem(
                    color: AppColors.kRed,
                    value: 'labelFemale'.localized(context),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  ChartLegendItem(
                    color: AppColors.kBlue,
                    value: 'labelMale'.localized(context),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
