import 'package:arch/arch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/individual_school/components/accreditation/components/accreditation_table_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/accreditation/individual_accreditation_data.dart';
import 'package:pacific_dashboards/pages/individual_school/components/accreditation/individual_accreditation_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
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
    final accreditationDateFormat = DateFormat('MMM d, yyyy');
    return StreamBuilder<bool>(
      stream: viewModel.activityIndicatorStream,
      initialData: true,
      builder: (context, snapshot) {
        if (snapshot.data) {
          return Container();
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
                        accreditationData.dateTime != null
                            ? accreditationDateFormat
                                .format(accreditationData.dateTime)
                            : 'labelNa'.localized(context),
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
}

class _AccreditationWidget extends StatelessWidget {
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
            _AccreditationLevelWidget(
              level: _data.result,
            ),
          ],
        ),
        SizedBox(height: 16),
        AccreditationTableComponent(
          data: _data.standards,
        ),
      ],
    );
  }

  String _getInspectedBy(BuildContext context) =>
      _data.inspectedBy ?? 'labelNa'.localized(context);
}

class _AccreditationLevelWidget extends StatelessWidget {
  final int _level;

  const _AccreditationLevelWidget({
    Key key,
    @required int level,
  })  : _level = level,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.individualAccreditationLevel;
    if (_level == null || _level < 1 || _level > 4) {
      return Text('-', style: textStyle);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('$_level', style: textStyle),
        Icon(
          Icons.star,
          size: 14,
          color: AppColors.kLevels[_level - 1],
        ),
      ],
    );
  }
}
