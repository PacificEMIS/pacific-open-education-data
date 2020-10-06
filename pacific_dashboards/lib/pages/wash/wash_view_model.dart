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
    }, notifyProgress: true);
  }

  void _loadData() {
    handleRepositoryFetch(fetch: () => _repository.fetchAllWashChunk())
        .doOnListen(() => notifyHaveProgress(true))
        .doOnDone(() => notifyHaveProgress(false))
        .listen(
          _onDataLoaded,
          onError: handleThrows,
          cancelOnError: false,
        )
        .disposeWith(disposeBag);
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

  final lookups = model.lookups;
  return WashData(
      year: _year(filters).toString(),
      showAllData: _showAllData(filters),
      washModelList:
          _generateWashTotal(filteredChunk.total.groupBy((it) => it.district)),
      toiletsModelList:
          _generateWashToilets(filteredChunk.toilets.groupBy((it) => it.schNo)),
      waterModelList:
        _generateWashWater(filteredChunk.water.groupBy((it) => it.schNo)));
}

bool _showAllData(List<Filter> filters) {
  return filters.firstWhere((it) => it.id == 0).intValue == 1;
}

int _year(List<Filter> filters) {
  return filters.firstWhere((it) => it.id == 1).intValue;
}

List<ListData> _generateWashTotal(
    Map<String, List<Wash>> washGroupedByDistricts) {
  List<ListData> washTotalData = [];

  washGroupedByDistricts.forEach((district, values) {
    int evaluated = 0;
    int cumulative = 0;

    for (var data in values) {
      evaluated += data.numThisYear;
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

    int usableToilets = 0;
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
      usableToilets += data.usable;
      //Enroll
      enrolF += data.enrolF;
      enrolM += data.enrolM;
    }

    pupilsUsableToilet += toiletsTotalF - toiletsTotalM;
    toiletsTotal += toiletsTotalF + toiletsTotalM;
    if (pupilsUsableToilet != 0)
      usablePercentage = (pupilsUsableToilet * 100).toInt();
    // usableFPercentage =
    //     pupilsUsableToilet != 0 ? (pupilsUsableToilet * 100).ceil : 0;
    // usableMPercentage =
    //     pupilsUsableToilet != 0 ? (pupilsUsableToilet * 100).ceil : 0;

    toiletsData.add(new ListData(title: district, values: [
      toiletsTotalF,
      toiletsTotalM,
      usableToiletsF,
      usableToiletsM,
      usableToilets,
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
  List<ListData> waterData = [];

  washGroupedBySchNo.forEach((schNo, values) {
    int pipedWaterSupplyCurrentlyAvailable = 0;
    int pipedWaterSupplyUsedForDrinking = 0;
    int protectedWellCurrentlyAvailable = 0;
    int protectedWellUsedForDrinking = 0;
    int unprotectedWellSpringCurrentlyAvailable = 0;
    int unprotectedWellSpringUsedForDrinking = 0;
    int rainwaterUsedForDrinking = 0;
    int bottledWaterCurrentlyAvailable = 0;
    int bottledWaterUsedForDrinking = 0;

    int tankerTruckCartCurrentlyAvailable = 0;
    int tankerTruckCartUsedForDrinking = 0;
    int surfacedWaterCurrentlyAvailable = 0;
    int surfacedWaterUsedForDrinking = 0;

    for (var data in values) {
      pipedWaterSupplyCurrentlyAvailable +=
          data.pipedWaterSupplyCurrentlyAvailable == 'YES' ? 1 : 0;
      pipedWaterSupplyUsedForDrinking += data.pipedWaterSupplyUsedForDrinking == 'YES' ? 1 : 0;
      protectedWellCurrentlyAvailable += data.protectedWellCurrentlyAvailable == 'YES' ? 1 : 0;
      protectedWellUsedForDrinking += data.protectedWellUsedForDrinking == 'YES' ? 1 : 0;
      unprotectedWellSpringCurrentlyAvailable +=
          data.unprotectedWellSpringCurrentlyAvailable == 'YES' ? 1 : 0;
      unprotectedWellSpringUsedForDrinking +=
          data.unprotectedWellSpringUsedForDrinking == 'YES' ? 1 : 0;
      rainwaterUsedForDrinking += data.rainwaterUsedForDrinking == 'YES' ? 1 : 0;
      bottledWaterCurrentlyAvailable += data.bottledWaterCurrentlyAvailable == 'YES' ? 1 : 0;
      bottledWaterUsedForDrinking += data.bottledWaterUsedForDrinking == 'YES' ? 1 : 0;
      tankerTruckCartCurrentlyAvailable +=
          data.tankerTruckCartCurrentlyAvailable == 'YES' ? 1 : 0;
      tankerTruckCartUsedForDrinking += data.tankerTruckCartUsedForDrinking == 'YES' ? 1 : 0;
      surfacedWaterCurrentlyAvailable += data.surfacedWaterCurrentlyAvailable == 'YES' ? 1 : 0;
      surfacedWaterUsedForDrinking += data.surfacedWaterUsedForDrinking == 'YES' ? 1 : 0;
    }

    waterData.add(new ListData(title: schNo, values: [
      pipedWaterSupplyCurrentlyAvailable,
      pipedWaterSupplyUsedForDrinking,
      protectedWellCurrentlyAvailable,
      protectedWellUsedForDrinking,
      unprotectedWellSpringCurrentlyAvailable,
      unprotectedWellSpringUsedForDrinking,
      rainwaterUsedForDrinking,
      bottledWaterCurrentlyAvailable,
      bottledWaterUsedForDrinking,
      tankerTruckCartCurrentlyAvailable,
      tankerTruckCartUsedForDrinking,
      surfacedWaterCurrentlyAvailable,
      surfacedWaterUsedForDrinking
    ]));
  });
  return waterData;
}
