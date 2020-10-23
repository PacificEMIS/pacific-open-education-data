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

  Future<void> _onDataLoaded(WashChunk wash) => launchHandled(
        () async {
          _lookups = await _repository.lookups.first;
          _wash = wash;
          _filters = await _initFilters();
          _filtersSubject.add(_filters);
          await _updatePageData();
        },
      );

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
  final questions = generateQuestionFilters(model.lookups, model.chunk.total);
  var currentYear = _selectedYear(filters);
  return WashData(
      year: currentYear.toString(),
      washModelList: _generateWashTotal(
          filteredChunk.total.groupBy((it) => it.district), currentYear),
      toiletsModelList: _generateWashToilets(
          filteredChunk.toilets.groupBy((it) => it.schNo), currentYear),
      waterModelList: _generateWashWater(
          filteredChunk.water.groupBy((it) => it.schNo), currentYear),
      questions: questions);

}

int _selectedYear(List<Filter> filters) {
  return filters.firstWhere((it) => it.id == 0).intValue;
}

List<Filter> generateQuestionFilters(Lookups lookups, List<Wash> wash) {
  return List.of([
    Filter(
      id: 0,
      title: '',
      items: [
        FilterItem(null, 'filtersDisplayAllAuthority'),
        ...wash
            .uniques((it) => it.question)
            .map((it) => FilterItem(it, it.from(lookups.authorities))),
      ],
      selectedIndex: 0,
    ),
  ]);
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

Map<String, List<WaterData>> _generateWashToilets(
    Map<String, List<Toilets>> washGroupedByDistricts, int year) {
  List<WaterData> dataToiletsTotal = new List();
  List<WaterData> dataUsableToiletsTotal = new List();
  List<WaterData> dataUsablePercentage = new List();
  List<WaterData> dataUsablePercentageGender = new List();
  List<WaterData> dataPupilsToilet = new List();
  List<WaterData> dataPupilsToiletGender = new List();
  List<WaterData> dataPupilsUsableToilet = new List();
  List<WaterData> dataPupilsUsageToiletGender = new List();
  List<WaterData> dataPupils = new List();
  List<WaterData> dataPupilsMirrorFormat = new List();

  Map<String, List<WaterData>> waterModelList = new Map();

  washGroupedByDistricts.forEach((schNo, values) {
    Map<String, int> toiletsTotal = new Map();
    Map<String, int> usableToilets = new Map();

    Map<String, int> usablePercentage = new Map();
    Map<String, int> percentageUsableGender = new Map();

    Map<String, int> pupilsToilet = new Map();
    Map<String, int> pupilsToiletGender = new Map();
    Map<String, int> enrollment = new Map();
    Map<String, int> pupilsUsageToilet = new Map();
    Map<String, int> pupilsUsageToiletGender = new Map();
    Map<String, int> pupils = new Map();
    Map<String, int> pupilsMirrorFormat = new Map();

    toiletsTotal['M'] = 0;
    toiletsTotal['F'] = 0;

    usableToilets['M'] = 0;
    usableToilets['F'] = 0;

    usablePercentage['Usable %'] = 0;

    percentageUsableGender['M'] = 0;
    percentageUsableGender['F'] = 0;

    enrollment['M'] = 0;
    enrollment['F'] = 0;

    pupilsToiletGender['M'] = 0;
    pupilsToiletGender['F'] = 0;

    pupilsUsageToilet['Pupils'] = 0;

    pupils['M'] = 0;
    pupils['F'] = 0;

    pupilsMirrorFormat['M'] = 0;
    pupilsMirrorFormat['F'] = 0;

    pupilsUsageToiletGender['F'] = 0;
    pupilsUsageToiletGender['M'] = 0;

    pupilsToilet['Pupils'] = 0;

    for (var data in values) {
      if (data.surveyYear == year) {
        toiletsTotal['M'] += data.totalM;
        toiletsTotal['F'] += data.totalF;

        usableToilets['M'] += data.usableM;
        usableToilets['F'] += data.usableF;

        if (data.enrolM != 0) enrollment['M'] += data.enrolM;

        if (data.enrolF != 0) enrollment['F'] += data.enrolF;

        pupils['M'] += data.enrolM;
        pupils['F'] += data.enrolF;

        pupilsMirrorFormat['M'] += data.enrolM;
        pupilsMirrorFormat['F'] += data.enrolF;
      }
    }

    //Pupils
    if (toiletsTotal['M'] != 0 && usableToilets['F'] != 0) {
      pupilsUsageToilet['Pupils'] += ((enrollment['M'] + enrollment['F']) ~/
              (usableToilets['F'] + usableToilets['M']))
          .round();
      pupilsUsageToiletGender['M'] +=
          (enrollment['M'] ~/ usableToilets['M']).round();
      pupilsUsageToiletGender['F'] +=
          (enrollment['F'] ~/ usableToilets['F']).round();
    }

    //Pupils toilet
    if ((toiletsTotal['M'] + toiletsTotal['F']) != 0)
      pupilsToilet['Pupils'] = (((enrollment['M'] + enrollment['F'])) ~/
              (toiletsTotal['M'] + toiletsTotal['F']))
          .round();
    if ((toiletsTotal['M']) != 0)
      pupilsToiletGender['M'] = (enrollment['M'] ~/ toiletsTotal['M']).round();
    if ((toiletsTotal['F']) != 0)
      pupilsToiletGender['F'] = (enrollment['F'] ~/ toiletsTotal['F']).round();

    //Pupils toilet
    if ((toiletsTotal['M'] + toiletsTotal['F']) != 0)
      pupilsToilet['Pupils'] = (((enrollment['M'] + enrollment['F'])) ~/
              (toiletsTotal['M'] + toiletsTotal['F']))
          .round();

    //Usable percentage
    if ((toiletsTotal['M'] + toiletsTotal['F']) != 0)
      usablePercentage['Usable %'] =
          ((usableToilets['M'] + usableToilets['F']) /
                  (toiletsTotal['M'] + toiletsTotal['F']) *
                  100)
              .round();

    //Usable percentage gender
    if (toiletsTotal['M'] != 0)
      percentageUsableGender['M'] +=
          ((usableToilets['M'] / toiletsTotal['M']) * 100).round();
    if (toiletsTotal['F'] != 0)
      percentageUsableGender['F'] +=
          ((usableToilets['F'] / toiletsTotal['F']) * 100).round();

    dataToiletsTotal.add(WaterData(title: schNo, values: toiletsTotal));
    dataUsableToiletsTotal.add(WaterData(title: schNo, values: usableToilets));
    dataUsablePercentage.add(WaterData(title: schNo, values: usablePercentage));
    dataUsablePercentageGender
        .add(WaterData(title: schNo, values: percentageUsableGender));
    dataPupilsToilet.add(WaterData(title: schNo, values: pupilsToilet));
    dataPupilsToiletGender
        .add(WaterData(title: schNo, values: pupilsToiletGender));
    dataPupilsUsableToilet
        .add(WaterData(title: schNo, values: pupilsUsageToilet));
    dataPupilsUsageToiletGender
        .add(WaterData(title: schNo, values: pupilsUsageToiletGender));
    dataPupils.add(WaterData(title: schNo, values: pupils));
    dataPupilsMirrorFormat
        .add(WaterData(title: schNo, values: pupilsMirrorFormat));
  });

  waterModelList['Toilets (Total)'] = dataToiletsTotal;
  waterModelList['Usable Toilets'] = dataUsableToiletsTotal;
  waterModelList['% Usable'] = dataUsablePercentage;
  waterModelList['% Usable (gender)'] = dataUsablePercentageGender;
  waterModelList['Pupils / toilet'] = dataPupilsToilet;
  waterModelList['Pupils / toilet (gender)'] = dataPupilsToiletGender;
  waterModelList['Pupils / usable toilet'] = dataPupilsUsableToilet;
  waterModelList['Pupils / usable toilet (gender)'] = dataPupilsUsageToiletGender;
  waterModelList['Pupils'] = dataPupils;
  waterModelList['Pupils(mirror format)'] = dataPupilsMirrorFormat;

  return waterModelList;
}

_generateWashWater(Map<String, List<Water>> washGroupedBySchNo, int year) {
  List<WaterData> waterDataUsedForDrinking = new List();
  List<WaterData> waterDataCurrentlyAvailable = new List();

  Map<String, List<WaterData>> waterModelList = new Map();

  washGroupedBySchNo.forEach((schNo, values) {
    Map<String, int> usedForDrinking = new Map();
    Map<String, int> currentlyAvailable = new Map();

    currentlyAvailable['Piped Water Supply'] = 0;
    usedForDrinking['Piped Water Supply'] = 0;
    currentlyAvailable['Protected Well'] = 0;
    usedForDrinking['Protected Well'] = 0;
    currentlyAvailable['Unprotected Well Spring'] = 0;
    usedForDrinking['Unprotected Well Spring'] = 0;
    currentlyAvailable['Rainwater'] = 0;
    usedForDrinking['Rainwater'] = 0;
    currentlyAvailable['Bottled Water'] = 0;
    usedForDrinking['Bottled Water'] = 0;

    currentlyAvailable['Tanker/Truck or Cart'] = 0;
    usedForDrinking['Tanker/Truck or Cart'] = 0;
    currentlyAvailable['Surfaced Water (Lake, River, Stream)'] = 0;
    usedForDrinking['Surfaced Water (Lake, River, Stream)'] = 0;

    for (var data in values) {
      if (data.surveyYear == year) {
        if (data.pipedWaterSupplyCurrentlyAvailable.compareTo('Yes') == 0)
          currentlyAvailable['Piped Water Supply'] += 1;
        if (data.pipedWaterSupplyUsedForDrinking.compareTo('Yes') == 0)
          usedForDrinking['Piped Water Supply'] += 1;
        if (data.protectedWellCurrentlyAvailable.compareTo('Yes') == 0)
          currentlyAvailable['Protected Well'] += 1;
        if (data.protectedWellUsedForDrinking.compareTo('Yes') == 0)
          usedForDrinking['Protected Well'] += 1;
        if (data.unprotectedWellSpringCurrentlyAvailable.compareTo('Yes') == 0)
          currentlyAvailable['Unprotected Well Spring'] += 1;
        if (data.unprotectedWellSpringUsedForDrinking.compareTo('Yes') == 0)
          usedForDrinking['Unprotected Well Spring'] += 1;
        if (data.rainwaterCurrentlyAvailable.compareTo('Yes') == 0)
          currentlyAvailable['Rainwater'] += 1;
        if (data.rainwaterUsedForDrinking.compareTo('Yes') == 0)
          usedForDrinking['Rainwater'] += 1;
        if (data.bottledWaterCurrentlyAvailable.compareTo('Yes') == 0)
          currentlyAvailable['Bottled Water'] += 1;
        if (data.bottledWaterUsedForDrinking.compareTo('Yes') == 0)
          usedForDrinking['Bottled Water'] += 1;
        if (data.tankerTruckCartCurrentlyAvailable.compareTo('Yes') == 0)
          currentlyAvailable['Tanker/Truck or Cart'] += 1;
        if (data.tankerTruckCartUsedForDrinking.compareTo('Yes') == 0)
          usedForDrinking['Tanker/Truck or Cart'] += 1;
        if (data.surfacedWaterCurrentlyAvailable.compareTo('Yes') == 0)
          currentlyAvailable['Surfaced Water (Lake, River, Stream)'] += 1;
        if (data.surfacedWaterUsedForDrinking.compareTo('Yes') == 0)
          usedForDrinking['Surfaced Water (Lake, River, Stream)'] += 1;
      }
    }

    waterDataUsedForDrinking
        .add(WaterData(title: schNo, values: usedForDrinking));

    waterDataCurrentlyAvailable
        .add(WaterData(title: schNo, values: currentlyAvailable));
  });

  waterModelList['Used For Drinking'] = waterDataCurrentlyAvailable;
  waterModelList['Currently Available'] = waterDataUsedForDrinking;

  return waterModelList;
}
