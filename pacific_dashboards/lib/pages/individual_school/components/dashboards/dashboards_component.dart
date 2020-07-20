import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/dashboards_view_model.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class DashboardComponent extends MvvmStatefulWidget {
  DashboardComponent({
    Key key,
    @required String schoolId,
    @required String districtCode,
  }) : super(
          key: key,
          viewModelBuilder: (ctx) => ViewModelFactory.instance
              .createDashboardsViewModel(ctx, schoolId, districtCode),
        );

  @override
  _DashboardComponentState createState() => _DashboardComponentState();
}

class _DashboardComponentState
    extends MvvmState<DashboardsViewModel, DashboardComponent> {

  @override
  Widget buildWidget(BuildContext context) {
    return Container();
  }

}
