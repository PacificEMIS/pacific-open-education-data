import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll_chunk.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/components/female_part_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/components/gender_history_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/components/level_and_gender_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/components/level_and_gender_history_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/enroll_data.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/enroll_view_model.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';

class EnrollComponent extends MvvmStatefulWidget {
  final ShortSchool school;

  EnrollComponent({
    Key key,
    @required SchoolEnrollChunk chunk,
    @required this.school,
  })  : assert(chunk != null),
        assert(school != null),
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
    return StreamBuilder<bool>(
      stream: viewModel.activityIndicatorStream,
      initialData: false,
      builder: (ctx, snapshot) {
        if (snapshot.data) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: PlatformProgressIndicator(),
            ),
          );
        } else {
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
                    FemalePartComponent(
                      data: snapshot.data,
                      schoolId: widget.school.id,
                      district: widget.school.districtName,
                    )
                  ],
                );
              } else {
                return Container();
              }
            },
          );
        }
      },
    );
  }
}
