import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/individual_school/individual_school_page.dart';
import 'package:rxdart/rxdart.dart';

class SchoolsListViewModel extends BaseViewModel {
  final Repository _repository;

  final Subject<List<ShortSchool>> _schoolsSubject = BehaviorSubject();

  List<ShortSchool> _schools;
  String _searchQuery = '';

  SchoolsListViewModel(
    BuildContext ctx, {
    @required Repository repository,
  })  : assert(repository != null),
        _repository = repository,
        super(ctx);

  @override
  void onInit() {
    super.onInit();
    _schoolsSubject.disposeWith(disposeBag);
    _loadData();
  }

  void _loadData() {
    listenHandled(
      handleRepositoryFetch(fetch: _repository.fetchSchoolsList),
      _onDataLoaded,
      notifyProgress: true,
    );
  }

  void _onDataLoaded(List<ShortSchool> schools) {
    _schools = schools;
    _applyFilters();
  }

  Stream<List<ShortSchool>> get schoolsStream => _schoolsSubject.stream;

  void onSearchTextChanged(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    launchHandled(() {
      if (_schools == null) return;
      final lowercaseQuery = _searchQuery != null ? _searchQuery.toLowerCase() : '';
      final filteredSchools = _schools
          .where(
            (it) =>
                it.id.toLowerCase().contains(lowercaseQuery) ||
                it.name.toLowerCase().contains(lowercaseQuery),
          )
          .chainSort((lv, rv) => lv.id.compareTo(rv.id))
          .toList();
      _schoolsSubject.add(filteredSchools);
    });
  }

  void onSchoolPressed(ShortSchool school) {
    navigator.pushNamed(
      IndividualSchoolPage.kRoute,
      arguments: IndividualSchoolPageArgs(
        school: school,
      ),
    );
  }
}
