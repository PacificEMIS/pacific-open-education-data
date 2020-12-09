import 'dart:core';

import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/wash/question.dart';
import 'package:pacific_dashboards/models/wash/wash.dart';
import 'package:pacific_dashboards/models/wash/wash_chunk.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:pacific_dashboards/pages/wash/components/totals/totals_view_data.dart';
import 'package:pacific_dashboards/pages/wash/components/toilets/toilets_data.dart';
import 'package:pacific_dashboards/pages/wash/components/totals/totals_question_selector_page.dart';
import 'package:pacific_dashboards/pages/wash/components/water/water_data.dart';
import 'package:rxdart/rxdart.dart';

class WashViewModel extends BaseViewModel {
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

  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<String> _pageNoteSubject = BehaviorSubject();
  final Subject<WashToiletViewData> _toiletsDataSubject = BehaviorSubject();
  final Subject<WashWaterViewData> _waterDataSubject = BehaviorSubject();
  final Subject<WashTotalsViewData> _totalsDataSubject = BehaviorSubject();
  final Subject<List<Filter>> _filtersSubject = BehaviorSubject();

  WashChunk _washChunk;
  List<Filter> _filters;
  Lookups _lookups;
  Question _selectedQuestion;

  Stream<WashToiletViewData> get toiletsDataStream =>
      _toiletsDataSubject.stream;

  Stream<WashWaterViewData> get waterDataStream => _waterDataSubject.stream;

  Stream<WashTotalsViewData> get totalsDataStream => _totalsDataSubject.stream;

  Stream<String> get noteStream => _pageNoteSubject.stream;

  Stream<List<Filter>> get filtersStream => _filtersSubject.stream;

  @override
  void onInit() {
    super.onInit();
    _pageNoteSubject.disposeWith(disposeBag);
    _toiletsDataSubject.disposeWith(disposeBag);
    _filtersSubject.disposeWith(disposeBag);
    _waterDataSubject.disposeWith(disposeBag);
    _totalsDataSubject.disposeWith(disposeBag);
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
      handleRepositoryFetch(fetch: _repository.fetchAllWashChunk),
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
    await _updateQuestionTotals();

    final filteredChunk = await _washChunk.applyFilters(_filters);
    final washModel = _WashModel(
      filteredChunk,
      _lookups,
    );

    _toiletsDataSubject.add(
      await compute<_WashModel, WashToiletViewData>(
        _calculateToiletsData,
        washModel,
      ),
    );

    _waterDataSubject.add(
      await compute<_WashModel, WashWaterViewData>(
        _calculateWaterData,
        washModel,
      ),
    );
  }

  Future<void> _updateQuestionTotals() async {
    final filteredChunk = await _washChunk.applyFilters(_filters);
    final questionsLookups = filteredChunk.questions;

    _totalsDataSubject.add(
      await compute<_TotalsModel, WashTotalsViewData>(
        _calculateTotalsData,
        _TotalsModel(
          filteredChunk.total,
          questionsLookups,
          _selectedQuestion,
          _selectedYear(_filters),
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

  void onQuestionSelectorPressed() {
    launchHandled(() async {
      final newSelectedQuestion = await navigator.push<Question>(
        MaterialPageRoute(builder: (context) {
          return TotalsQuestionSelectorPage(
            questions: _washChunk.questions
                .where((element) => !element.id.contains('BS'))
                .toList(),
            initiallySelectedQuestion: _selectedQuestion,
          );
        }),
      );
      if (newSelectedQuestion != _selectedQuestion) {
        _selectedQuestion = newSelectedQuestion;
        await _updateQuestionTotals();
      }
    });
  }
}

class _WashModel {
  const _WashModel(this.chunk, this.lookups);

  final WashChunk chunk;
  final Lookups lookups;
}

class _TotalsModel {
  const _TotalsModel(
    this.washData,
    this.lookups,
    this.selectedQuestion,
    this.year,
  );

  final List<Wash> washData;
  final List<Question> lookups;
  final Question selectedQuestion;
  final int year;
}

int _selectedYear(List<Filter> filters) {
  return filters.firstWhere((it) => it.id == 0).intValue;
}

Future<WashToiletViewData> _calculateToiletsData(
  _WashModel model,
) async {
  final toiletsData = model.chunk.toilets;

  final totalToilets = <SchoolDataByToiletType>[];
  final usableToilets = <SchoolDataByToiletType>[];
  final usablePercent = <SchoolDataByPercent>[];
  final usablePercentByGender = <SchoolDataByGenderPercent>[];
  final pupilsByToilet = <SchoolDataByPupils>[];
  final pupilsByToiletByGender = <SchoolDataByGender>[];
  final pupilsByUsableToilet = <SchoolDataByPupils>[];
  final pupilsByUsableToiletByGender = <SchoolDataByGender>[];
  final pupils = <SchoolDataByGender>[];

  for (final it in toiletsData) {
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

Future<WashWaterViewData> _calculateWaterData(
  _WashModel model,
) async {
  final waterData = model.chunk.water;

  final available = <WaterViewDataBySchool>[];
  final usedForDrinking = <WaterViewDataBySchool>[];

  for (final it in waterData) {
    final school = it.schNo;
    available.add(WaterViewDataBySchool(
      school: school,
      pipedWaterSupply: it.isPipedWaterSupplyCurrentlyAvailable ? 1 : 0,
      protectedWell: it.isProtectedWellCurrentlyAvailable ? 1 : 0,
      unprotectedWellSpring:
          it.isUnprotectedWellSpringCurrentlyAvailable ? 1 : 0,
      rainwater: it.isRainwaterCurrentlyAvailable ? 1 : 0,
      bottled: it.isBottledWaterCurrentlyAvailable ? 1 : 0,
      tanker: it.isTankerTruckCartCurrentlyAvailable ? 1 : 0,
      surfaced: it.isSurfacedWaterCurrentlyAvailable ? 1 : 0,
    ));
    usedForDrinking.add(WaterViewDataBySchool(
      school: school,
      pipedWaterSupply: it.isPipedWaterSupplyUsedForDrinking ? 1 : 0,
      protectedWell: it.isProtectedWellUsedForDrinking ? 1 : 0,
      unprotectedWellSpring: it.isUnprotectedWellSpringUsedForDrinking ? 1 : 0,
      rainwater: it.isRainwaterUsedForDrinking ? 1 : 0,
      bottled: it.isBottledWaterUsedForDrinking ? 1 : 0,
      tanker: it.isTankerTruckCartUsedForDrinking ? 1 : 0,
      surfaced: it.isSurfacedWaterUsedForDrinking ? 1 : 0,
    ));
  }

  return WashWaterViewData(
    available: available,
    usedForDrinking: usedForDrinking,
  );
}

Future<WashTotalsViewData> _calculateTotalsData(
  _TotalsModel model,
) async {
  if (model.selectedQuestion == null) {
    return WashTotalsViewData(
      selectedQuestion: null,
      data: null,
      year: model.year,
    );
  }

  final data = <WashTotalsViewDataByDistrict>[];

  model.washData
      .where((element) => element.question == model.selectedQuestion.id)
      .groupBy((element) => element.district)
      .forEach((district, washDataEntries) {
    final dataByAnswers = <WashTotalsViewDataByAnswer>[];
    washDataEntries
        .groupBy((element) => element.result)
        .forEach((answer, washDataEntries) {
      var evaluated = 0;
      var accumulated = 0;

      for (final it in washDataEntries) {
        evaluated += it.numThisYear;
        accumulated += it.number;
      }

      dataByAnswers.add(WashTotalsViewDataByAnswer(
        answer: answer,
        accumulated: accumulated,
        evaluated: evaluated,
      ));
    });

    data.add(WashTotalsViewDataByDistrict(
      district: district,
      answerDataList: dataByAnswers,
    ));
  });

  return WashTotalsViewData(
    selectedQuestion: model.selectedQuestion,
    data: data,
    year: model.year,
  );
}
