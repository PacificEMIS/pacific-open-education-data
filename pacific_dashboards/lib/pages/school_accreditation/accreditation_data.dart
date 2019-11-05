import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_table_widget.dart';

class AccreditationData extends Equatable {
  const AccreditationData({
    @required this.rawModel,
    @required this.year,
    @required this.accreditationProgressData,
    @required this.districtStatusData,
    @required this.accreditationStatusByState,
    @required this.performanceByStandard,
  })  : assert(accreditationProgressData != null),
        assert(districtStatusData != null),
        assert(year != null),
        assert(accreditationStatusByState != null),
        assert(performanceByStandard != null),
        assert(rawModel != null);

  final SchoolAccreditationsChunk rawModel;
  final Map<String, List<int>> accreditationProgressData;
  final Map<String, List<int>> districtStatusData;
  final String year;
  final MultitableData accreditationStatusByState;
  final MultitableData performanceByStandard;

  @override
  List<Object> get props => [
        rawModel,
        accreditationProgressData,
        districtStatusData,
        year,
        accreditationStatusByState,
        performanceByStandard,
      ];
}

class MultitableData extends Equatable {
  const MultitableData({
    @required this.evaluatedData,
    @required this.cumulatedData,
  })  : assert(evaluatedData != null),
        assert(cumulatedData != null);

  final Map<String, AccreditationTableData> evaluatedData;
  final Map<String, AccreditationTableData> cumulatedData;

  @override
  List<Object> get props => [
        evaluatedData,
        cumulatedData,
      ];
}
