import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll_chunk.dart';
import 'package:pacific_dashboards/models/school_flow/school_flow.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

class DashboardsViewModel extends BaseViewModel {
  final Repository _repository;
  final ShortSchool _school;
  final Subject<SchoolEnrollChunk> _enrollSubject = BehaviorSubject();
  final Subject<List<SchoolFlow>> _flowSubject = BehaviorSubject();

  final Subject<bool> _enrollLoadingSubject = BehaviorSubject.seeded(false);
  final Subject<bool> _flowLoadingSubject = BehaviorSubject.seeded(false);

  DashboardsViewModel(
    BuildContext ctx, {
    @required ShortSchool school,
    @required Repository repository,
  })  : assert(repository != null),
        assert(school != null),
        _school = school,
        _repository = repository,
        super(ctx);

  @override
  void onInit() {
    super.onInit();
    _enrollSubject.disposeWith(disposeBag);
    _flowSubject.disposeWith(disposeBag);
    _enrollLoadingSubject.disposeWith(disposeBag);
    _flowLoadingSubject.disposeWith(disposeBag);
    _loadEnrollData();
    _loadFlowData();
  }

  void _loadEnrollData() {
    handleRepositoryFetch(
      fetch: () => _repository.fetchIndividualSchoolEnroll(
        _school.id,
        _school.districtCode,
      ),
    )
        .doOnListen(() => _enrollLoadingSubject.add(true))
        .doOnEach((_) => _enrollLoadingSubject.add(false))
        .listen(
          _onEnrollLoaded,
          onError: (t) => handleThrows,
          cancelOnError: false,
        )
        .disposeWith(disposeBag);
  }

  void _loadFlowData() {
    handleRepositoryFetch(
      fetch: () => _repository.fetchIndividualSchoolFlow(_school.id),
    )
        .doOnListen(() => _flowLoadingSubject.add(true))
        .doOnEach((_) => _flowLoadingSubject.add(false))
        .listen(
      _onFlowLoaded,
      onError: (t) => handleThrows,
      cancelOnError: false,
    )
        .disposeWith(disposeBag);
  }

  void _onEnrollLoaded(SchoolEnrollChunk chunk) {
    _enrollSubject.add(chunk);
  }

  void _onFlowLoaded(List<SchoolFlow> flows) {
    _flowSubject.add(flows);
  }

  Stream<SchoolEnrollChunk> get enrollStream => _enrollSubject.stream;
  Stream<List<SchoolFlow>> get flowStream => _flowSubject.stream;
}
