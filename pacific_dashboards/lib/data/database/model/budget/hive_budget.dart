import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/budget/budget.dart';

part 'hive_budget.g.dart';

@HiveType(typeId: 13)
class HiveBudget extends HiveObject with Expirable {
  @HiveField(0)
  int surveyYear;

  @HiveField(1)
  String districtCode;

  @HiveField(2)
  double gNP;

  @HiveField(3)
  double gNPCapita;

  @HiveField(4)
  String gNPCurrency;

  @HiveField(5)
  double gNPLocal;

  @HiveField(6)
  double gNPCapitaLocal;

  @HiveField(7)
  double govtExpA;

  @HiveField(8)
  double govtExpB;

  @HiveField(9)
  double govtExpBGNPPerc;

  @HiveField(10)
  double edExpA;

  @HiveField(11)
  double edExpB;

  @HiveField(12)
  double edGovtExpBPerc;

  @HiveField(13)
  double edExpAGNPPerc;

  @HiveField(14)
  double edExpBGNPPerc;

  @HiveField(15)
  double edExpAPerHead;

  @HiveField(16)
  double edExpBPerHead;

  @HiveField(17)
  double edExpAPerHeadGNPCapitaPerc;

  @HiveField(18)
  double edExpBPerHeadGNPCapitaPerc;

  @HiveField(19)
  double enrolment;

  @HiveField(20)
  String sectorCode;

  Budget toBudget() => Budget(
      surveyYear,
      districtCode,
      gNP,
      gNPCapita,
      gNPCurrency,
      gNPLocal,
      gNPCapitaLocal,
      govtExpA,
      govtExpB,
      govtExpBGNPPerc,
      edExpA,
      edExpB,
      edGovtExpBPerc,
      edExpAGNPPerc,
      edExpBGNPPerc,
      edExpAPerHead,
      edExpBPerHead,
      edExpAPerHeadGNPCapitaPerc,
      edExpBPerHeadGNPCapitaPerc,
      enrolment,
      sectorCode);

  static HiveBudget from(Budget budget) => HiveBudget()
    ..surveyYear = budget.surveyYear
    ..gNP = budget.gNP
    ..gNPCapita = budget.gNPCapita
    ..gNPCurrency = budget.gNPCurrency
    ..gNPLocal = budget.gNPLocal
    ..gNPCapitaLocal = budget.gNPCapitaLocal
    ..govtExpA = budget.govtExpA
    ..govtExpB = budget.govtExpB
    ..edExpA = budget.edExpA
    ..edExpB = budget.edExpB
    ..edGovtExpBPerc = budget.edGovtExpBPerc
    ..edExpAGNPPerc = budget.edExpAGNPPerc
    ..edExpBGNPPerc = budget.edExpBGNPPerc
    ..edExpAPerHead = budget.edExpAPerHead
    ..edExpBPerHead = budget.edExpBPerHead
    ..edExpAPerHeadGNPCapitaPerc = budget.edExpAPerHeadGNPCapitaPerc
    ..edExpBPerHeadGNPCapitaPerc = budget.edExpBPerHeadGNPCapitaPerc
    ..enrolment = budget.enrolment
    ..sectorCode = budget.sectorCode;
}
