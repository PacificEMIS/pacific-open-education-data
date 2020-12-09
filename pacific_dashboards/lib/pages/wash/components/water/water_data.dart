import 'package:flutter/foundation.dart';

class WashWaterViewData {
  const WashWaterViewData({
    @required this.available,
    @required this.usedForDrinking,
  });

  final List<WaterViewDataBySchool> available;
  final List<WaterViewDataBySchool> usedForDrinking;
}

class WaterViewDataBySchool {
  const WaterViewDataBySchool({
    @required this.school,
    @required this.pipedWaterSupply,
    @required this.protectedWell,
    @required this.unprotectedWellSpring,
    @required this.rainwater,
    @required this.bottled,
    @required this.tanker,
    @required this.surfaced,
  });

  final String school;
  final int pipedWaterSupply;
  final int protectedWell;
  final int unprotectedWellSpring;
  final int rainwater;
  final int bottled;
  final int tanker;
  final int surfaced;
}
