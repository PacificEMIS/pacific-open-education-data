import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll_chunk.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/enroll_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/dashboards_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class DashboardComponent extends MvvmStatefulWidget {
  DashboardComponent({
    Key key,
    @required ShortSchool school,
  }) : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createDashboardsViewModel(ctx, school),
        );

  @override
  _DashboardComponentState createState() => _DashboardComponentState();
}

class _DashboardComponentState
    extends MvvmState<DashboardsViewModel, DashboardComponent> {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.individualSchoolEnrollTitle,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                StreamBuilder<SchoolEnrollChunk>(
                  stream: viewModel.enrollStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return EnrollComponent(chunk: snapshot.data);
                    } else {
                      return Container();
                    }
                  },
                ),
                Container(
                  height: 8,
                  color: AppColors.kSpace,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: const Text('Not Implemented'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
