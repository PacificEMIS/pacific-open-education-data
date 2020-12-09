import 'package:hive/hive.dart';
import 'package:pacific_dashboards/data/database/model/wash/hive_question.dart';
import 'package:pacific_dashboards/models/wash/wash_chunk.dart';
import 'package:pacific_dashboards/data/database/model/wash/hive_toilet.dart';
import 'package:pacific_dashboards/data/database/model/wash/hive_wash_total.dart';
import 'package:pacific_dashboards/data/database/model/wash/hive_water.dart';

part 'hive_wash_chunk.g.dart';

@HiveType(typeId: 20)
class HiveWashChunk extends HiveObject {
  HiveWashChunk();

  HiveWashChunk.from(WashChunk washChunk)
      : total = washChunk.total.map((it) => HiveWashTotal.from(it)).toList(),
        toilets = washChunk.toilets.map((it) => HiveToilet.from(it)).toList(),
        water = washChunk.water.map((it) => HiveWater.from(it)).toList(),
        questions =
            washChunk.questions.map((it) => HiveQuestion.from(it)).toList();

  @HiveField(0)
  List<HiveWashTotal> total;

  @HiveField(1)
  List<HiveToilet> toilets;

  @HiveField(2)
  List<HiveWater> water;

  @HiveField(3)
  List<HiveQuestion> questions;

  WashChunk toWashChunk() => WashChunk(
        total: total.map((it) => it.toWash()).toList(),
        toilets: toilets.map((it) => it.toToilets()).toList(),
        water: water.map((it) => it.toWater()).toList(),
        questions: questions.map((it) => it.toQuestion()).toList(),
      );
}
