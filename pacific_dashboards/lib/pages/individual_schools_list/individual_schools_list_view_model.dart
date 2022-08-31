import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/individual_school/individual_school_page.dart';
import 'package:rxdart/rxdart.dart';

class IndividualSchoolsListViewModel extends BaseViewModel {
  final Repository _repository;

  final Subject<List<ShortSchool>> _individualSchoolsSubject = BehaviorSubject();

  List<ShortSchool> _individualSchools = [];
  List<ShortSchool> _selectedSchools = [];
  bool _isSelectAll = false;

  String _searchQuery = '';

  IndividualSchoolsListViewModel(
    BuildContext ctx, {
    @required Repository repository,
    @required List<ShortSchool> selectedSchools,
    @required List<ShortSchool> individualSchools,
    @required bool isSelectAll,
  })  : assert(repository != null),
        _repository = repository,
        _selectedSchools = selectedSchools,
        _individualSchools = individualSchools,
        _isSelectAll = isSelectAll,
        super(ctx);

  @override
  void onInit() {
    super.onInit();

    _individualSchoolsSubject.disposeWith(disposeBag);
    if (_individualSchools == null || _individualSchools.length == 0) _loadData();
    else _applyFilters();
  }

  void _loadData() {
    listenHandled(
      handleRepositoryFetch(fetch: _repository.fetchSchoolsList),
      _onDataLoaded,
      notifyProgress: true,
    );
  }

  void _onDataLoaded(List<ShortSchool> IndividualSchools) {
    _individualSchools = IndividualSchools;
    if (_isSelectAll) {
      _selectedSchools = [];
      _selectedSchools.addAll(_individualSchools);
    }
    if (_selectedSchools == null || _selectedSchools.length == 0) _selectedSchools = [];
    _applyFilters();
  }

  void OnIndividualSchoolsLstUpdated() {}

  Stream<List<ShortSchool>> get IndividualSchoolsStream => _individualSchoolsSubject.stream;
  List<ShortSchool> get SelectedSchools => _selectedSchools;
  List<ShortSchool> get IndividualSchools => _individualSchools;

  void onSearchTextChanged(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    launchHandled(() {
      if (_individualSchools == null) return;
      final lowercaseQuery = _searchQuery != null ? _searchQuery.toLowerCase() : '';
      final filteredIndividualSchools = _individualSchools
          .where(
            (it) => it.id.toLowerCase().contains(lowercaseQuery) || it.name.toLowerCase().contains(lowercaseQuery),
          )
          .chainSort((lv, rv) => lv.id.compareTo(rv.id))
          .toList();
      _individualSchoolsSubject.add(filteredIndividualSchools);
    });
  }

  void onSchoolPressed(ShortSchool school) {
    final findSchool = _selectedSchools.firstWhere((e) => e.id == school.id, orElse: () => null);
    findSchool != null ? _selectedSchools.remove(findSchool) : _selectedSchools.add(school);
    _applyFilters();
  }

  void onSelectAllSchoolPressed(bool selected) {
    if (!selected)
      _selectedSchools = [];
    else {
      _selectedSchools = [];
      _selectedSchools.addAll(_individualSchools);
    }
    _applyFilters();
  }

  bool isSelectedSchoolsContains(String schoolId) {
    return _selectedSchools.firstWhere((e) => e.id == schoolId, orElse: () => null) != null;
  }
}
