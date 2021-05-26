import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/indicators/indicator.dart';
import 'package:pacific_dashboards/models/indicators/indicators_container.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/indicators/indicators_filter_data.dart';
import 'package:pacific_dashboards/pages/indicators/indicators_navigator.dart';
import 'package:rxdart/rxdart.dart';

class IndicatorsViewModel extends BaseViewModel {
  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<IndicatorsFilterData> _filtersSubject = BehaviorSubject();
  final Subject<Pair<Indicator, Indicator>> _dataSubject =
      BehaviorSubject();

  IndicatorsNavigator _navigator;
  Lookups _lookups;
  bool canSelectState = false;

  IndicatorsViewModel(
    BuildContext ctx, {
    @required Repository repository,
    @required RemoteConfig remoteConfig,
    @required GlobalSettings globalSettings,
  })  : assert(repository != null),
        assert(remoteConfig != null),
        assert(globalSettings != null),
        _repository = repository,
        _remoteConfig = remoteConfig,
        _globalSettings = globalSettings,
        super(ctx);

  @override
  void onInit() {
    super.onInit();
    _dataSubject.disposeWith(disposeBag);
    _filtersSubject.disposeWith(disposeBag);
    _loadCurrentEmis();
    loadData();
  }

  void _loadCurrentEmis() {
    launchHandled(() async {
      final currentEmis = await _globalSettings.currentEmis;
      canSelectState = currentEmis == Emis.fedemis;
    });
  }

  void loadData({String region = ''}) {
    var selectedRegionId =  _navigator == null ? '' : _navigator.regionsNames.indexWhere((element) => element == regionName);
    if (selectedRegionId != '') _navigator.onRegionChanged(selectedRegionId);
    if (_navigator != null) selectedRegionId = _navigator.regionId;
    listenHandled(
      handleRepositoryFetch(fetch: () => _repository.fetchAllIndicators(selectedRegionId)),
      _onDataLoaded,
      notifyProgress: true,
    );
  }

  Future<void> _onDataLoaded(IndicatorsContainer indicators) => launchHandled(
        () async {
          _lookups = await _repository.lookups.first;
          _navigator = IndicatorsNavigator(
              indicators, _lookups, oldNavigator: _navigator);
          _updatePageData();
        },
      );

  void _updatePageData() {
    launchHandled(() {
      _dataSubject.add(_convertIndicators());
      _filtersSubject.add(filterData);
    });
  }

  IndicatorsFilterData get filterData => IndicatorsFilterData(
    _navigator.educationLevelName,
    _navigator.regionName,
    _navigator.selectedFirstYear,
    _navigator.selectedSecondYear,
  );

  Pair<Indicator, Indicator> _convertIndicators() {
    return _navigator.getIndicatorResults(_lookups);
  }

  Stream<Pair<Indicator, Indicator>> get dataStream => _dataSubject.stream;

  Stream<IndicatorsFilterData> get filtersStream => _filtersSubject.stream;

  List<int> get years => _navigator.getYears().map((e) => int.parse(e)).toList();

  String get pageName => _navigator != null ? _navigator.pageName : "";

  String regionName;

  List<String> get regions => _navigator.regionsNames;

  void onYearFiltersChanged(Pair<String, String> years) {
    _navigator.onYearFiltersChanged(years);
    _updatePageData();
  }

  void _loadNewRegion() {
    loadData(region: _navigator.regionId);
  }

  void onPrevEducationLevelPressed() {
    _navigator.prevEducationLevelPage();
    _updatePageData();
  }

  void onNextEducationLevelPressed() {
    _navigator.nextEducationLevelPage();
    _updatePageData();
  }

  void onRegionChanged() {
    _loadNewRegion();
    _updatePageData();
  }
}
