import 'package:arch/arch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/individual_school/components/accreditation/components/accreditation_level_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/accreditation/components/accreditation_table_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/accreditation/individual_accreditation_data.dart';
import 'package:pacific_dashboards/pages/individual_school/components/accreditation/individual_accreditation_view_model.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class IndividualAccreditationComponent extends MvvmStatefulWidget {
  IndividualAccreditationComponent({
    Key key,
    @required ShortSchool school,
  })  : assert(school != null),
        super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createIndividualAccreditationViewModel(
            ctx,
            school,
          ),
        );

  @override
  _IndividualAccreditationComponentState createState() =>
      _IndividualAccreditationComponentState();
}

class _IndividualAccreditationComponentState extends MvvmState<
    IndividualAccreditationViewModel, IndividualAccreditationComponent> {
  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<bool>(
      stream: viewModel.activityIndicatorStream,
      initialData: true,
      builder: (context, snapshot) {
        if (snapshot.data) {
          return Center(
            child: PlatformProgressIndicator(),
          );
        }
        return StreamBuilder<List<IndividualAccreditationData>>(
          stream: viewModel.dataStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final data = snapshot.data;
            if (data.isEmpty) {
              return Center(
                child: Text('labelNoData'.localized(context)),
              );
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'individualSchoolAccreditationsDisclaimer'
                          .localized(context),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  MiniTabLayout(
                    tabs: data,
                    tabNameBuilder: (accreditationData) =>
                        _createTabName(context, accreditationData),
                    builder: (context, accreditationData) =>
                        _AccreditationWidget(
                      data: accreditationData,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _createTabName(
    BuildContext context,
    IndividualAccreditationData data,
  ) {
    if (data.dateTime == null) {
      if (data.inspectionYear == null) {
        return 'labelNa'.localized(context);
      }
      return '${data.inspectionYear}';
    }
    return DateFormat('MMM d, yyyy').format(data.dateTime);
  }
}

class _AccreditationWidget extends StatelessWidget {
  static const double _kObservationHeight = 40.0;
  static const List<int> _kObservationFlexes = [11, 2, 2];

  final IndividualAccreditationData _data;

  const _AccreditationWidget({
    Key key,
    @required IndividualAccreditationData data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${'individualSchoolAccreditationsInspectedBy'.localized(context)}${_getInspectedBy(context)}',
              style: Theme.of(context)
                  .textTheme
                  .individualAccreditationInspectedBy,
            ),
            Spacer(),
            AccreditationLevelComponent(
              level: _data.result,
            ),
          ],
        ),
        SizedBox(height: 16),
        AccreditationTableComponent(
          data: _data.standards,
        ),
        SizedBox(height: 8),
        Container(
          height: _kObservationHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: _kObservationFlexes[0],
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'individualSchoolAccreditationsCO'.localized(context),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
              ),
              Expanded(
                flex: _kObservationFlexes[1],
                child: Text(
                  '${_data.classroomObservation1 ?? '-'}',
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.individualAccreditationLevel,
                ),
              ),
              Expanded(
                flex: _kObservationFlexes[2],
                child: Text(
                  '${_data.classroomObservation2 ?? '-'}',
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.individualAccreditationLevel,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getInspectedBy(BuildContext context) =>
      _data.inspectedBy ?? 'labelNa'.localized(context);
}
