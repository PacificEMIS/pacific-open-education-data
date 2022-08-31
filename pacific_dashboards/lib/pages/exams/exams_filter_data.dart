import '../../models/filter/filter.dart';

class ExamsFilterData {
  final int showModeId;
  final String recordTypeName;
  final String showMode;
  final List<Filter> filters;

  ExamsFilterData(
      this.showModeId,
      this.recordTypeName,
      this.showMode,
      this.filters
      );

  Filter get yearFilter => filters[0];
  Filter get examFilter => filters[1];
  Filter get stateFilter => filters[2];
  Filter get govFilter => filters[3];
  Filter get authorityFilter => filters[4];
}
