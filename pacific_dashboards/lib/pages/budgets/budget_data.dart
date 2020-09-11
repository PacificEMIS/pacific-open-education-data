import 'package:flutter/foundation.dart';

class BudgetData {
  final List<DataByGnpAndGovernmentSpending>
      dataByGnpAndGovernmentSpendingActual;
  final List<DataByGnpAndGovernmentSpending>
      dataByGnpAndGovernmentSpendingBudgeted;
  final List<DataSpendingBySector> dataSpendingBySector;
  final List<DataSpendingByDistrict> dataSpendingBySectorAndYear;
  final List<DataSpendingByDistrict> dataSpendingBySectorAndYearFiltered;
  final List<DataSpendingByDistrict> dataSpendingByDistrict;
  final List<DataSpendingByDistrict> dataSpendingByDistrictFiltered;

  BudgetData(
      {@required this.dataByGnpAndGovernmentSpendingActual,
      @required this.dataByGnpAndGovernmentSpendingBudgeted,
      @required this.dataSpendingBySector,
      @required this.dataSpendingBySectorAndYear,
        @required this.dataSpendingBySectorAndYearFiltered,
      @required this.dataSpendingByDistrict,
      @required this.dataSpendingByDistrictFiltered});
}

class DataByGnpAndGovernmentSpending {
  final int year;
  final double govtExpense;
  final double gNP;
  final double edExpense;
  final double percentageEdGovt;
  final double percentageEdGnp;

  DataByGnpAndGovernmentSpending(
      {@required this.year,
      @required this.gNP,
      @required this.govtExpense,
      @required this.edExpense,
      @required this.percentageEdGovt,
      @required this.percentageEdGnp});
}

class DataSpendingBySector {
  final String districtCode;
  final String sectorCode;
  final double eceActual;
  final double eceBudget;
  final double primaryActual;
  final double primaryBudget;
  final double secondaryActual;
  final double secondaryBudget;
  final double totalActual;
  final double totalBudget;

  DataSpendingBySector(
      {@required this.districtCode,
      @required this.sectorCode,
      @required this.eceActual,
      @required this.eceBudget,
      @required this.primaryActual,
      @required this.primaryBudget,
      @required this.secondaryActual,
      @required this.secondaryBudget,
      @required this.totalActual,
      @required this.totalBudget});
}

class DataSpendingByDistrict {
  final String year;
  final String district;
  final int edExpA;
  final int edExpB;
  final int edRecurrentExpA;
  final int edRecurrentExpB;
  final int edExpAPerHead;
  final int edExpBPerHead;
  final int enrolment;

  DataSpendingByDistrict(
      {@required this.year,
      @required this.district,
      @required this.edExpA,
      @required this.edExpB,
      @required this.edRecurrentExpA,
      @required this.edRecurrentExpB,
      @required this.edExpAPerHead,
      @required this.edExpBPerHead,
      @required this.enrolment});
}
