import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school_flow/school_flow.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/rates/rates_data.dart';
import 'package:pacific_dashboards/utils/collections.dart';
import 'package:rxdart/rxdart.dart';

class RatesViewModel extends BaseViewModel {
  final Repository _repository;
  final ShortSchool _school;
  final Subject<RatesData> _dataSubject = BehaviorSubject();
  List<SchoolFlow> _data;

  RatesViewModel(
    BuildContext ctx, {
    @required ShortSchool school,
    @required Repository repository,
  })  : assert(repository != null),
        assert(school != null),
        _school = school,
        _repository = repository,
        super(ctx);

  Stream<RatesData> get dataStream => _dataSubject.stream;

  @override
  void onInit() {
    super.onInit();
    _dataSubject.disposeWith(disposeBag);
    _loadFlowData();
  }

  void _loadFlowData() {
    handleRepositoryFetch(
      fetch: () => _repository.fetchIndividualSchoolFlow(_school.id),
    )
        .doOnListen(() => notifyHaveProgress(true))
        .listen(
          _onFlowLoaded,
          onError: (t) => handleThrows,
          cancelOnError: false,
        )
        .disposeWith(disposeBag);
  }

  void _onFlowLoaded(List<SchoolFlow> flows) {
    _data = flows;
    _parseData();
  }

  void _parseData() {
    if (_data == null) return;
    launchHandled(() async {
      final lookups = await _repository.lookups.first;
      final flowsLookuped = _FlowsLookuped(_data, lookups);
      final dataOnLastYear = await compute(
        _generateLastYearData,
        flowsLookuped,
      );
      final historicalData = await compute(
        _generateHistoricalData,
        flowsLookuped,
      );
      final data = RatesData(
        lastYearRatesData: dataOnLastYear,
        historicalData: historicalData,
      );
      _dataSubject.add(data);
    }, notifyProgress: true);
  }
}

class _FlowsLookuped {
  final List<SchoolFlow> flows;
  final Lookups lookups;

  const _FlowsLookuped(this.flows, this.lookups);
}

LastYearRatesData _generateLastYearData(
  _FlowsLookuped flowsLookuped,
) {
  if (flowsLookuped.flows.isEmpty) {
    return LastYearRatesData(year: DateTime.now().year, data: []);
  }
  final lastYear = flowsLookuped.flows
      .chainSort((lv, rv) => rv.year.compareTo(lv.year))
      .first
      .year;
  final dataOnLastYear = flowsLookuped.flows
      .where((it) => it.year == lastYear)
      .toList()
      .chainSort((lv, rv) => lv.yearOfEducation.compareTo(rv.yearOfEducation));

  return LastYearRatesData(
    year: lastYear,
    data: dataOnLastYear.map((it) {
      return ClassLevelRatesData(
        classLevel: it.yearOfEducation.educationLevelCodeFrom(
          flowsLookuped.lookups,
        ),
        dropoutRate: it.dropoutRate,
        promoteRate: it.promoteRate,
        repeatRate: it.repeatRate,
        survivalRate: it.survivalRate,
      );
    }).toList(),
  );
}

List<YearByClassLevelRateData> _generateHistoricalData(
  _FlowsLookuped flowsLookuped,
) {
  if (flowsLookuped.flows.isEmpty) {
    return [];
  }

  final flowsByYearOfEducation =
      flowsLookuped.flows.groupBy((it) => it.yearOfEducation);
  final sortedYearOfEducationList = flowsByYearOfEducation.keys
      .chainSort((lv, rv) => lv.compareTo(rv))
      .toList();

  final List<YearByClassLevelRateData> result = [];
  for (var yearOfEducation in sortedYearOfEducationList) {
    result.add(YearByClassLevelRateData(
      classLevel: yearOfEducation.educationLevelCodeFrom(
        flowsLookuped.lookups,
      ),
      data: flowsByYearOfEducation[yearOfEducation].map((it) {
        return YearRateData(
          year: it.year,
          dropoutRate: it.dropoutRate,
          promoteRate: it.promoteRate,
          repeatRate: it.repeatRate,
          survivalRate: it.survivalRate,
        );
      }).toList().chainSort((lv, rv) => lv.year.compareTo(rv.year)),
    ));
  }

  return result;
}
