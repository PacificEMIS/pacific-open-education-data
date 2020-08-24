import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/budget/budget.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:rxdart/rxdart.dart';

import 'budget_data.dart';

class BudgetViewModel extends BaseViewModel {
  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<String> _pageNoteSubject = BehaviorSubject();
  final Subject<BudgetData> _dataSubject = BehaviorSubject();
  final Subject<List<Filter>> _filtersSubject = BehaviorSubject();

  BudgetViewModel(
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

  List<Budget> _budget;
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
          ?.moduleConfigFor(Section.budgets)
          ?.note;
      _pageNoteSubject.add(note);
    }, notifyProgress: true);
  }

  void _loadData() {
    handleRepositoryFetch(fetch: () => _repository.fetchAllBudgets())
        .doOnListen(() => notifyHaveProgress(true))
        .doOnDone(() => notifyHaveProgress(false))
        .listen(
          _onDataLoaded,
          onError: handleThrows,
          cancelOnError: false,
        )
        .disposeWith(disposeBag);
  }

  void _onDataLoaded(List<Budget> budgets) {
    launchHandled(() async {
      _lookups = await _repository.lookups.first;
      _budget = budgets;
      _filters = await _initFilters();
      _filtersSubject.add(_filters);
      await _updatePageData();
    });
  }

  Future<void> _updatePageData() async {
    _dataSubject.add(
      await compute<_BudgetModel, BudgetData>(
        _transformBudgetModel,
        _BudgetModel(
          _budget,
          _lookups,
          _filters,
        ),
      ),
    );
  }

  Future<List<Filter>> _initFilters() async {
    if (_budget == null || _lookups == null) {
      return [];
    }
    return _budget.generateDefaultFilters(_lookups);
  }

  Stream<String> get noteStream => _pageNoteSubject.stream;

  Stream<BudgetData> get dataStream => _dataSubject.stream;

  Stream<List<Filter>> get filtersStream => _filtersSubject.stream;

  void onFiltersChanged(List<Filter> filters) {
    launchHandled(() async {
      _filters = filters;
      await _updatePageData();
    });
  }
}

class _BudgetModel {
  final List<Budget> budget;
  final Lookups lookups;
  final List<Filter> filters;

  const _BudgetModel(this.budget, this.lookups, this.filters);
}

Future<BudgetData> _transformBudgetModel(
  _BudgetModel _budgetModel,
) async {
  final groupedByYear = _budgetModel.budget.groupBy((it) => it.surveyYear);
  final filteredBudget =
      await _budgetModel.budget.applyFilters(_budgetModel.filters);
  final dataByGnpAndGovernmentSpending =
      _generateSpendingByYearData(groupedByYear);
  final dataByGnpAndGovernmentSpendingActual =
      dataByGnpAndGovernmentSpending[0];
  final dataByGnpAndGovernmentSpendingBudgeted =
      dataByGnpAndGovernmentSpending[1];

  // final budgetByYear =
  //     _budgetModel.budget.groupBy((it) => it.surveyYear).entries;
  // final budgetBySector =
  //     _budgetModel.budget.groupBy((it) => it.districtCode).entries;
  // final translates = _budgetModel.lookups;

  return BudgetData(
      dataByGnpAndGovernmentSpendingActual:
          dataByGnpAndGovernmentSpendingActual,
      dataByGnpAndGovernmentSpendingBudgeted:
          dataByGnpAndGovernmentSpendingBudgeted);
}

List _generateSpendingByYearData(
    Map<int, List<Budget>> budgetDataGroupedByYear) {
  final List<DataByGnpAndGovernmentSpending> actualData = [];
  final List<DataByGnpAndGovernmentSpending> budgetedData = [];
  budgetDataGroupedByYear.forEach((year, values) {
    double govtExpenseA = 0;
    double govtExpenseB = 0;
    double gNP = 0;
    double edExpenseA = 0;
    double edExpenseB = 0;
    double percentageEdGovtA = 0;
    double percentageEdGovtB = 0;
    double percentageEdGnpA = 0;
    double percentageEdGnpB = 0;

    for (var data in values) {
      gNP += data.gNP;
      govtExpenseA += data.govtExpA;
      edExpenseA += data.edExpA;

      edExpenseB += data.edExpB;
      govtExpenseB += data.govtExpB;
    }

    percentageEdGovtA = edExpenseA / govtExpenseA;
    percentageEdGovtB = edExpenseB / govtExpenseB;
    percentageEdGnpA = edExpenseA / gNP;
    percentageEdGnpB = edExpenseB / gNP;

    actualData.add(DataByGnpAndGovernmentSpending(
        year: year,
        gNP: gNP,
        edExpense: edExpenseA,
        govtExpense: govtExpenseA,
        percentageEdGovt:
            (percentageEdGovtA.isInfinite || percentageEdGovtA.isNaN)
                ? 0
                : (percentageEdGovtA * 100),
        percentageEdGnp: (percentageEdGnpA.isInfinite || percentageEdGnpA.isNaN)
            ? 0
            : (percentageEdGnpA * 100)));

    budgetedData.add(DataByGnpAndGovernmentSpending(
        year: year,
        gNP: gNP,
        edExpense: edExpenseB,
        govtExpense: govtExpenseB,
        percentageEdGovt:
            (percentageEdGovtB.isInfinite || percentageEdGovtB.isNaN)
                ? 0
                : (percentageEdGovtB * 100),
        percentageEdGnp: (percentageEdGnpB.isInfinite || percentageEdGnpB.isNaN)
            ? 0
            : (percentageEdGnpB * 100)));
  });
  return [
    actualData.chainSort((lv, rv) => rv.year.compareTo(lv.year)),
    budgetedData.chainSort((lv, rv) => rv.year.compareTo(lv.year))
  ];
}

List _generateYearAndSectorData(
    Map<int, List<Budget>> budgetDataGroupedByYear) {
  final List<EnrollDataByYearAndSector> actualData = [];
  final List<EnrollDataByYearAndSector> budgetedData = [];
  final List<EnrollDataByYearAndSector> actualDataPerHead = [];
  final List<EnrollDataByYearAndSector> budgetedDataPerHead = [];

  budgetDataGroupedByYear.forEach((year, values) {
    double ece = 0;
    double primary = 0;
    double secondary = 0;

    for (var data in values) {
      if (data.sectorCode == 'ECE') ece += data.edExpA;
      if (data.sectorCode == 'PRI') primary += data.edExpA;
      if (data.sectorCode == 'SEC') secondary += data.edExpA;
    }
  });
}
