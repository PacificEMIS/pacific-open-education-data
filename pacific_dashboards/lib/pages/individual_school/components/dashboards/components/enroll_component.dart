import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll_chunk.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll_view_model.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          AppLocalizations.individualSchoolEnrollTitle,
          style: Theme.of(context).textTheme.headline4,
        ),
        StreamBuilder(
          stream: viewModel.dataStream,
          builder: (ctx, snapshot) {
            return Text(snapshot.data?.toString() ?? 'null');
          },
        ),
      ],
    );
  }
}
