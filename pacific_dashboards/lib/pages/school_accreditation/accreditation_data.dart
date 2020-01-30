import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_table_widget.dart';

class AccreditationData extends Equatable {
  const AccreditationData({
    @required this.year,
    @required this.accreditationProgressData,
    @required this.districtStatusData,
    @required this.accreditationStatusByState,
    @required this.performanceByStandard,
    @required this.filters,
  })  : assert(accreditationProgressData != null),
        assert(districtStatusData != null),
        assert(year != null),
        assert(accreditationStatusByState != null),
        assert(performanceByStandard != null),
        assert(filters != null);

  final BuiltMap<String, BuiltList<int>> accreditationProgressData;
  final BuiltMap<String, BuiltList<int>> districtStatusData;
  final String year;
  final MultitableData accreditationStatusByState;
  final MultitableData performanceByStandard;
  final BuiltList<Filter> filters;

  @override
  List<Object> get props => [
        accreditationProgressData,
        districtStatusData,
        year,
        accreditationStatusByState,
        performanceByStandard,
        filters,
      ];
}

class MultitableData extends Equatable {
  const MultitableData({
    @required this.evaluatedData,
    @required this.cumulatedData,
  })  : assert(evaluatedData != null),
        assert(cumulatedData != null);

  final BuiltMap<String, AccreditationTableData> evaluatedData;
  final BuiltMap<String, AccreditationTableData> cumulatedData;

  @override
  List<Object> get props => [
        evaluatedData,
        cumulatedData,
      ];
}
