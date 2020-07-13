import 'package:flutter/foundation.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/mvvm/mvvm.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:rxdart/rxdart.dart';

class SchoolsListViewModel extends BaseViewModel {
  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<List<ShortSchool>> _schoolsSubject =
      BehaviorSubject<List<ShortSchool>>.seeded([]);

  List<ShortSchool> _schools;

  SchoolsListViewModel({
    @required Repository repository,
    @required RemoteConfig remoteConfig,
    @required GlobalSettings globalSettings,
  })  : assert(repository != null),
        assert(remoteConfig != null),
        assert(globalSettings != null),
        _repository = repository,
        _remoteConfig = remoteConfig,
        _globalSettings = globalSettings;

  @override
  void onInit() {
    super.onInit();
    _schoolsSubject.disposeWith(disposeBag);
    _loadData();
  }

  void _loadData() {
    launchHandled(() {
      _schools = [
        ShortSchool("SCH001", "Aykoi Government school1"),
        ShortSchool("SCH002", "Aykoi Government school2"),
        ShortSchool("SCH003", "Aykoi Government school3"),
        ShortSchool("SCH004", "Aykoi Government school4"),
        ShortSchool("SCH005", "Aykoi Government school5"),
        ShortSchool("SCH006", "Aykoi Government school6"),
        ShortSchool("SCH007", "Aykoi Government school7"),
        ShortSchool("SCH008", "Aykoi Government school8"),
        ShortSchool("SCH000", "Aykoi Government school9"),
        ShortSchool("SCH010", "Aykoi Government school10"),
        ShortSchool("SCH011", "Aykoi Government school11"),
        ShortSchool("SCH012", "Aykoi Government school12"),
        ShortSchool("SCH013", "Aykoi Government here school13"),
        ShortSchool("SCH014", "Aykoi Government school14"),
        ShortSchool("SCH015", "Aykoi Government school15"),
        ShortSchool("SCH016", "Aykoi Government school16"),
        ShortSchool("SCH017", "Aykoi Government school17"),
        ShortSchool("SCH018", "Aykoi Government school18"),
        ShortSchool("SCH019", "Aykoi Government school19"),
        ShortSchool("SCH020", "Aykoi Government school20"),
        ShortSchool("SCH021", "Aykoi Government school21"),
        ShortSchool("SCH022", "Aykoi Government school22"),
      ];
      _schoolsSubject.add(_schools);
    }, notifyProgress: true);
//    handleRepositoryFetch(fetch: () => _repository.fetchAllSchools())
//        .doOnListen(() => notifyHaveProgress(true))
//        .doOnDone(() => notifyHaveProgress(false))
//        .listen(
////      _onDataLoaded,
//          (_) {},
//          onError: handleThrows,
//          cancelOnError: false,
//        )
//        .disposeWith(disposeBag);
  }

//  void _onDataLoaded(List<School> schools) {
//    launchHandled(() async {
//      _lookups = await _repository.lookups.first;
//      _schools = schools;
//      _filters = await _initFilters();
//      _filtersSubject.add(_filters);
//      await _updatePageData();
//    });
//  }_updatePageData

  Stream<List<ShortSchool>> get schoolsStream => _schoolsSubject.stream;

  void onSearchTextChanged(String query) {
    launchHandled(() {
      if (_schools == null) return;
      final lowercaseQuery = query.toLowerCase();
      final filteredSchools = _schools
          .where((it) =>
              it.id.toLowerCase().contains(lowercaseQuery) ||
              it.name.toLowerCase().contains(lowercaseQuery))
          .toList();
      _schoolsSubject.add(filteredSchools);
    });
  }

  void onSchoolPressed(String id) {}
}
