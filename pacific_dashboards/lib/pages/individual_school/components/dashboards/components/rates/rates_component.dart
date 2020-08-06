import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/rates/components/rate_slice_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/rates/rates_data.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/rates/rates_view_model.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_progress_indicator.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class RatesComponent extends MvvmStatefulWidget {
  RatesComponent({Key key, @required ShortSchool school})
      : assert(school != null),
        super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createRatesViewModel(ctx, school),
        );

  @override
  _RatesComponentState createState() => _RatesComponentState();
}

class _RatesComponentState extends MvvmState<RatesViewModel, RatesComponent> {
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
          return StreamBuilder<RatesData>(
            stream: viewModel.dataStream,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RateSliceComponent(
                      title: 'individualSchoolDashboardRatesDropoutTitle'
                          .localized(context),
                      ratesData: snapshot.data,
                      classLevelRateAccessor: (data) => data.dropoutRate,
                      yearRateAccessor: (data) => data.dropoutRate,
                    ),
                    RateSliceComponent(
                      title: 'individualSchoolDashboardRatesPromoteTitle'
                          .localized(context),
                      ratesData: snapshot.data,
                      classLevelRateAccessor: (data) => data.promoteRate,
                      yearRateAccessor: (data) => data.promoteRate,
                    ),
                    RateSliceComponent(
                      title: 'individualSchoolDashboardRatesRepeatTitle'
                          .localized(context),
                      ratesData: snapshot.data,
                      classLevelRateAccessor: (data) => data.repeatRate,
                      yearRateAccessor: (data) => data.repeatRate,
                    ),
                    RateSliceComponent(
                      title: 'individualSchoolDashboardRatesSurvivalTitle'
                          .localized(context),
                      ratesData: snapshot.data,
                      classLevelRateAccessor: (data) => data.survivalRate,
                      yearRateAccessor: (data) => data.survivalRate,
                    ),
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
