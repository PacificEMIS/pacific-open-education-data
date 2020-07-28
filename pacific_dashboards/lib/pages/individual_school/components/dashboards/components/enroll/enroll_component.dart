import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll_chunk.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/components/gender_history_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/components/level_and_gender_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/components/level_and_gender_history_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/enroll_data.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/enroll_view_model.dart';

class EnrollComponent extends MvvmStatefulWidget {
  EnrollComponent({
    Key key,
    @required SchoolEnrollChunk chunk,
  })  : assert(chunk != null),
        super(
          key: key,
          viewModelBuilder: (ctx) => EnrollViewModel(ctx, chunk),
        );

  @override
  _EnrollComponentState createState() => _EnrollComponentState();
}

class _EnrollComponentState
    extends MvvmState<EnrollViewModel, EnrollComponent> {
  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<EnrollData>(
      stream: viewModel.dataStream,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LevelAndGenderComponent(
                data: snapshot.data.gradeDataOnLastYear,
              ),
              LevelAndGenderHistoryComponent(
                data: snapshot.data.gradeDataHistory,
              ),
              GenderHistoryComponent(data: snapshot.data.genderDataHistory),
            ],
          );
        } else {
          return Center(
            child: const Text('-'),
          );
        }
      },
    );
  }
}
