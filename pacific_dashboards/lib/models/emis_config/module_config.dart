import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';

part 'module_config.g.dart';

@JsonSerializable()
class ModuleConfig {
  const ModuleConfig({
    @required this.id,
    this.note,
  });

  factory ModuleConfig.fromJson(Map<String, dynamic> json) =>
      _$ModuleConfigFromJson(json);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'note', nullable: true)
  final String note;

  Map<String, dynamic> toJson() => _$ModuleConfigToJson(this);

  Section asSection() {
    switch (id) {
      case 'schools':
        return Section.schools;
      case 'teachers':
        return Section.teachers;
      case 'exams':
        return Section.exams;
      case 's_accreditation':
        return Section.schoolAccreditations;
      case 'indicators':
        return Section.indicators;
      case 'budgets':
        return Section.budgets;
      case 'individual_schools':
        return Section.individualSchools;
      case 'special_education':
        return Section.specialEducation;
      case 'wash':
        return Section.wash;
    }
    return null;
  }
}
