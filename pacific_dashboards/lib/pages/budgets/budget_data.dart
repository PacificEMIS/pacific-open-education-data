import 'package:flutter/foundation.dart';

class BudgetData {
  final List<DataByGnpAndGovernmentSpending>
      dataByGnpAndGovernmentSpendingActual;
  final List<DataByGnpAndGovernmentSpending>
      dataByGnpAndGovernmentSpendingBudgeted;
  BudgetData(
      {@required this.dataByGnpAndGovernmentSpendingActual,
      @required this.dataByGnpAndGovernmentSpendingBudgeted});
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

class EnrollDataByYearAndSector {
  final String year;
  final double ece;
  final double primary;
  final double secondary;

  EnrollDataByYearAndSector({
    @required this.year,
    @required this.ece,
    @required this.primary,
    @required this.secondary,
  });
}
