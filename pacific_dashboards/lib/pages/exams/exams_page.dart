import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/exam/exam.dart';
import 'package:pacific_dashboards/pages/exams/components/exams_filters.dart';
import 'package:pacific_dashboards/pages/exams/exams_navigator.dart';
import 'package:pacific_dashboards/pages/exams/components/exams_stacked_horizontal_bar_chart.dart';
import 'package:pacific_dashboards/pages/exams/exams_view_model.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/page_note_widget.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

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
        title: Text(AppLocalizations.exams),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 260),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            PageNoteWidget(noteStream: viewModel.noteStream),
            StreamBuilder<Map<String, Map<String, Exam>>>(
                stream: viewModel.dataStream,
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: PlatformProgressIndicator(),
                    );
                  } else {
                    return _PopulatedContent(
                      examResults: snapshot.data,
                    );
                  }
                }),
          ],
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
  final Map<String, Map<String, Exam>> _examResults;

  const _PopulatedContent({
    Key key,
    @required Map<String, Map<String, Exam>> examResults,
  })  : assert(examResults != null),
        _examResults = examResults,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.left,
                  maxLines: 5,
                ),
                ...results.keys.map((it) {
                  final chart =
                      ExamsStackedHorizontalBarChart.fromModel(results[it]);
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
                            style: Theme.of(context)
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
      ],
    );
  }
}
