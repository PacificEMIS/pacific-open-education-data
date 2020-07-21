import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/lookups/lookup.dart';

part 'lookups.g.dart';

@JsonSerializable()
class Lookups {
  @JsonKey(name: 'authorityGovt')
  final List<Lookup> authorityGovt;

  @JsonKey(name: 'schoolTypes')
  final List<Lookup> schoolTypes;

  @JsonKey(name: 'districts')
  final List<Lookup> districts;

  @JsonKey(name: 'authorities')
  final List<Lookup> authorities;

  @JsonKey(name: 'levels')
  final List<Lookup> levels;

  @JsonKey(name: 'accreditationTerms')
  final List<Lookup> accreditationTerms;

  @JsonKey(name: 'educationLevels')
  final List<Lookup> educationLevels;

  @JsonKey(name: 'schoolCodes')
  final List<Lookup> schoolCodes;

  const Lookups({
    this.authorityGovt,
    this.schoolTypes,
    this.districts,
    this.authorities,
    this.levels,
    this.accreditationTerms,
    this.educationLevels,
    this.schoolCodes,
  });

  factory Lookups.fromJson(Map<String, dynamic> json) => _$LookupsFromJson(json);

  Map<String, dynamic> toJson() => _$LookupsToJson(this);

  bool isEmpty() =>
      authorityGovt.isEmpty &&
      schoolTypes.isEmpty &&
      districts.isEmpty &&
      authorities.isEmpty &&
      levels.isEmpty &&
      accreditationTerms.isEmpty;
}

extension Lookuped on String {
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
