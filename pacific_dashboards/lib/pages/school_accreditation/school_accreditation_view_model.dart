import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation.dart';
import 'package:pacific_dashboards/models/accreditations/accreditation_chunk.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_data.dart';
import 'package:pacific_dashboards/pages/school_accreditation/accreditation_table_widget.dart';
import 'package:rxdart/rxdart.dart';

class SchoolAccreditationViewModel extends BaseViewModel {
  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<String> _pageNoteSubject = BehaviorSubject();
  final Subject<AccreditationData> _dataSubject = BehaviorSubject();
  final Subject<List<Filter>> _filtersSubject = BehaviorSubject();

  AccreditationChunk _accreditationChunk;
  List<Filter> _filters;
  Lookups _lookups;

  SchoolAccreditationViewModel(
    BuildContext ctx, {
    @required Repository repository,
    @required RemoteConfig remoteConfig,
    @required GlobalSettings globalSettings,
  })  : assert(repository != null),
        assert(remoteConfig != null),
        assert(globalSettings != null),
        _repository = repository,
        _remoteConfig = remoteConfig,
        _globalSettings = globalSettings,
        super(ctx);

  @override
  void onInit() {
    super.onInit();
    _pageNoteSubject.disposeWith(disposeBag);
    _dataSubject.disposeWith(disposeBag);
    _filtersSubject.disposeWith(disposeBag);
    _loadNote();
    _loadData();
  }

  void _loadNote() {
    launchHandled(() async {
      final note = (await _remoteConfig.emises)
          .getEmisConfigFor(await _globalSettings.currentEmis)
          ?.moduleConfigFor(Section.schoolAccreditations)
          ?.note;
      _pageNoteSubject.add(note);
    }, notifyProgress: true);
  }

  void _loadData() {
    handleRepositoryFetch(fetch: () => _repository.fetchAllAccreditations())
        .doOnListen(() => notifyHaveProgress(true))
        .doOnDone(() => notifyHaveProgress(false))
        .listen(
          _onDataLoaded,
          onError: handleThrows,
          cancelOnError: false,
        )
        .disposeWith(disposeBag);
  }

  void _onDataLoaded(AccreditationChunk accreditationChunk) {
    launchHandled(() async {
      _lookups = await _repository.lookups.first;
      _accreditationChunk = accreditationChunk;
      _filters = await _initFilters();
      _filtersSubject.add(_filters);
      await _updatePageData();
    });
  }

  Future<void> _updatePageData() async {
    _dataSubject.add(
      await compute<_AccreditationChunkModel, AccreditationData>(
        _calculateData,
        _AccreditationChunkModel(
          _accreditationChunk,
          _lookups,
          _filters,
        ),
      ),
    );
  }

  Future<List<Filter>> _initFilters() async {
    if (_accreditationChunk == null || _lookups == null) {
      return [];
    }
    return _accreditationChunk.generateDefaultFilters(_lookups);
  }

  Stream<String> get noteStream => _pageNoteSubject.stream;

  Stream<AccreditationData> get dataStream => _dataSubject.stream;

  Stream<List<Filter>> get filtersStream => _filtersSubject.stream;

  void onFiltersChanged(List<Filter> filters) {
    launchHandled(() async {
      _filters = filters;
      await _updatePageData();
    });
  }
}

class _AccreditationChunkModel {
  final AccreditationChunk chunk;
  final Lookups lookups;
  final List<Filter> filters;

  const _AccreditationChunkModel(this.chunk, this.lookups, this.filters);
}

Future<AccreditationData> _calculateData(_AccreditationChunkModel model) async {
  final chunk = model.chunk;
  final filters = model.filters;
  final filteredChunk = await chunk.applyFilters(filters);
  final lookups = model.lookups;
  return AccreditationData(
    year: _selectedYear(filters).toString(),
    accreditationProgressData: _collectAccreditationProgressData(chunk),
    districtStatusData: _collectDistrictStatusData(chunk, filters).map(
        (districtCode, v) => MapEntry(districtCode.from(lookups.districts), v)),
    accreditationStatusByState: _collectAccreditationStatusByState(
      filteredChunk,
      lookups,
      filters,
    ),
    performanceByStandard: _collectPerformanceByStandard(
      chunk,
      lookups,
      filters,
    ),
  );
}

Map<String, List<int>> _collectAccreditationProgressData(
    AccreditationChunk chunk) {
  return _generateCumulativeMap(
      data: chunk.byDistrict.groupBy((it) => it.surveyYear.toString()));
}

Map<String, List<int>> _collectDistrictStatusData(
  AccreditationChunk chunk,
  List<Filter> filters,
) {
  return _generateCumulativeMap(
    data: chunk.byDistrict.groupBy((it) => it.districtCode),
    year: _selectedYear(filters),
  );
}

MultitableData _collectAccreditationStatusByState(
  AccreditationChunk chunk,
  Lookups lookups,
  List<Filter> filters,
) {
  return _generateMultitableData(
    chunk.byDistrict.groupBy((it) => it.districtCode.from(lookups.districts)),
    filters,
  );
}

MultitableData _collectPerformanceByStandard(
  AccreditationChunk chunk,
  Lookups lookups,
  List<Filter> filters,
) {
  return _generateMultitableData(
    chunk.byStandard
        .groupBy((it) => (it.standard ?? '').from(lookups.accreditationTerms)),
    filters,
  );
}

MultitableData _generateMultitableData(
  Map<String, List<Accreditation>> data,
  List<Filter> filters,
) {
  return MultitableData(
    evaluatedData: _generateAccreditationTableData(
      data,
      false,
      _selectedYear(filters),
    ),
    cumulatedData: _generateAccreditationTableData(
      data,
      true,
      _selectedYear(filters),
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

int _selectedYear(List<Filter> filters) {
  return filters.firstWhere((it) => it.id == 0).intValue;
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
