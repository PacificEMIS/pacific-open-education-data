import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/individual_exams_view_model.dart';
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
    return Container();
  }
}
