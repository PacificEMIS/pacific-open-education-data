import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/data/repository.dart';
import 'package:pacific_dashboards/models/school_accreditation_chunk.dart';
import 'package:pacific_dashboards/models/school_accreditation_model.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_data.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_table_widget.dart';
import './bloc.dart';

class AccreditationBloc extends Bloc<AccreditationEvent, AccreditationState> {
  AccreditationBloc({@required Repository repository})
      : assert(repository != null),
        _repository = repository;

  final Repository _repository;
  SchoolAccreditationsChunk _chunk;

  @override
  AccreditationState get initialState => LoadingAccreditationState();

  @override
  Stream<AccreditationState> mapEventToState(
    AccreditationEvent event,
  ) async* {
    if (event is StartedAccreditationEvent) {
      _chunk = await _repository.fetchAllAccreditaitons();
      yield UpdatedAccreditationState(_calculateData());
    }

    if (event is FiltersAppliedAccreditationEvent) {
      _chunk = event.updatedModel;
      yield UpdatedAccreditationState(_calculateData());
    }
  }

  AccreditationData _calculateData() {
    return AccreditationData(
      rawModel: _chunk,
      year: _selectedYear,
      accreditationProgressData: _collectAccreditationProgressData(),
      districtStatusData: _collectDistrictStatusData(),
      accreditationStatusByState: _collectAccreditationStatusByState(),
      performanceByStandard: _collectPerformanceByStandard(),
    );
  }

  Map<String, List<int>> _collectAccreditationProgressData() {
    return _generateCumulativeMap(data: _chunk.statesChunk.getSortedByYear());
  }

  Map<String, List<int>> _collectDistrictStatusData() {
    return _generateCumulativeMap(
      data: _chunk.statesChunk.getSortedByState(),
      year: _selectedYear,
    );
  }

  MultitableData _collectAccreditationStatusByState() {
    return _generateMultitableData(_chunk.statesChunk.getSortedWithFiltersByState());
  }

  MultitableData _collectPerformanceByStandard() {
    return _generateMultitableData(_chunk.standardsChunk.getSortedByStandart());
  }

  MultitableData _generateMultitableData(Map<String, List<SchoolAccreditationModel>> data) {
    return MultitableData(
      evaluatedData: _generateAccreditationTableData(
        data,
        false,
        _selectedYear,
      ),
      cumulatedData: _generateAccreditationTableData(
        data,
        true,
        _selectedYear,
      ),
    );
  }

  Map<String, List<int>> _generateCumulativeMap({
    @required Map<String, List<SchoolAccreditationModel>> data,
    String year,
  }) {
    final result = Map<String, List<int>>();

    data.forEach((key, value) {
      final levels = [0, 0, 0, 0];

      value.forEach((accreditation) {
        final sum = accreditation.numSum;

        if (year != null && accreditation.surveyYear.toString() != year) {
          return;
        }

        switch (accreditation.level) {
          case AccreditationLevel.level1:
            levels[0] -= sum;
            break;
          case AccreditationLevel.level2:
            levels[1] += sum;
            break;
          case AccreditationLevel.level3:
            levels[2] += sum;
            break;
          case AccreditationLevel.level4:
            levels[3] += sum;
            break;
          case AccreditationLevel.undefined:
            break;
        }
      });

      result[key] = levels;
    });

    return result;
  }

  String get _selectedYear {
    var selectedYear = _chunk.statesChunk.yearFilter.selectedKey;
    if (selectedYear == "") {
      selectedYear = _chunk.statesChunk.yearFilter.getMax();
    }
    return selectedYear;
  }

  Map<String, AccreditationTableData> _generateAccreditationTableData(
      Map<String, List<SchoolAccreditationModel>> rawMapData,
      bool isCumulative,
      String currentYear) {
    final convertedData = Map<String, AccreditationTableData>();
    final sortedMapKeys = rawMapData.keys.toList()
      ..sort((lv, rv) => rawMapData[lv]
          .first
          ?.standard
          ?.compareTo(rawMapData[rv].first?.standard));
    sortedMapKeys.forEach((key) {
      var levels = [0, 0, 0, 0, 0, 0, 0, 0];
      final rawValue = rawMapData[key];
      for (var j = 0; j < rawValue.length; ++j) {
        var model = rawValue;
        var level = model[j].level;
        var numThisYear = 0;
        var numSum = 0;
        if (model[j].surveyYear.toString() == currentYear) {
          numThisYear += model[j].numInYear ?? 0;
          numSum += model[j].numSum ?? 0;
          switch (level) {
            case AccreditationLevel.level1:
              levels[0] += numThisYear;
              levels[4] += numSum;
              break;
            case AccreditationLevel.level2:
              levels[1] += numThisYear;
              levels[5] += numSum;
              break;
            case AccreditationLevel.level3:
              levels[2] += numThisYear;
              levels[6] += numSum;
              break;
            case AccreditationLevel.level4:
              levels[3] += numThisYear;
              levels[7] += numSum;
              break;
            case AccreditationLevel.undefined:
              break;
          }
        }
      }

      if (isCumulative)
        convertedData[key] =
            AccreditationTableData(levels[4], levels[5], levels[6], levels[7]);
      else
        convertedData[key] =
            AccreditationTableData(levels[0], levels[1], levels[2], levels[3]);
    });

    return convertedData;
  }
}
