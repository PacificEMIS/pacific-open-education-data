import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/lookups/class_level_lookup.dart';
import 'package:pacific_dashboards/models/lookups/lookup.dart';
<<<<<<< HEAD
import 'package:pacific_dashboards/models/lookups/school_type_lookup.dart';
=======
>>>>>>> 940dc6816f5e75fedab3718834bd5fcd15e843e6

part 'lookups.g.dart';

@JsonSerializable()
class Lookups {
  @JsonKey(name: 'authorityGovts', defaultValue: [])
  final List<Lookup> authorityGovt;

  @JsonKey(name: 'schoolTypes', defaultValue: [])
  final List<Lookup> schoolTypes;

  @JsonKey(name: 'districts', defaultValue: [])
  final List<Lookup> districts;

  @JsonKey(name: 'authorities', defaultValue: [])
  final List<Lookup> authorities;

  @JsonKey(name: 'levels', defaultValue: [])
  final List<ClassLevelLookup> levels;

  @JsonKey(name: 'accreditationTerms', defaultValue: [])
  final List<Lookup> accreditationTerms;

  @JsonKey(name: 'educationLevels', defaultValue: [])
  final List<Lookup> educationLevels;

  @JsonKey(name: 'schoolCodes', defaultValue: [])
  final List<Lookup> schoolCodes;

  @JsonKey(name: 'question', defaultValue: [])
  final List<Lookup> question;

<<<<<<< HEAD
  @JsonKey(name: 'schoolTypeLevels', defaultValue: [])
  final List<SchoolTypeLookup> schoolTypeLevels;

  const Lookups({
    this.authorityGovt,
    this.schoolTypes,
    this.districts,
    this.authorities,
    this.levels,
    this.accreditationTerms,
    this.educationLevels,
    this.schoolCodes,
    this.question,
    this.schoolTypeLevels,
  });

  factory Lookups.fromJson(Map<String, dynamic> json) =>
      _$LookupsFromJson(json);

=======
  const Lookups({
    this.authorityGovt,
    this.schoolTypes,
    this.districts,
    this.authorities,
    this.levels,
    this.accreditationTerms,
    this.educationLevels,
    this.schoolCodes,
    this.question,
  });

  factory Lookups.fromJson(Map<String, dynamic> json) =>
      _$LookupsFromJson(json);

>>>>>>> 940dc6816f5e75fedab3718834bd5fcd15e843e6
  Map<String, dynamic> toJson() => _$LookupsToJson(this);

  bool isEmpty() =>
      authorityGovt.isEmpty &&
      schoolTypes.isEmpty &&
      districts.isEmpty &&
      authorities.isEmpty &&
      levels.isEmpty &&
      question.isEmpty &&
      accreditationTerms.isEmpty;
}

extension LookupedString on String {
  String from(Iterable<Lookup> lookup) {
    return lookup
            .firstWhere((it) => it.code == this, orElse: () => null)
            ?.name ??
        this;
  }

  String educationLevelFrom(Lookups lookups) {
    final educationLevelCode = lookups.levels
        .firstWhere((it) => it.code == this, orElse: () => null)
        ?.l;

    if (educationLevelCode == null) {
      return this;
    }

    return educationLevelCode.from(lookups.educationLevels);
  }
}

extension LookupedInt on int {
  String educationLevelCodeFrom(Lookups lookups) {
    final educationLevelCode = lookups.levels
        .firstWhere((it) => it.yearOfEducation == this, orElse: () => null)
        ?.code;

    return educationLevelCode ?? 'Class $this';
  }
}
