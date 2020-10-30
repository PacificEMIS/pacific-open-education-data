import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/wash/question.dart';

part 'hive_question.g.dart';

@HiveType(typeId: 22)
class HiveQuestion extends HiveObject {
  @HiveField(0)
  String qID;

  @HiveField(1)
  String qName;

  Question toQuestion() => Question(
      qID,
      qName);

  static HiveQuestion from(Question question) => HiveQuestion()
    ..qID = question.qID
    ..qName = question.qName;
}
