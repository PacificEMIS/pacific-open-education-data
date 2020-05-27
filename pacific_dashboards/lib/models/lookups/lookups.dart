import 'package:pacific_dashboards/models/lookups/lookup.dart';

class Lookups {
  final List<Lookup> authorityGovt;
  final List<Lookup> schoolTypes;
  final List<Lookup> districts;
  final List<Lookup> authorities;
  final List<Lookup> levels;
  final List<Lookup> accreditationTerms;
  final List<Lookup> educationLevels;

  const Lookups({
    this.authorityGovt,
    this.schoolTypes,
    this.districts,
    this.authorities,
    this.levels,
    this.accreditationTerms,
    this.educationLevels,
  });

  factory Lookups.empty() {
    return Lookups();
  }

  factory Lookups.fromJson(Map<String, dynamic> json) {
    return Lookups(
      authorityGovt:
          json['authorityGovt'].map((it) => Lookup.fromJson(it)).toList(),
      schoolTypes:
          json['schoolTypes'].map((it) => Lookup.fromJson(it)).toList(),
      districts: json['districts'].map((it) => Lookup.fromJson(it)).toList(),
      authorities:
          json['authorities'].map((it) => Lookup.fromJson(it)).toList(),
      levels: json['levels'].map((it) => Lookup.fromJson(it)).toList(),
      accreditationTerms:
          json['accreditationTerms'].map((it) => Lookup.fromJson(it)).toList(),
      educationLevels:
          json['educationLevels'].map((it) => Lookup.fromJson(it)).toList(),
    );
  }

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
