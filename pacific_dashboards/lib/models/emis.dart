import 'package:flutter/cupertino.dart';
import 'package:pacific_dashboards/res/strings.dart';

enum Emis { miemis, fedemis, kemis }

Emis emisFromString(String string) =>
    Emis.values.firstWhere((it) => it.toString() == string, orElse: () => null);

extension UI on Emis {
  String getName(BuildContext context) {
    switch (this) {
      case Emis.miemis:
        return 'miemisTitle'.localized(context);
      case Emis.fedemis:
        return 'fedemisTitle'.localized(context);
      case Emis.kemis:
        return 'kiemisTitle'.localized(context);
      default: return 'fedemisTitle'.localized(context);
    }
  }

  String get logo {
    switch (this) {
      case Emis.miemis:
        return "images/logo_miemis.png";
      case Emis.fedemis:
        return "images/logo_fedemis.png";
      case Emis.kemis:
        return "images/logo_kemis.png";
      default: return "images/logo_fedemis.png";
    }
  }
}

extension Id on Emis {
  int get id {
    switch (this) {
      case Emis.miemis:
        return 0;
      case Emis.fedemis:
        return 1;
      case Emis.kemis:
        return 2;
      default: return 1;
    }
  }
}
