import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll_chunk.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/enroll_data.dart';
import 'package:rxdart/rxdart.dart';

class EnrollViewModel extends BaseViewModel {
  final Repository _repository;
  final ShortSchool _school;
  final Subject<EnrollData> _dataSubject = BehaviorSubject();
  SchoolEnrollChunk _chunk;

  EnrollViewModel(
    BuildContext ctx, {
    @required ShortSchool school,
    @required Repository repository,
  })  : assert(repository != null),
        assert(school != null),
        _school = school,
        _repository = repository,
        super(ctx);

  Stream<EnrollData> get dataStream => _dataSubject.stream;

  @override
  void onInit() {
    super.onInit();
    _dataSubject.disposeWith(disposeBag);
    _loadEnrollData();
  }

  void _loadEnrollData() {
    handleRepositoryFetch(
      fetch: () => _repository.fetchIndividualSchoolEnroll(
        _school.id,
        _school.districtCode,
      ),
    )
        .doOnListen(() => notifyHaveProgress(true))
        .listen(
          _onEnrollLoaded,
          onError: (t) => handleThrows,
          cancelOnError: false,
        )
        .disposeWith(disposeBag);
  }

  void _onEnrollLoaded(SchoolEnrollChunk chunk) {
    _chunk = chunk;
    _parseData();
  }

  void _parseData() {
    if (_chunk == null) return;
    launchHandled(() async {
      final gradeHistory = await compute(
        _generateGradeDataHistory,
        _chunk.schoolData,
      );
      final gradeDataOnLastYear = gradeHistory.head;
      final gradeDataHistory = gradeHistory.tail;
      final genderByYearHistory = await compute(
        _generateGenderDataHistory,
        _chunk.schoolData,
      );
      final femalePartOnLastYear = await compute(
        _generateFemaleDataOnLastYear,
        _chunk,
      );
      final femalePartHistory = await compute(
        _generateFemalePartHistory,
        _chunk,
      );
      final data = EnrollData(
        gradeDataOnLastYear: gradeDataOnLastYear,
        gradeDataHistory: gradeDataHistory,
        genderDataHistory: genderByYearHistory,
        femalePartOnLastYear: femalePartOnLastYear,
        femalePartHistory: femalePartHistory,
      );
      _dataSubject.add(data);
    }, notifyProgress: true);
  }
}

List<EnrollDataByGradeHistory> _generateGradeDataHistory(
  List<SchoolEnroll> schoolData,
) {
  final List<EnrollDataByGradeHistory> results = [];
  final groupedByYear = schoolData.groupBy((it) => it.year);

  groupedByYear.forEach((year, enrollList) {
    final groupedByGrade = enrollList.groupBy((it) => it.classLevel);
    groupedByGrade.removeWhere((key, value) => key == null);

    final List<EnrollDataByGrade> enrollInYear = [];

    groupedByGrade.forEach((grade, enrollList) {
      enrollInYear.addAll(enrollList.map((it) {
        return EnrollDataByGrade(
          grade: grade,
          male: it.enrollMale,
          female: it.enrollFemale,
          total: it.totalEnroll,
        );
      }));
    });

    results.add(EnrollDataByGradeHistory(
      year: year,
      data: enrollInYear,
    ));
  });
  return results.chainSort((lv, rv) => rv.year.compareTo(lv.year));
}

List<EnrollDataByYear> _generateGenderDataHistory(
  List<SchoolEnroll> schoolData,
) {
  final List<EnrollDataByYear> results = [];
  final groupedByYear = schoolData.groupBy((it) => it.year);
  groupedByYear.removeWhere((key, value) => key == null);

  groupedByYear.forEach((year, enrollList) {
    int femaleByYear = 0;
    int maleByYear = 0;
    int totalByYear = 0;
    for (var enrollData in enrollList) {
      femaleByYear += enrollData.enrollFemale;
      maleByYear += enrollData.enrollMale;
      totalByYear += enrollData.totalEnroll;
    }
    results.add(EnrollDataByYear(
      year: year,
      female: femaleByYear,
      male: maleByYear,
      total: totalByYear,
    ));
  });
  return results.chainSort((lv, rv) => lv.year.compareTo(rv.year));
}

EnrollDataByFemalePartOnLastYear _generateFemaleDataOnLastYear(
  SchoolEnrollChunk chunk,
) {
  var groupedByYearSchool = chunk.schoolData.groupBy((it) => it.year);
  groupedByYearSchool.removeWhere((key, value) => key == null);
  final groupedByYearDistrict = chunk.districtData.groupBy((it) => it.year);
  final groupedByYearNation = chunk.nationalData.groupBy((it) => it.year);
  final lastSchoolYear =
      groupedByYearSchool.keys.chainSort((lv, rv) => rv.compareTo(lv)).first;

  var schoolDataOnLastYear = groupedByYearSchool[lastSchoolYear];
  var districtDataOnLastYear = groupedByYearDistrict[lastSchoolYear] ?? [];
  var nationDataOnLastYear = groupedByYearNation[lastSchoolYear] ?? [];

  schoolDataOnLastYear.removeWhere((it) => it.classLevel == null);
  districtDataOnLastYear.removeWhere((it) => it.classLevel == null);
  nationDataOnLastYear.removeWhere((it) => it.classLevel == null);

  final schoolDataOnLastYearByGrade =
      schoolDataOnLastYear.groupBy((it) => it.classLevel);
  final districtDataOnLastYearByGrade =
      districtDataOnLastYear.groupBy((it) => it.classLevel);
  final nationDataOnLastYearByGrade =
      nationDataOnLastYear.groupBy((it) => it.classLevel);

  final List<EnrollDataByFemalePart> data = [];
  schoolDataOnLastYearByGrade.forEach((grade, enrollData) {
    final districtEnrollData = districtDataOnLastYearByGrade[grade] ?? [];
    final nationEnrollData = nationDataOnLastYearByGrade[grade] ?? [];
    data.add(EnrollDataByFemalePart(
      grade: grade,
      school: enrollData
          .map((it) => it.enrollFemale)
          .fold(0, (prev, newValue) => prev + newValue),
      district: districtEnrollData
          .map((it) => it.enrollFemale)
          .fold(0, (prev, newValue) => prev + newValue),
      nation: nationEnrollData
          .map((it) => it.enrollFemale)
          .fold(0, (prev, newValue) => prev + newValue),
    ));
  });
  return EnrollDataByFemalePartOnLastYear(year: lastSchoolYear, data: data);
}

List<EnrollDataByFemalePartHistory> _generateFemalePartHistory(
  SchoolEnrollChunk chunk,
) {
  final groupedByYearSchool = chunk.schoolData.groupBy((it) => it.year);
  final groupedByYearDistrict = chunk.districtData.groupBy((it) => it.year);
  final groupedByYearNation = chunk.nationalData.groupBy((it) => it.year);

  final List<EnrollDataByFemalePartHistory> result = [];
  groupedByYearSchool.removeWhere((key, value) => key == null);
  groupedByYearSchool.forEach((year, enrollData) {
    final districtEnrollData = groupedByYearDistrict[year] ?? [];
    final nationEnrollData = groupedByYearNation[year] ?? [];
    result.add(EnrollDataByFemalePartHistory(
      year: year,
      school: enrollData
          .map((it) => it.enrollFemale)
          .fold(0, (prev, newValue) => prev + newValue),
      district: districtEnrollData
          .map((it) => it.enrollFemale)
          .fold(0, (prev, newValue) => prev + newValue),
      nation: nationEnrollData
          .map((it) => it.enrollFemale)
          .fold(0, (prev, newValue) => prev + newValue),
    ));
  });

  return result;
}
