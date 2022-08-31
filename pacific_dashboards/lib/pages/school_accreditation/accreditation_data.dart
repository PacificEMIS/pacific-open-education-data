import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';

class AccreditationData {
  const AccreditationData({
    @required this.year,
    @required this.accreditationProgressData,
    @required this.accreditationProgressCumulativeData,
    @required this.accreditationProgressByYearData,
    @required this.accreditationProgressByYearCumulativeData,
    @required this.districtStatusData,
    @required this.districtStatusCumulativeData,
    @required this.accreditationNationalCumulativeData,
    @required this.accreditationNationalEvaluatedData,
    @required this.accreditationStatusByState,
    @required this.performanceByStandard,
  })  : assert(year != null),
        assert(accreditationProgressData != null),
        assert(accreditationProgressCumulativeData != null),
        assert(districtStatusData != null),
        assert(districtStatusCumulativeData != null),
        assert(accreditationNationalEvaluatedData != null),
        assert(accreditationNationalCumulativeData != null),
        assert(accreditationStatusByState != null),
        assert(performanceByStandard != null);

  final String year;
  final Map<String, List<int>> accreditationProgressByYearData;
  final Map<String, List<int>> accreditationProgressByYearCumulativeData;
  final Map<String, List<int>> accreditationProgressData;
  final Map<String, List<int>> accreditationProgressCumulativeData;
  final Map<String, List<int>> districtStatusData;
  final Map<String, List<int>> districtStatusCumulativeData;

  final List<ChartData> accreditationNationalCumulativeData;
  final List<ChartData> accreditationNationalEvaluatedData;

  final MultitableData accreditationStatusByState;
  final MultitableData performanceByStandard;
}

class MultitableData {
  const MultitableData({
    @required this.evaluatedData,
    @required this.cumulatedData,
  })  : assert(evaluatedData != null),
        assert(cumulatedData != null);

  final Map<String, AccreditationTableData> evaluatedData;
  final Map<String, AccreditationTableData> cumulatedData;
}
