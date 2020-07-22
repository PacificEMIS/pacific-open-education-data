import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll_chunk.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

class DashboardsViewModel extends BaseViewModel {
  final Repository _repository;
  final ShortSchool _school;
  final Subject<SchoolEnrollChunk> _enrollSubject = PublishSubject();

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
    _loadEnrollData();
  }

  void _loadEnrollData() {
    handleRepositoryFetch(
      fetch: () => _repository.fetchIndividualSchoolEnroll(
        _school.id,
        _school.districtCode,
      ),
    )
        .listen(
          _onEnrollLoaded,
          onError: (t) => handleThrows,
          cancelOnError: false,
        )
        .disposeWith(disposeBag);
  }

  void _onEnrollLoaded(SchoolEnrollChunk chunk) {
    _enrollSubject.add(chunk);
  }



  Stream<SchoolEnrollChunk> get enrollStream => _enrollSubject.stream;
}
