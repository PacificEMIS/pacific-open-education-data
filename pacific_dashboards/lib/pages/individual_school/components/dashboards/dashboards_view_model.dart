import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll_chunk.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';

class DashboardsViewModel extends BaseViewModel {
  final Repository _repository;
  final String _schoolId;
  final String _districtCode;

  DashboardsViewModel(
    BuildContext ctx, {
    @required String schoolId,
    @required String districtCode,
    @required Repository repository,
  })  : assert(repository != null),
        assert(schoolId != null),
        assert(districtCode != null),
        _schoolId = schoolId,
        _districtCode = districtCode,
        _repository = repository,
        super(ctx);

  @override
  void onInit() {
    super.onInit();
    _loadEnrollData();
  }

  void _loadEnrollData() {
    handleRepositoryFetch(
      fetch: () => _repository.fetchIndividualSchoolEnroll(
        _schoolId,
        _districtCode,
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
    print(chunk);
  }
}
