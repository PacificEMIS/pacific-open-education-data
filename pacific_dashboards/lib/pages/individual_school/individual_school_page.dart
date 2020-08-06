import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/dashboards_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/individual_exams_component.dart';
import 'package:pacific_dashboards/pages/individual_school/individual_school_view_model.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class IndividualSchoolPageArgs {
  final ShortSchool school;

  const IndividualSchoolPageArgs({
    @required this.school,
  });
}

class IndividualSchoolPage extends MvvmStatefulWidget {
  static const kRoute = '/IndividualSchoolPage';

  IndividualSchoolPage({Key key})
      : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createIndividualSchoolViewModel(ctx),
        );

  @override
  _IndividualSchoolPageState createState() => _IndividualSchoolPageState();
}

class _IndividualSchoolPageState
    extends MvvmState<IndividualSchoolViewModel, IndividualSchoolPage> {
  @override
  Widget buildWidget(BuildContext context) {
    final IndividualSchoolPageArgs args =
        ModalRoute.of(context).settings.arguments;
    return DefaultTabController(
      length: PageTab.values.length,
      child: Scaffold(
        appBar: PlatformAppBar(
          title: Text(args.school.name),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TabBar(
              tabs: [
                Tab(
                  text: PageTab.dashboards.getText(context),
                ),
                Tab(
                  text: PageTab.exams.getText(context),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  DashboardComponent(school: args.school),
                  IndividualsExamsComponent(school: args.school),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum PageTab { dashboards, exams }

extension PageTabExt on PageTab {
  String getText(BuildContext context) {
    switch (this) {
      case PageTab.dashboards:
        // TODO: Handle this case.
        break;
      case PageTab.exams:
        // TODO: Handle this case.
        break;
    }
    throw FallThroughError();
  }
}
