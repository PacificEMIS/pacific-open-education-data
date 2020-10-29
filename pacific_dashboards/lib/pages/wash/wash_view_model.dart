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

import 'components/toilets/toilets_data.dart';

class WashViewModel extends BaseViewModel {
  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<String> _pageNoteSubject = BehaviorSubject();
  final Subject<WashToiletViewData> _toiletsDataSubject = BehaviorSubject();
  final Subject<List<Filter>> _filtersSubject = BehaviorSubject();

  WashChunk _washChunk;
  List<Filter> _filters;
  Lookups _lookups;

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

  Stream<WashToiletViewData> get toiletsDataStream =>
      _toiletsDataSubject.stream;

  Stream<String> get noteStream => _pageNoteSubject.stream;

  Stream<List<Filter>> get filtersStream => _filtersSubject.stream;

  @override
  void onInit() {
    super.onInit();
    _pageNoteSubject.disposeWith(disposeBag);
    _toiletsDataSubject.disposeWith(disposeBag);
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
          _washChunk = wash;
          _filters = await _initFilters();
          _filtersSubject.add(_filters);
          await _updatePageData();
        },
      );

  Future<void> _updatePageData() async {
    _toiletsDataSubject.add(
      await compute<_WashModel, WashToiletViewData>(
        _calculateToiletsData,
        _WashModel(
          _washChunk,
          _lookups,
          _filters,
        ),
      ),
    );
  }

  Future<List<Filter>> _initFilters() async {
    if (_washChunk == null || _lookups == null) {
      return [];
    }
    return _washChunk.generateDefaultFilters(_lookups);
  }

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

Future<WashToiletViewData> _calculateToiletsData(
  _WashModel model,
) async {
  final chunk = model.chunk;
  final filters = model.filters;
  final filteredChunk = await chunk.applyFilters(filters);
  final currentYear = _selectedYear(filters);
  final toiletsDataOnCurrentYear = filteredChunk.toilets
      .where((it) => it.surveyYear == currentYear)
      .toList();

  final totalToilets = <SchoolDataByToiletType>[];
  final usableToilets = <SchoolDataByToiletType>[];
  final usablePercent = <SchoolDataByPercent>[];
  final usablePercentByGender = <SchoolDataByGenderPercent>[];
  final pupilsByToilet = <SchoolDataByPupils>[];
  final pupilsByToiletByGender = <SchoolDataByGender>[];
  final pupilsByUsableToilet = <SchoolDataByPupils>[];
  final pupilsByUsableToiletByGender = <SchoolDataByGender>[];
  final pupils = <SchoolDataByGender>[];

  for (var it in toiletsDataOnCurrentYear) {
    final school = it.schNo;
    totalToilets.add(SchoolDataByToiletType(
      school: school,
      boys: it.totalM,
      girls: it.totalF,
      common: it.totalC,
    ));
    usableToilets.add(SchoolDataByToiletType(
      school: school,
      boys: it.usableM,
      girls: it.usableF,
      common: it.usableC,
    ));
    usablePercent.add(SchoolDataByPercent(
      school: school,
      percent: it.total > 0 ? (it.usable / it.total * 100).round() : 0,
    ));
    usablePercentByGender.add(SchoolDataByGenderPercent(
      school: school,
      percentMale: it.totalM > 0 ? (it.usableM / it.totalM * 100).round() : 0,
      percentFemale: it.totalF > 0 ? (it.usableF / it.totalF * 100).round() : 0,
    ));
    pupilsByToilet.add(SchoolDataByPupils(
      school: school,
      pupils: it.total > 0 ? (it.enrol / it.total * 100).round() : 0,
    ));
    pupilsByToiletByGender.add(SchoolDataByGender(
      school: school,
      male: it.totalM > 0 ? (it.enrolM / it.totalM * 100).round() : 0,
      female: it.totalF > 0 ? (it.enrolF / it.totalF * 100).round() : 0,
    ));
    pupilsByUsableToilet.add(SchoolDataByPupils(
      school: school,
      pupils: it.usable > 0 ? (it.enrol / it.usable * 100).round() : 0,
    ));
    pupilsByUsableToiletByGender.add(SchoolDataByGender(
      school: school,
      male: it.usableM > 0 ? (it.enrolM / it.usableM * 100).round() : 0,
      female: it.usableF > 0 ? (it.enrolF / it.usableF * 100).round() : 0,
    ));
    pupils.add(SchoolDataByGender(
      school: school,
      male: it.enrolM,
      female: it.enrolF,
    ));
  }

  return WashToiletViewData(
    totalToilets: totalToilets,
    usableToilets: usableToilets,
    usablePercent: usablePercent,
    usablePercentByGender: usablePercentByGender,
    pupilsByToilet: pupilsByToilet,
    pupilsByToiletByGender: pupilsByToiletByGender,
    pupilsByUsableToilet: pupilsByUsableToilet,
    pupilsByUsableToiletByGender: pupilsByUsableToiletByGender,
    pupils: pupils,
  );
}

int _selectedYear(List<Filter> filters) {
  return filters.firstWhere((it) => it.id == 0).intValue;
}

// List<Filter> _generateQuestionFilters(Lookups lookups, List<Wash> wash) {
//   return List.of([
//     Filter(
//       id: 0,
//       title: '',
//       items: [
//         ...wash
//             .uniques((it) => it.question)
//             .map((it) => FilterItem(it, it.from(lookups.authorities))),
//       ],
//       selectedIndex: 0,
//     ),
//   ]);
// }

// List<ListData> _generateWashTotal(
//     Map<String, List<Wash>> washGroupedByDistricts, int year) {
//   List<ListData> washTotalData = [];
//
//   washGroupedByDistricts.forEach((district, values) {
//     int evaluated = 0;
//     int cumulative = 0;
//
//     for (var data in values) {
//       if (data.surveyYear == year) evaluated += data.numThisYear;
//
//       cumulative += data.number;
//     }
//
//     washTotalData
//         .add(new ListData(title: district, values: [evaluated, cumulative]));
//   });
//   return washTotalData.chainSort((lv, rv) => rv.title.compareTo(lv.title));
// }
//
// _generateWashWater(Map<String, List<Water>> washGroupedBySchNo, int year) {
//   List<WaterData> waterDataUsedForDrinking = new List();
//   List<WaterData> waterDataCurrentlyAvailable = new List();
//
//   Map<String, List<WaterData>> waterModelList = new Map();
//
//   washGroupedBySchNo.forEach((schNo, values) {
//     Map<String, int> usedForDrinking = new Map();
//     Map<String, int> currentlyAvailable = new Map();
//
//     currentlyAvailable['Piped Water Supply'] = 0;
//     usedForDrinking['Piped Water Supply'] = 0;
//     currentlyAvailable['Protected Well'] = 0;
//     usedForDrinking['Protected Well'] = 0;
//     currentlyAvailable['Unprotected Well Spring'] = 0;
//     usedForDrinking['Unprotected Well Spring'] = 0;
//     currentlyAvailable['Rainwater'] = 0;
//     usedForDrinking['Rainwater'] = 0;
//     currentlyAvailable['Bottled Water'] = 0;
//     usedForDrinking['Bottled Water'] = 0;
//
//     currentlyAvailable['Tanker/Truck or Cart'] = 0;
//     usedForDrinking['Tanker/Truck or Cart'] = 0;
//     currentlyAvailable['Surfaced Water (Lake, River, Stream)'] = 0;
//     usedForDrinking['Surfaced Water (Lake, River, Stream)'] = 0;
//
//     for (var data in values) {
//       if (data.surveyYear == year) {
//         if (data.pipedWaterSupplyCurrentlyAvailable.compareTo('Yes') == 0)
//           currentlyAvailable['Piped Water Supply'] += 1;
//         if (data.pipedWaterSupplyUsedForDrinking.compareTo('Yes') == 0)
//           usedForDrinking['Piped Water Supply'] += 1;
//         if (data.protectedWellCurrentlyAvailable.compareTo('Yes') == 0)
//           currentlyAvailable['Protected Well'] += 1;
//         if (data.protectedWellUsedForDrinking.compareTo('Yes') == 0)
//           usedForDrinking['Protected Well'] += 1;
//         if (data.unprotectedWellSpringCurrentlyAvailable.compareTo('Yes') == 0)
//           currentlyAvailable['Unprotected Well Spring'] += 1;
//         if (data.unprotectedWellSpringUsedForDrinking.compareTo('Yes') == 0)
//           usedForDrinking['Unprotected Well Spring'] += 1;
//         if (data.rainwaterCurrentlyAvailable.compareTo('Yes') == 0)
//           currentlyAvailable['Rainwater'] += 1;
//         if (data.rainwaterUsedForDrinking.compareTo('Yes') == 0)
//           usedForDrinking['Rainwater'] += 1;
//         if (data.bottledWaterCurrentlyAvailable.compareTo('Yes') == 0)
//           currentlyAvailable['Bottled Water'] += 1;
//         if (data.bottledWaterUsedForDrinking.compareTo('Yes') == 0)
//           usedForDrinking['Bottled Water'] += 1;
//         if (data.tankerTruckCartCurrentlyAvailable.compareTo('Yes') == 0)
//           currentlyAvailable['Tanker/Truck or Cart'] += 1;
//         if (data.tankerTruckCartUsedForDrinking.compareTo('Yes') == 0)
//           usedForDrinking['Tanker/Truck or Cart'] += 1;
//         if (data.surfacedWaterCurrentlyAvailable.compareTo('Yes') == 0)
//           currentlyAvailable['Surfaced Water (Lake, River, Stream)'] += 1;
//         if (data.surfacedWaterUsedForDrinking.compareTo('Yes') == 0)
//           usedForDrinking['Surfaced Water (Lake, River, Stream)'] += 1;
//       }
//     }
//
//     waterDataUsedForDrinking
//         .add(WaterData(title: schNo, values: usedForDrinking));
//
//     waterDataCurrentlyAvailable
//         .add(WaterData(title: schNo, values: currentlyAvailable));
//   });
//
//   waterModelList['Used For Drinking'] = waterDataUsedForDrinking;
//   waterModelList['Currently Available'] = waterDataCurrentlyAvailable;
//
//   return waterModelList;
// }
