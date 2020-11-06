import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/strings.dart';

class LoadingItem {
  const LoadingItem({
    @required this.subject,
    @required Future<dynamic> Function() loadFn,
  }) : _loadFn = loadFn;

  final LoadingSubject subject;
  final Future<dynamic> Function() _loadFn;

  Future<dynamic> Function() get loadFn => _loadFn;

  String getName(BuildContext context) {
    switch (subject) {
      case LoadingSubject.lookups:
        return 'downloadSubjectLookups'.localized(context);
      case LoadingSubject.individualSchools:
        return 'downloadSubjectIndividualSchoolsList'.localized(context);
      case LoadingSubject.schools:
        return 'downloadSubjectSchools'.localized(context);
      case LoadingSubject.teachers:
        return 'downloadSubjectTeachers'.localized(context);
      case LoadingSubject.exams:
        return 'downloadSubjectExams'.localized(context);
      case LoadingSubject.schoolAccreditations:
        return 'downloadSubjectSA'.localized(context);
      case LoadingSubject.budgets:
        return 'downloadSubjectBudgets'.localized(context);
      case LoadingSubject.wash:
        return 'downloadSubjectWASH'.localized(context);
      case LoadingSubject.specialEducation:
        return 'downloadSubjectSpecialEducation'.localized(context);
      case LoadingSubject.indicators:
        return 'downloadSubjectIndicators'.localized(context);
    }
    throw FallThroughError();
  }
}

class IndividualSchoolsLoadingItem extends LoadingItem {
  const IndividualSchoolsLoadingItem({
    @required this.schoolId,
    @required this.districtCode,
    @required
        Future<void> Function(String schoolId, String districtCode) loadFn,
  })  : _loadFunction = loadFn,
        super(subject: LoadingSubject.individualSchools, loadFn: null);

  final String schoolId;
  final String districtCode;
  final Future<void> Function(String schoolId, String districtCode)
      _loadFunction;

  @override
  Future<dynamic> Function() get loadFn =>
      () => _loadFunction(schoolId, districtCode);

  @override
  String getName(BuildContext context) {
    return '${'downloadSubjectIndividualSchoolsDetailed'.localized(context)}'
        ' $schoolId';
  }
}

// Note: order is important
enum LoadingSubject {
  lookups,
  individualSchools,
  schools,
  teachers,
  exams,
  schoolAccreditations,
  budgets,
  wash,
  specialEducation,
  indicators,
}
