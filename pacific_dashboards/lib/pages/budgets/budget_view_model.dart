import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/budget/budget.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/budgets/budget_data.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:rxdart/rxdart.dart';

const int _filterBeforeYear = 2014;

class BudgetViewModel extends BaseViewModel {
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

  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<String> _pageNoteSubject = BehaviorSubject();
  final Subject<BudgetData> _dataSubject = BehaviorSubject();
  final Subject<List<Filter>> _filtersSubject = BehaviorSubject();

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
    });
  }

  void _loadData() {
    listenHandled(
      handleRepositoryFetch(fetch: _repository.fetchAllBudgets),
      _onDataLoaded,
      notifyProgress: true,
    );
  }

  Future<void> _onDataLoaded(List<Budget> budgets) => launchHandled(
        () async {
          _lookups = await _repository.lookups.first;
          _budget = budgets;
          _filters = await _initFilters();
          _filtersSubject.add(_filters);
          await _updatePageData();
        },
      );

  Future<void> _updatePageData() async {
    _dataSubject.add(
      await compute<_BudgetModel, BudgetData>(
        _transformBudgetModel,
        _BudgetModel(
          _budget,
          _lookups,
          _filters,
          await _globalSettings.currentEmis,
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
  const _BudgetModel(this.budget, this.lookups, this.filters, this.emis);

  final List<Budget> budget;
  final Lookups lookups;
  final List<Filter> filters;
  final Emis emis;
}

Future<BudgetData> _transformBudgetModel(
  _BudgetModel budgetModel,
) async {
  final emis = budgetModel.emis;
  final year = _selectedYear(budgetModel.filters);

  final filteredBudget =
      await budgetModel.budget.applyFilters(budgetModel.filters);
  final groupedByYear = budgetModel.budget.groupBy((it) => it.surveyYear);
  final dataByGnpAndGovernmentSpending =
      _generateSpendingByYearData(groupedByYear, year);

  final budgetLookups = budgetModel.lookups;
  //Actual data
  final dataByGnpAndGovernmentSpendingActual =
      dataByGnpAndGovernmentSpending[0];
  //Budgeted data
  final dataByGnpAndGovernmentSpendingBudgeted =
      dataByGnpAndGovernmentSpending[1];
  //Spending data
  final dataBySpendingBySector = _generateYearAndSectorData(
    filteredBudget.groupBy((it) => it.districtCode),
    budgetLookups,
    year,
  );
  //Spending by sector and year
  final dataSpendingBySectorAndYear = _generateSpendingSectorData(
    groupedByYear,
    budgetModel.lookups,
  );
  final dataSpendingByDistrict = _generateSpendingDistrictData(
    groupedByYear,
    budgetModel.lookups,
    year,
    emis,
  );
  final dataSpendingByDistrictFiltered = _generateSpendingDistrictData(
    filteredBudget.groupBy((it) => it.surveyYear),
    budgetModel.lookups,
    year,
    emis,
  );
  final dataSpendingBySectorAndYearFiltered = _generateSpendingSectorData(
    filteredBudget.groupBy((it) => it.surveyYear),
    budgetModel.lookups,
  );
  return BudgetData(
    year: year,
    dataByGnpAndGovernmentSpendingActual: dataByGnpAndGovernmentSpendingActual,
    dataByGnpAndGovernmentSpendingBudgeted:
        dataByGnpAndGovernmentSpendingBudgeted,
    dataSpendingBySector: dataBySpendingBySector,
    dataSpendingBySectorAndYear: dataSpendingBySectorAndYear,
    dataSpendingByDistrict: dataSpendingByDistrict,
    dataSpendingByDistrictFiltered: dataSpendingByDistrictFiltered,
    dataSpendingBySectorAndYearFiltered: dataSpendingBySectorAndYearFiltered,
  );
}

int _selectedYear(List<Filter> filters) {
  return filters.firstWhere((it) => it.id == 0).intValue;
}

List<DataSpendingByDistrict> _generateSpendingDistrictData(
  Map<int, List<Budget>> budgetDataGroupedByYear,
  Lookups lookups,
  int currentYear,
  Emis emis,
) {
  final dataSpendingByDistrict = <DataSpendingByDistrict>[];
  budgetDataGroupedByYear.forEach((year, spendings) {
    spendings
        .groupBy((element) => element.districtCode)
        .forEach((district, values) {
      if (district != null && district.isNotEmpty && year > _filterBeforeYear) {
        var districtEdExpA = 0.0;
        var districtEdExpB = 0.0;
        var districtEdRecurrentExpA = 0.0;
        var districtEdRecurrentExpB = 0.0;
        var districtEnrolment = 0.0;

        for (final element in values) {
          districtEdExpA += element.edExpA;
          districtEdExpB += element.edExpB;
          districtEdRecurrentExpA += element.edRecurrentExpA;
          districtEdRecurrentExpB += element.edRecurrentExpB;
          districtEnrolment += element.enrolment;
          districtEnrolment += element.enrolmentNation;
        }
        if (districtEdExpA > 0 ||
            districtEdExpB > 0 ||
            districtEdRecurrentExpA > 0 ||
            districtEdRecurrentExpB > 0 ||
            districtEnrolment > 0 ||
            year == currentYear) {
          dataSpendingByDistrict.add(
            DataSpendingByDistrict(
              year: year.toString(),
              district: values[0].districtCode.from(lookups.districts),
              edExpA: districtEdExpA.round(),
              edExpAPerHead: districtEdExpA != 0 && districtEnrolment != 0
                  ? (districtEdExpA / districtEnrolment).round()
                  : 0,
              edExpB: districtEdExpB.round(),
              edExpBPerHead: districtEdExpB != 0 && districtEnrolment != 0
                  ? (districtEdExpB / districtEnrolment).round()
                  : 0,
              edRecurrentExpA: districtEdRecurrentExpA.round(),
              edRecurrentExpB: districtEdRecurrentExpB.round(),
              enrolment: districtEnrolment.round(),
            ),
          );
        }
      }
    });
  });

  /// https://ytr.omega-r.club/issue/POED-167
  ///
  /// " Yes. Only MIEMIS omits the districts since they will not have budgets
  /// by districts loaded into the system. In FSM however, National has
  /// a budget and so does each 4 states so yes display them. While currently,
  /// some states do not have the data loaded they will soon and they
  /// should be shown in the legend (at least if the data is present like
  /// in the above screenshot that has Yap state budget) "
  ///
  /// Removing all non-National data from MIEMIS
  if (emis == Emis.miemis) {
    dataSpendingByDistrict.removeWhere(
      (it) => !it.district.toLowerCase().contains('nation'),
    );
  }

  dataSpendingByDistrict.sort((rv, lv) => rv.year.compareTo(lv.year));
  return dataSpendingByDistrict;
}

List<DataSpendingByDistrict> _generateSpendingSectorData(
  Map<int, List<Budget>> budgetDataGroupedByYear,
  Lookups lookups,
) {
  final dataSpendingByDistrict = <DataSpendingByDistrict>[];
  budgetDataGroupedByYear.forEach((year, spendings) {
    spendings
        .groupBy((element) => element.sectorCode)
        .forEach((sectorCode, values) {
      if (sectorCode != null &&
          sectorCode.isNotEmpty &&
          year > _filterBeforeYear) {
        var districtEdExpA = 0.0;
        var districtEdExpB = 0.0;
        var districtEdRecurrentExpA = 0.0;
        var districtEdRecurrentExpB = 0.0;
        var districtEnrolment = 0.0;

        for (final element in values) {
          districtEdExpA += element.edExpA;
          districtEdExpB += element.edExpB;
          districtEdRecurrentExpA += element.edRecurrentExpA;
          districtEdRecurrentExpB += element.edRecurrentExpB;
          districtEnrolment += element.enrolment;
          districtEnrolment += element.enrolmentNation;
        }

        dataSpendingByDistrict.add(
          DataSpendingByDistrict(
            year: year.toString(),
            district: values[0].sectorCode,
            edExpA: districtEdExpA.round(),
            edExpAPerHead: districtEdExpA != 0 && districtEnrolment != 0
                ? (districtEdExpA / districtEnrolment).round()
                : 0,
            edExpB: districtEdExpB.round(),
            edExpBPerHead: districtEdExpB != 0 && districtEnrolment != 0
                ? (districtEdExpB / districtEnrolment).round()
                : 0,
            edRecurrentExpA: districtEdRecurrentExpA.round(),
            edRecurrentExpB: districtEdRecurrentExpB.round(),
            enrolment: districtEnrolment.round(),
          ),
        );
      }
    });
  });
  dataSpendingByDistrict.sort((rv, lv) => rv.year.compareTo(lv.year));
  return dataSpendingByDistrict;
}

List _generateSpendingByYearData(
  Map<int, List<Budget>> budgetDataGroupedByYear,
  int currentYear,
) {
  final actualData = <DataByGnpAndGovernmentSpending>[];
  final budgetedData = <DataByGnpAndGovernmentSpending>[];

  budgetDataGroupedByYear.forEach((year, values) {
    if (year > _filterBeforeYear) {
      var govtExpenseA = 0.0;
      var govtExpenseB = 0.0;
      var gNP = 0.0;
      var edExpenseA = 0.0;
      var edExpenseB = 0.0;
      var percentageEdGovtA = 0.0;
      var percentageEdGovtB = 0.0;
      var percentageEdGnpA = 0.0;
      var percentageEdGnpB = 0.0;

      for (final data in values) {
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
      if (gNP == 0 &&
          edExpenseA == 0 &&
          govtExpenseA == 0 &&
          year != currentYear) {
        debugPrint('empty');
      } else {
        actualData.add(
          DataByGnpAndGovernmentSpending(
            year: year,
            gNP: gNP,
            edExpense: edExpenseA,
            govtExpense: govtExpenseA,
            percentageEdGovt:
                (percentageEdGovtA.isInfinite || percentageEdGovtA.isNaN)
                    ? 0
                    : (percentageEdGovtA * 100),
            percentageEdGnp:
                (percentageEdGnpA.isInfinite || percentageEdGnpA.isNaN)
                    ? 0
                    : (percentageEdGnpA * 100),
          ),
        );
      }
      if (gNP == 0 &&
          edExpenseB == 0 &&
          govtExpenseB == 0 &&
          year != currentYear) {
        debugPrint('empty');
      } else {
        budgetedData.add(
          DataByGnpAndGovernmentSpending(
            year: year,
            gNP: gNP,
            edExpense: edExpenseB,
            govtExpense: govtExpenseB,
            percentageEdGovt:
                (percentageEdGovtB.isInfinite || percentageEdGovtB.isNaN)
                    ? 0
                    : (percentageEdGovtB * 100),
            percentageEdGnp:
                (percentageEdGnpB.isInfinite || percentageEdGnpB.isNaN)
                    ? 0
                    : (percentageEdGnpB * 100),
          ),
        );
      }
    }
  });
  actualData.sort((rv, lv) => rv.year.compareTo(lv.year));
  budgetedData.sort((rv, lv) => rv.year.compareTo(lv.year));

  return [
    actualData,
    budgetedData,
  ];
}

List<DataSpendingBySector> _generateYearAndSectorData(
  Map<String, List<Budget>> budgetDataGroupedByDistrict,
  Lookups lookups,
  int currentYear,
) {
  final dataSpendingBySector = <DataSpendingBySector>[];

  var eceTotalActual = 0.0;
  var primaryTotalActual = 0.0;
  var secondaryTotalActual = 0.0;

  var eceTotalBudgeted = 0.0;
  var primaryTotalBudgeted = 0.0;
  var secondaryTotalBudgeted = 0.0;

  budgetDataGroupedByDistrict.forEach((sector, values) {
    var districtCode = '';
    var eceActual = 0.0;
    var eceBudget = 0.0;
    var primaryActual = 0.0;
    var primaryBudget = 0.0;
    var secondaryActual = 0.0;
    var secondaryBudget = 0.0;
    var totalActual = 0.0;
    var totalBudget = 0.0;

    for (final data in values) {
      if (data.sectorCode != null &&
          data.sectorCode.isNotEmpty &&
          data.districtCode != null) {
        if (data.sectorCode == 'ECE') {
          eceActual += data.edExpA;
          eceBudget += data.edExpB;

          eceTotalActual += data.edExpA;
          eceTotalBudgeted += data.edExpB;
        } else if (data.sectorCode == 'PRI') {
          primaryActual += data.edExpA;
          primaryBudget += data.edExpB;

          primaryTotalActual += data.edExpA;
          primaryTotalBudgeted += data.edExpB;
        } else if (data.sectorCode == 'SEC') {
          secondaryActual += data.edExpA;
          secondaryBudget += data.edExpB;

          secondaryTotalActual += data.edExpA;
          secondaryTotalBudgeted += data.edExpB;
        }

        totalActual = eceActual + primaryActual + secondaryActual;
        totalBudget = eceBudget + primaryBudget + secondaryBudget;
      }
    }

    if (sector != null && districtCode != null) {
      districtCode = sector.from(lookups.districts);
      if (eceActual > 0 ||
          eceBudget > 0 ||
          primaryActual > 0 ||
          primaryBudget > 0 ||
          secondaryActual > 0 ||
          secondaryBudget > 0 ||
          totalActual > 0 ||
          totalBudget > 0) {
        dataSpendingBySector.add(
          DataSpendingBySector(
            districtCode: districtCode,
            eceActual: eceActual,
            eceBudget: eceBudget,
            primaryActual: primaryActual,
            primaryBudget: primaryBudget,
            secondaryActual: secondaryActual,
            secondaryBudget: secondaryBudget,
            totalActual: totalActual,
            totalBudget: totalBudget,
          ),
        );
      }
    }
  });

  //Adding total
  if (eceTotalActual > 0 ||
      eceTotalBudgeted > 0 ||
      primaryTotalActual > 0 ||
      primaryTotalBudgeted > 0 ||
      secondaryTotalActual > 0 ||
      secondaryTotalBudgeted > 0) {
    dataSpendingBySector.add(
      DataSpendingBySector(
        districtCode: 'labelTotal',
        eceActual: eceTotalActual,
        eceBudget: eceTotalBudgeted,
        primaryActual: primaryTotalActual,
        primaryBudget: primaryTotalBudgeted,
        secondaryActual: secondaryTotalActual,
        secondaryBudget: secondaryTotalBudgeted,
        totalActual: eceTotalActual + primaryTotalActual + secondaryTotalActual,
        totalBudget:
            eceTotalBudgeted + primaryTotalBudgeted + secondaryTotalBudgeted,
      ),
    );
  }
  return dataSpendingBySector;
}
