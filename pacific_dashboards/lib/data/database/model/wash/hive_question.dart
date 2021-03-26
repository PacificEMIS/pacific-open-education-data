import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/wash/question.dart';

part 'hive_question.g.dart';

@HiveType(typeId: 22)
class HiveQuestion extends HiveObject {
  @HiveField(0)
  String qID;

  @HiveField(1)
  String qName;

  @HiveField(2)
  String qFlags;

  Question toQuestion() => Question(
      qID,
      qName,
      qFlags,
  );

  static HiveQuestion from(Question question) => HiveQuestion()
    ..qID = question.id
    ..qName = question.name
    ..qFlags = question.qFlags;
}
