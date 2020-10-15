import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/expirable.dart';
import 'package:pacific_dashboards/models/wash/wash_chunk.dart';

import 'hive_toilet.dart';
import 'hive_wash_total.dart';
import 'hive_water.dart';

part 'hive_wash_chunk.g.dart';

@HiveType(typeId: 20)
class HiveWashChunk extends HiveObject with Expirable {
  @HiveField(0)
  List<HiveWashTotal> total;

  @HiveField(1)
  List<HiveToilet> toilets;

  @HiveField(2)
  List<HiveWater> water;

  @override
  @HiveField(3)
  int timestamp;

  WashChunk toWashChunk() => WashChunk(
        total: total.map((it) => it.toWash()).toList(),
        toilets: toilets.map((it) => it.toToilets()).toList(),
        water: water.map((it) => it.toWater()).toList(),
      );

  static HiveWashChunk from(WashChunk washChunk) => HiveWashChunk()
    ..total = washChunk.total.map((it) => HiveWashTotal.from(it)).toList()
    ..toilets = washChunk.toilets.map((it) => HiveToilet.from(it)).toList()
    ..water = washChunk.water.map((it) => HiveWater.from(it)).toList();
}
