import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll_chunk.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/dashboards_view_model.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class DashboardComponent extends MvvmStatefulWidget {
  DashboardComponent({
    Key key,
    @required ShortSchool school,
  }) : super(
          key: key,
          viewModelBuilder: (ctx) => ViewModelFactory.instance
              .createDashboardsViewModel(ctx, school),
        );

  @override
  _DashboardComponentState createState() => _DashboardComponentState();
}

class _DashboardComponentState
    extends MvvmState<DashboardsViewModel, DashboardComponent> {

  @override
  Widget buildWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder<SchoolEnrollChunk>(
            stream: viewModel.enrollStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return EnrollComponent(chunk: snapshot.data);
              } else {
                return Container();
              }
            }
          ),
        ],
      ),
    );
  }

}
