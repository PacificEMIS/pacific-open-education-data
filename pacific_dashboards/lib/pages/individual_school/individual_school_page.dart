import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/dashboards_component.dart';
import 'package:pacific_dashboards/pages/individual_school/individual_school_view_model.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class IndividualSchoolPageArgs {
  final String schoolId;
  final String schoolName;
  final String districtCode;

  const IndividualSchoolPageArgs({
    @required this.schoolId,
    @required this.schoolName,
    @required this.districtCode,
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
    final IndividualSchoolPageArgs args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: PlatformAppBar(
        title: Text(args.schoolName),
      ),
      body: DashboardComponent(
        schoolId: args.schoolId,
        districtCode: args.districtCode,
      ),
    );
  }
}
