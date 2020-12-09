import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/configs/remote_config.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/gender.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/teacher/teacher.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:pacific_dashboards/pages/teachers/teachers_page_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';
import 'package:rxdart/rxdart.dart';

class TeachersViewModel extends BaseViewModel {
  TeachersViewModel(
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

  final Repository _repository;
  final RemoteConfig _remoteConfig;
  final GlobalSettings _globalSettings;

  final Subject<String> _pageNoteSubject = BehaviorSubject();
  final Subject<TeachersPageData> _dataSubject = BehaviorSubject();
  final Subject<List<Filter>> _filtersSubject = BehaviorSubject();

  List<Teacher> _teachers;
  List<Filter> _filters;
  Lookups _lookups;

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
          ?.moduleConfigFor(Section.teachers)
          ?.note;
      _pageNoteSubject.add(note);
    });
  }

  void _loadData() {
    listenHandled(
      handleRepositoryFetch(fetch: _repository.fetchAllTeachers),
      _onDataLoaded,
      notifyProgress: true,
    );
  }

  Future<void> _onDataLoaded(List<Teacher> schools) => launchHandled(
        () async {
          _lookups = await _repository.lookups.first;
          _teachers = schools;
          _filters = await _initFilters();
          _filtersSubject.add(_filters);
          await _updatePageData();
        },
      );

  Future<void> _updatePageData() async {
    _dataSubject.add(
      await compute<_TeachersModel, TeachersPageData>(
        _transformTeachersModel,
        _TeachersModel(
          _teachers,
          _lookups,
          _filters,
        ),
      ),
    );
  }

  Future<List<Filter>> _initFilters() async {
    if (_teachers == null || _lookups == null) {
      return [];
    }
    return _teachers.generateDefaultFilters(_lookups);
  }

  Stream<String> get noteStream => _pageNoteSubject.stream;

  Stream<TeachersPageData> get dataStream => _dataSubject.stream;

  Stream<List<Filter>> get filtersStream => _filtersSubject.stream;

  void onFiltersChanged(List<Filter> filters) {
    launchHandled(() async {
      _filters = filters;
      await _updatePageData();
    });
  }
}

class _TeachersModel {
  const _TeachersModel(this.teachers, this.lookups, this.filters);

  final List<Teacher> teachers;
  final Lookups lookups;
  final List<Filter> filters;
}

Future<TeachersPageData> _transformTeachersModel(
  _TeachersModel _teachersModel,
) async {
  final filteredTeachers =
      await _teachersModel.teachers.applyFilters(_teachersModel.filters);
  final teachersByDistrict = filteredTeachers.groupBy((it) => it.districtCode);
  final teachersByAuthority =
      filteredTeachers.groupBy((it) => it.authorityCode);
  final teachersByGovt = filteredTeachers.groupBy((it) => it.authorityGovt);

  final translates = _teachersModel.lookups;

  final teachersByDistrictRaw = _calculatePeopleCount(teachersByDistrict).map(
    (key, v) => MapEntry(key.from(translates.districts), v),
  );
  final teachersByAuthorityRaw = _calculatePeopleCount(teachersByAuthority).map(
    (key, v) => MapEntry(key.from(translates.authorities), v),
  );
  final teachersByPrivacyRaw = _calculatePeopleCount(teachersByGovt).map(
    (key, v) => MapEntry(key.from(translates.authorityGovt), v),
  );
  return TeachersPageData(
      teachersByDistrict: teachersByDistrictRaw.mapToList((domain, measure) {
        final domains = teachersByDistrictRaw.keys.toList();
        final index = domains.indexOf(domain);
        final color = index < AppColors.kDynamicPalette.length
            ? AppColors.kDynamicPalette[index]
            : HexColor.fromStringHash(domain);
        return ChartData(
          domain,
          measure,
          color,
        );
      }),
      teachersByAuthority: teachersByAuthorityRaw.mapToList((domain, measure) {
        final domains = teachersByAuthorityRaw.keys.toList();
        final index = domains.indexOf(domain);
        final color = index < AppColors.kDynamicPalette.length
            ? AppColors.kDynamicPalette[index]
            : HexColor.fromStringHash(domain);
        return ChartData(
          domain,
          measure,
          color,
        );
      }),
      teachersByPrivacy: teachersByPrivacyRaw.mapToList((domain, measure) {
        return ChartData(
          domain,
          measure,
          domain.toLowerCase().contains('non')
              ? AppColors.kNonGovernmentChartColor
              : AppColors.kGovernmentChartColor,
        );
      }),
      enrollTeachersBySchoolLevelStateAndGender:
          _calculateEnrolBySchoolLevelAndDistrict(
        teachers: filteredTeachers,
        lookups: translates,
      ),
      teachersByCertification: _generateCertificationData(
          filteredTeachers.groupBy((it) => it.ageGroup)));
}

Map<String, int> _calculatePeopleCount(
        Map<String, List<Teacher>> groupedTeachers) =>
    groupedTeachers.map(
      (key, value) => MapEntry(key,
          value.map((it) => it.totalTeachersCount).reduce((lv, rv) => lv + rv)),
    );

EnrollTeachersBySchoolLevelStateAndGender
    _calculateEnrolBySchoolLevelAndDistrict({
  List<Teacher> teachers,
  Lookups lookups,
}) {
  final all = <TeachersBySchoolLevelStateAndGender>[];
  final qualified = <TeachersBySchoolLevelStateAndGender>[];
  final qualifiedAndCertified = <TeachersBySchoolLevelStateAndGender>[];
  final certified = <TeachersBySchoolLevelStateAndGender>[];

  <String, List<Teacher>>{
    'labelTotal': teachers,
  }
    ..addEntries(
      teachers.groupBy((it) => it.districtCode).entries,
    )
    ..forEach((districtCode, schools) {
      final groupedBySchoolType = schools.groupBy((it) => it.schoolTypeCode);
      all.add(
        TeachersBySchoolLevelStateAndGender(
          state: districtCode.from(lookups.districts),
          total: _generateInfoTableData(
            groupedBySchoolType,
            'all',
          ),
        ),
      );
    })
    ..forEach((districtCode, schools) {
      final groupedBySchoolType = schools.groupBy((it) => it.schoolTypeCode);
      qualified.add(
        TeachersBySchoolLevelStateAndGender(
          state: districtCode.from(lookups.districts),
          total: _generateInfoTableData(
            groupedBySchoolType,
            'qualified',
          ),
        ),
      );
    })
    ..forEach((districtCode, schools) {
      final groupedBySchoolType = schools.groupBy((it) => it.schoolTypeCode);
      qualifiedAndCertified.add(
        TeachersBySchoolLevelStateAndGender(
          state: districtCode.from(lookups.districts),
          total: _generateInfoTableData(
            groupedBySchoolType,
            'certified',
          ),
        ),
      );
    })
    ..forEach((districtCode, schools) {
      final groupedBySchoolType = schools.groupBy((it) => it.schoolTypeCode);
      certified.add(
        TeachersBySchoolLevelStateAndGender(
          state: districtCode.from(lookups.districts),
          total: _generateInfoTableData(
            groupedBySchoolType,
            'qualifiedAndCertified',
          ),
        ),
      );
    });
  return EnrollTeachersBySchoolLevelStateAndGender(
    all: all,
    qualified: qualified,
    certified: certified,
    allQualifiedAndCertified: qualifiedAndCertified,
  );
}

Map<String, GenderTableData> _generateInfoTableData(
  Map<String, List<Teacher>> groupedData,
  String category, {
  String districtCode,
}) {
  final allData = <String, GenderTableData>{};
  final certifiedData = <String, GenderTableData>{};
  final qualifiedData = <String, GenderTableData>{};
  final certifiedQualifiedData = <String, GenderTableData>{};

  var totalMaleCount = 0;
  var totalFemaleCount = 0;

  var totalMaleCertifiedCount = 0;
  var totalFemaleCertifiedCount = 0;

  var totalMaleQualifiedCount = 0;
  var totalFemaleQualifiedCount = 0;

  var totalMaleCertifiedQualifiedCount = 0;
  var totalFemaleCertifiedQualifiedCount = 0;

  groupedData.forEach((group, teachers) {
    var maleCount = 0;
    var femaleCount = 0;

    var maleCertifiedCount = 0;
    var femaleCertifiedCount = 0;

    var maleQualifiedCount = 0;
    var femaleQualifiedCount = 0;

    var maleCertifiedQualifiedCount = 0;
    var femaleCertifiedQualifiedCount = 0;

    teachers
        .where((teacher) =>
            districtCode == null || teacher.districtCode == districtCode)
        .forEach((teacher) {
      maleCount += teacher.getTeachersCount(Gender.male);
      femaleCount += teacher.getTeachersCount(Gender.female);

      maleCertifiedCount += teacher.certifiedM;
      femaleCertifiedCount += teacher.certifiedF;

      maleQualifiedCount += teacher.qualifiedM;
      femaleQualifiedCount += teacher.qualifiedM;

      maleCertifiedQualifiedCount += teacher.certQualM;
      femaleCertifiedQualifiedCount += teacher.certQualF;
    });

    allData[group] = GenderTableData(maleCount, femaleCount);
    certifiedData[group] = GenderTableData(
        maleCertifiedCount - maleCertifiedQualifiedCount,
        femaleCertifiedCount - femaleCertifiedQualifiedCount);
    qualifiedData[group] = GenderTableData(
        maleQualifiedCount - maleCertifiedQualifiedCount,
        femaleQualifiedCount - femaleCertifiedQualifiedCount);
    certifiedQualifiedData[group] = GenderTableData(
        maleCertifiedQualifiedCount, femaleCertifiedQualifiedCount);

    totalMaleCount += maleCount;
    totalFemaleCount += femaleCount;

    totalMaleCertifiedCount += maleCertifiedCount;
    totalFemaleCertifiedCount += femaleCertifiedCount;

    totalMaleQualifiedCount += maleQualifiedCount;
    totalFemaleQualifiedCount += femaleQualifiedCount;

    totalMaleCertifiedQualifiedCount += maleCertifiedQualifiedCount;
    totalFemaleCertifiedQualifiedCount += femaleCertifiedQualifiedCount;
  });

  allData['labelTotal'] = GenderTableData(totalMaleCount, totalFemaleCount);
  certifiedData['labelTotal'] =
      GenderTableData(totalMaleCertifiedCount, totalFemaleCertifiedCount);
  qualifiedData['labelTotal'] =
      GenderTableData(totalMaleQualifiedCount, totalFemaleQualifiedCount);
  certifiedQualifiedData['labelTotal'] = GenderTableData(
      totalMaleCertifiedQualifiedCount, totalFemaleCertifiedQualifiedCount);

  switch (category) {
    case 'all':
      return allData;
    case 'certified':
      return certifiedData;
    case 'qualified':
      return qualifiedData;
    case 'qualifiedAndCertified':
      return certifiedQualifiedData;
  }
  throw FallThroughError();
}

Map<String, TeachersByCertification> _generateCertificationData(
  Map<String, List<Teacher>> data,
) {
  final result = <String, TeachersByCertification>{};
  data.forEach((key, value) {
    if (key != null) {
      final certification = TeachersByCertification(
        certifiedAndQualifiedFemale: 0,
        qualifiedFemale: 0,
        certifiedFemale: 0,
        numberTeachersFemale: 0,
        certifiedAndQualifiedMale: 0,
        qualifiedMale: 0,
        certifiedMale: 0,
        numberTeachersMale: 0,
      );

      for (final it in value) {
        certification
          ..certifiedAndQualifiedFemale -= it.certQualF
          ..qualifiedFemale -= (it.qualifiedF - it.certQualF)
          ..certifiedFemale -= (it.certifiedF - it.certQualF)
          ..numberTeachersFemale -= it.numTeachersF
          ..certifiedAndQualifiedMale += it.certQualM
          ..qualifiedMale += (it.qualifiedM - it.certQualM)
          ..certifiedMale += (it.certifiedM - it.certQualM)
          ..numberTeachersMale += it.numTeachersM;
      }

      certification
        ..numberTeachersFemale -= certification.certifiedAndQualifiedFemale +
            certification.qualifiedFemale +
            certification.certifiedFemale
        ..numberTeachersMale -= certification.certifiedAndQualifiedMale +
            certification.qualifiedMale +
            certification.certifiedMale;

      result[key] = certification;
    }
  });

  return result;
}
