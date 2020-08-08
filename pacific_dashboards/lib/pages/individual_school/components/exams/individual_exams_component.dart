import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/components/filtered_results_by_benchmark_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/components/filtered_results_by_gender_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/individual_exams_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class IndividualsExamsComponent extends MvvmStatefulWidget {
  IndividualsExamsComponent({Key key, @required ShortSchool school})
      : assert(school != null),
        super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createIndividualExamsViewModel(
            ctx,
            school,
          ),
        );

  @override
  _IndividualsExamsComponentState createState() =>
      _IndividualsExamsComponentState();
}

class _IndividualsExamsComponentState
    extends MvvmState<IndividualExamsViewModel, IndividualsExamsComponent> {
  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<bool>(
      stream: viewModel.activityIndicatorStream,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.data) {
          return Center(
            child: PlatformProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'individualSchoolExamsByBenchmarkTitle'
                          .localized(context),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  FilteredResultsByBenchmarkComponent(
                    loadingStream: viewModel.filteredDataLoadingStream,
                    dataStream: viewModel.filteredDataStream,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'individualSchoolExamsByGenderTitle'.localized(context),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  FilteredResultsByGenderComponent(
                    loadingStream: viewModel.filteredDataLoadingStream,
                    dataStream: viewModel.filteredDataStream,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'individualSchoolExamsHistoryTitle'.localized(context),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
