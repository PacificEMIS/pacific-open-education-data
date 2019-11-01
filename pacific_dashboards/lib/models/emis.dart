import 'package:pacific_dashboards/res/strings/strings.dart';

enum Emis { miemis, fedemis }

Emis emisFromString(String string) =>
    Emis.values.firstWhere((it) => it.toString() == string, orElse: () => null);

String logoPathForEmis(Emis emis) {
  switch (emis) {
    case Emis.miemis:
      return "images/miemis.png";
    case Emis.fedemis:
      return "images/fedemis.png";
    default:
      throw FallThroughError();
  }
}

String nameOfEmis(Emis emis) {
  switch (emis) {
    case Emis.miemis:
      return AppLocalizations.marshallIslands;
    case Emis.fedemis:
      return AppLocalizations.federatedStateOfMicronesia;
    default:
      throw FallThroughError();
  }
}
