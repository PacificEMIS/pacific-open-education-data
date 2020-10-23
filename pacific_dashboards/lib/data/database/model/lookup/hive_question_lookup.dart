import 'package:hive/hive.dart';
import 'package:pacific_dashboards/models/lookups/question_lookup.dart';

part 'hive_question_lookup.g.dart';

@HiveType(typeId: 25)
class HiveQuestionLookup {
  @HiveField(0)
  String code;

  @HiveField(1)
  String name;

  @HiveField(2)
  String qId;

  @HiveField(3)
  String qName;

  QuestionLookup toLookup() => QuestionLookup(
        name: name,
        code: code,
        qId: qId,
        qName: qName,
      );

  QuestionLookup toFinancialLookup() => QuestionLookup(
        name: name,
        code: code,
        qId: qId,
        qName: qName,
      );

  static HiveQuestionLookup from(QuestionLookup lookup) {
    return HiveQuestionLookup()
      ..code = lookup.code
      ..name = lookup.name
      ..qId = lookup.qId
      ..qName = lookup.qName;
  }
}
