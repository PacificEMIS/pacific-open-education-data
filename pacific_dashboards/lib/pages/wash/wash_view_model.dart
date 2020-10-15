import 'dart:core';

import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/wash/toilets.dart';
import 'package:pacific_dashboards/models/wash/wash.dart';
import 'package:pacific_dashboards/models/wash/wash_chunk.dart';
import 'package:pacific_dashboards/models/wash/water.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:rxdart/rxdart.dart';

import 'wash_data.dart';

class WashViewModel extends BaseViewModel {
  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<String> _pageNoteSubject = BehaviorSubject();
  final Subject<WashData> _dataSubject = BehaviorSubject();
  final Subject<List<Filter>> _filtersSubject = BehaviorSubject();

  WashViewModel(
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

  WashChunk _wash;
  List<Filter> _filters;
  Lookups _lookups;

  @override
  void onInit() {
    super.onInit();
    _pageNoteSubject.disposeWith(disposeBag);
    _dataSubject.disposeWith(disposeBag);
    _filtersSubject.disposeWith(disposeBag);
    _loadNote();
    _loadData();
  }

  void _loadNote() {
    launchHandled(() async {
      final note = (await _remoteConfig.emises)
          .getEmisConfigFor(await _globalSettings.currentEmis)
          ?.moduleConfigFor(Section.wash)
          ?.note;
      _pageNoteSubject.add(note);
    });
  }

  void _loadData() {
    listenHandled(
      handleRepositoryFetch(fetch: () => _repository.fetchAllWashChunk()),
      _onDataLoaded,
      notifyProgress: true,
    );
  }

  void _onDataLoaded(WashChunk wash) {
    launchHandled(() async {
      _lookups = await _repository.lookups.first;
      _wash = wash;
      _filters = await _initFilters();
      _filtersSubject.add(_filters);
      await _updatePageData();
    });
  }

  Future<void> _updatePageData() async {
    _dataSubject.add(
      await compute<_WashModel, WashData>(
        _calculateData,
        _WashModel(
          _wash,
          _lookups,
          _filters,
        ),
      ),
    );
  }

  Future<List<Filter>> _initFilters() async {
    if (_wash == null || _lookups == null) {
      return [];
    }
    return _wash.generateDefaultFilters(_lookups);
  }

  Stream<String> get noteStream => _pageNoteSubject.stream;

  Stream<WashData> get dataStream => _dataSubject.stream;

  Stream<List<Filter>> get filtersStream => _filtersSubject.stream;

  void onFiltersChanged(List<Filter> filters) {
    launchHandled(() async {
      _filters = filters;
      await _updatePageData();
    });
  }
}

class _WashModel {
  final WashChunk chunk;
  final Lookups lookups;
  final List<Filter> filters;

  const _WashModel(this.chunk, this.lookups, this.filters);
}

Future<WashData> _calculateData(
  _WashModel model,
) async {
  final chunk = model.chunk;
  final filters = model.filters;
  final filteredChunk = await chunk.applyFilters(filters);

  var currentYear = _selectedYear(filters);
  return WashData(
      year: currentYear.toString(),
      washModelList: _generateWashTotal(
          filteredChunk.total.groupBy((it) => it.district), currentYear),
      toiletsModelList:
          _generateWashToilets(filteredChunk.toilets.groupBy((it) => it.schNo)),
      waterModelList:
          _generateWashWater(filteredChunk.water.groupBy((it) => it.schNo)));
}

int _selectedYear(List<Filter> filters) {
  return filters.firstWhere((it) => it.id == 0).intValue;
}

List<ListData> _generateWashTotal(
    Map<String, List<Wash>> washGroupedByDistricts, int year) {
  List<ListData> washTotalData = [];

  washGroupedByDistricts.forEach((district, values) {
    int evaluated = 0;
    int cumulative = 0;

    for (var data in values) {
      if (data.surveyYear == year) evaluated += data.numThisYear;

      cumulative += data.number;
    }

    washTotalData
        .add(new ListData(title: district, values: [evaluated, cumulative]));
  });
  return washTotalData.chainSort((lv, rv) => rv.title.compareTo(lv.title));
}

List<ListData> _generateWashToilets(
    Map<String, List<Toilets>> washGroupedByDistricts) {
  List<ListData> toiletsData = [];

  washGroupedByDistricts.forEach((district, values) {
    int toiletsTotal = 0;

    int toiletsTotalF = 0;
    int toiletsTotalM = 0;

    int usableToiletsF = 0;
    int usableToiletsM = 0;
    int usablePercentage = 0;

    int usableFPercentage = 0;
    int usableMPercentage = 0;
    int enrolF = 0;
    int enrolM = 0;

    int pupilsToilet = 0;
    int pupilsToiletGender = 0;
    int pupilsUsableToilet = 0;
    int pupilsUsableToiletGender = 0;

    for (var data in values) {
      //ToiletsTotal
      toiletsTotalF += data.totalF;
      toiletsTotalM += data.totalM;

      //UsableToilets
      usableToiletsF += data.usableF;
      usableToiletsM += data.usableM;

      //Enroll
      enrolF += data.enrolF;
      enrolM += data.enrolM;
    }

    pupilsUsableToilet += toiletsTotalF - toiletsTotalM;
    toiletsTotal += toiletsTotalF + toiletsTotalM;
    if (pupilsUsableToilet != 0)
      usablePercentage = (pupilsUsableToilet * 100).toInt();

    toiletsData.add(new ListData(title: district, values: [
      toiletsTotalF,
      toiletsTotalM,
      usableToiletsF,
      usableToiletsM,
      usablePercentage,
      pupilsToilet,
      pupilsToiletGender,
      pupilsUsableToilet,
      pupilsUsableToiletGender,
      enrolF,
      enrolM
    ]));
  });
  return toiletsData;
}

_generateWashWater(Map<String, List<Water>> washGroupedBySchNo) {
  List<WaterData> waterDataUsedForDrinking = new List();
  List<WaterData> waterDataCurrentlyAvailable = new List();

  Map<String, int> usedForDrinking = new Map();
  Map<String, int> currentlyAvailable = new Map();
  Map<String, List<WaterData>> waterModelList = new Map();

  washGroupedBySchNo.forEach((schNo, values) {
    int pipedWaterSupplyCurrentlyAvailable = 0;
    int pipedWaterSupplyUsedForDrinking = 0;
    int protectedWellCurrentlyAvailable = 0;
    int protectedWellUsedForDrinking = 0;
    int unprotectedWellSpringCurrentlyAvailable = 0;
    int unprotectedWellSpringUsedForDrinking = 0;
    int rainwaterCurrentlyAvailable = 0;
    int rainwaterUsedForDrinking = 0;
    int bottledWaterCurrentlyAvailable = 0;
    int bottledWaterUsedForDrinking = 0;

    int tankerTruckCartCurrentlyAvailable = 0;
    int tankerTruckCartUsedForDrinking = 0;
    int surfacedWaterCurrentlyAvailable = 0;
    int surfacedWaterUsedForDrinking = 0;

    for (var data in values) {
      if (data.pipedWaterSupplyCurrentlyAvailable.compareTo('Yes') == 0)
        pipedWaterSupplyCurrentlyAvailable += 1;
      if (data.pipedWaterSupplyUsedForDrinking.compareTo('Yes') == 0)
      pipedWaterSupplyUsedForDrinking += 1;
      if (data.protectedWellCurrentlyAvailable.compareTo('Yes') == 0)
      protectedWellCurrentlyAvailable += 1;
      if (data.protectedWellUsedForDrinking.compareTo('Yes') == 0)
      protectedWellUsedForDrinking += 1;
      if (data.unprotectedWellSpringCurrentlyAvailable.compareTo('Yes') == 0)
      unprotectedWellSpringCurrentlyAvailable += 1;
      if (data.unprotectedWellSpringUsedForDrinking.compareTo('Yes') == 0)
      unprotectedWellSpringUsedForDrinking += 1;
      if (data.rainwaterCurrentlyAvailable.compareTo('Yes') == 0)
      rainwaterCurrentlyAvailable += 1;
      if (data.rainwaterUsedForDrinking.compareTo('Yes') == 0)
      rainwaterUsedForDrinking += 1;
      if (data.bottledWaterCurrentlyAvailable.compareTo('Yes') == 0)
      bottledWaterCurrentlyAvailable += 1;
      if (data.bottledWaterUsedForDrinking.compareTo('Yes') == 0)
      bottledWaterUsedForDrinking += 1;
      if (data.tankerTruckCartUsedForDrinking.compareTo('Yes') == 0)
      tankerTruckCartCurrentlyAvailable += 1;
      if (data.tankerTruckCartUsedForDrinking.compareTo('Yes') == 0)
      tankerTruckCartUsedForDrinking += 1;
      if (data.surfacedWaterCurrentlyAvailable.compareTo('Yes') == 0)
      surfacedWaterCurrentlyAvailable += 1;
      if (data.surfacedWaterUsedForDrinking.compareTo('Yes') == 0)
      surfacedWaterUsedForDrinking += 1;
    }

    usedForDrinking['Piped Water Supply'] = pipedWaterSupplyUsedForDrinking;
    usedForDrinking['Protected Well'] = protectedWellUsedForDrinking;
    usedForDrinking['Unprotected Well Spring'] =
        unprotectedWellSpringUsedForDrinking;
    usedForDrinking['Rainwater'] = rainwaterUsedForDrinking;
    usedForDrinking['Bottled Water'] = bottledWaterUsedForDrinking;
    usedForDrinking['Tanker/Truck or Cart'] = tankerTruckCartUsedForDrinking;
    usedForDrinking['Surfaced Water (Lake, River, Stream)'] =
        surfacedWaterUsedForDrinking;

    currentlyAvailable['Piped Water Supply'] =
        pipedWaterSupplyCurrentlyAvailable;
    currentlyAvailable['Protected Well'] = protectedWellCurrentlyAvailable;
    currentlyAvailable['Unprotected Well Spring'] =
        unprotectedWellSpringCurrentlyAvailable;
    currentlyAvailable['Rainwater'] = rainwaterCurrentlyAvailable;
    currentlyAvailable['Bottled Water'] = bottledWaterCurrentlyAvailable;
    currentlyAvailable['Tanker/Truck or Cart'] =
        tankerTruckCartCurrentlyAvailable;
    currentlyAvailable['Surfaced Water (Lake, River, Stream)'] =
        surfacedWaterCurrentlyAvailable;

    waterDataUsedForDrinking
        .add(WaterData(title: schNo, values: usedForDrinking));
    waterDataCurrentlyAvailable
        .add(WaterData(title: schNo, values: currentlyAvailable));
  });

  waterModelList['Used For Drinking'] = waterDataUsedForDrinking;
  waterModelList['Currently Available'] = waterDataCurrentlyAvailable;

  return waterModelList;
}
