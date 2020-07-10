import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/pages/base/base_bloc.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_data.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_table_widget.dart';
import './bloc.dart';
import 'package:pacific_dashboards/utils/collections.dart';

class AccreditationBloc
    extends BaseBloc<AccreditationEvent, AccreditationState> {
  AccreditationBloc({
    Repository repository,
    RemoteConfig remoteConfig,
    GlobalSettings globalSettings,
  })  : assert(repository != null),
        assert(remoteConfig != null),
        assert(globalSettings != null),
        _repository = repository,
        _remoteConfig = remoteConfig,
        _globalSettings = globalSettings,
        super(InitialAccreditationState());

  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  AccreditationChunk _chunk;
  List<Filter> _filters;
  String _note;

  @override
  AccreditationState get serverUnavailableState => ServerUnavailableState();

  @override
  AccreditationState get unknownErrorState => UnknownErrorState();

  @override
  Stream<Lookups> get lookupsStream => _repository.lookups;

  @override
  Stream<AccreditationState> mapEventToState(
    AccreditationEvent event,
  ) async* {
    if (event is StartedAccreditationEvent) {
      final currentState = state;
      yield LoadingAccreditationState();
      _note = (await _remoteConfig.emises)
          .getEmisConfigFor(await _globalSettings.currentEmis)
          ?.moduleConfigFor(Section.schoolAccreditations)
          ?.note;
      yield* handleFetch(
        beforeFetchState: currentState,
        fetch: _repository.fetchAllAccreditations,
        onSuccess: (data) async* {
          _chunk = data;
          _filters = await _initFilters();
          yield UpdatedAccreditationState(await _calculateData());
        },
      );
    }

    if (event is FiltersAppliedAccreditationEvent) {
      _filters = event.filters;
      yield UpdatedAccreditationState(await _calculateData());
    }
  }

  Future<List<Filter>> _initFilters() async {
    if (_chunk == null) {
      return null;
    }
    return _chunk.generateDefaultFilters(await lookups);
  }

  Future<AccreditationData> _calculateData() async {
    final filteredChunk = await _chunk.applyFilters(_filters);
    final transations = await lookups;
    return AccreditationData(
      year: _selectedYear.toString(),
      accreditationProgressData: _collectAccreditationProgressData(_chunk),
      districtStatusData: _collectDistrictStatusData(_chunk).map(
          (districtCode, v) =>
              MapEntry(districtCode.from(transations.districts), v)),
      accreditationStatusByState:
          _collectAccreditationStatusByState(filteredChunk, transations),
      performanceByStandard: _collectPerformanceByStandard(_chunk, transations),
      filters: _filters,
      note: _note,
    );
  }

  Map<String, List<int>> _collectAccreditationProgressData(
      AccreditationChunk chunk) {
    return _generateCumulativeMap(
        data: chunk.byDistrict.groupBy((it) => it.surveyYear.toString()));
  }

  Map<String, List<int>> _collectDistrictStatusData(
      AccreditationChunk chunk) {
    return _generateCumulativeMap(
      data: _chunk.byDistrict.groupBy((it) => it.districtCode),
      year: _selectedYear,
    );
  }

  MultitableData _collectAccreditationStatusByState(
      AccreditationChunk chunk, Lookups lookups) {
    return _generateMultitableData(chunk.byDistrict
        .groupBy((it) => it.districtCode.from(lookups.districts)));
  }

  MultitableData _collectPerformanceByStandard(
      AccreditationChunk chunk, Lookups lookups) {
    return _generateMultitableData(chunk.byStandard
        .groupBy((it) => (it.standard ?? '').from(lookups.accreditationTerms)));
  }

  MultitableData _generateMultitableData(
      Map<String, List<Accreditation>> data) {
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
    @required Map<String, List<Accreditation>> data,
    int year,
  }) {
    final result = Map<String, List<int>>();

    data.forEach((key, value) {
      final levels = [0, 0, 0, 0];

      value.forEach((accreditation) {
        final sum = accreditation.total;

        if (year != null && accreditation.surveyYear != year) {
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

  int get _selectedYear {
    return _filters.firstWhere((it) => it.id == 0).intValue;
  }

  Map<String, AccreditationTableData> _generateAccreditationTableData(
      Map<String, List<Accreditation>> rawMapData,
      bool isCumulative,
      int currentYear) {
    final convertedData = Map<String, AccreditationTableData>();
    final sortedMapKeys = rawMapData.keys.toList()
      ..sort((lv, rv) => rawMapData[lv]
          .first
          ?.sortField
          ?.compareTo(rawMapData[rv].first?.sortField));
    sortedMapKeys.forEach((key) {
      var levels = [0, 0, 0, 0, 0, 0, 0, 0];
      final rawValue = rawMapData[key];
      for (var j = 0; j < rawValue.length; ++j) {
        var model = rawValue;
        var level = model[j].level;
        var numThisYear = 0;
        var numSum = 0;
        if (model[j].surveyYear == currentYear) {
          numThisYear += model[j].numThisYear ?? 0;
          numSum += model[j].total ?? 0;
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
