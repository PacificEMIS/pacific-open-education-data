import 'package:json_annotation/json_annotation.dart';
import 'financial_lookup.dart';

part 'financial_lookups.g.dart';

@JsonSerializable()
class FinancialLookups {
  @JsonKey(name: 'costCentres')
  final List<FinancialLookup> costCentres;

  @JsonKey(name: 'fundingSources')
  final List<FinancialLookup> fundingSources;

  @JsonKey(name: 'fundingSourceGroups')
  final List<FinancialLookup> fundingSourceGroups;

  const FinancialLookups({
    this.costCentres,
    this.fundingSources,
    this.fundingSourceGroups,
  });

  factory FinancialLookups.fromJson(Map<String, dynamic> json) =>
      _$FinancialLookupsFromJson(json);

  Map<String, dynamic> toJson() => _$FinancialLookupsToJson(this);

  bool isEmpty() =>
      costCentres.isEmpty &&
      fundingSources.isEmpty &&
      fundingSourceGroups.isEmpty;
}

extension LookupedString on String {
  String from(Iterable<FinancialLookup> lookup) {
    return lookup
            .firstWhere((it) => it.code == this, orElse: () => null)
            ?.name ??
        this;
  }
}
