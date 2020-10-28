import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/data/repository/repository.dart';
import 'package:pacific_dashboards/models/individual_accreditation/individual_accreditation.dart';
import 'package:pacific_dashboards/models/individual_school/individual_school.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:pacific_dashboards/pages/individual_school/components/accreditation/individual_accreditation_data.dart';
import 'package:rxdart/rxdart.dart';

const _kPossibleLevelInts = [1, 2, 3, 4];

class IndividualAccreditationViewModel extends BaseViewModel {
  final Repository _repository;
  final ShortSchool _school;

  final Subject<List<IndividualAccreditationData>> _dataSubject =
      BehaviorSubject();

  IndividualAccreditationViewModel(
    BuildContext ctx, {
    @required ShortSchool school,
    @required Repository repository,
  })  : assert(repository != null),
        assert(school != null),
        _school = school,
        _repository = repository,
        super(ctx);

  Stream<List<IndividualAccreditationData>> get dataStream =>
      _dataSubject.stream;

  @override
  void onInit() {
    super.onInit();
    _dataSubject.disposeWith(disposeBag);
    _loadAccreditationData();
  }

  void _loadAccreditationData() {
    listenHandled(
      handleRepositoryFetch(
        fetch: () => _repository.fetchIndividualSchool(_school.id),
      ),
      _onSchoolDataLoaded,
      notifyProgress: true,
    );
  }

  int _getAccreditationResult(IndividualAccreditation accreditation) {
    for (var it in _kPossibleLevelInts) {
      if (accreditation.result.contains('$it')) {
        return it;
      }
    }
    return null;
  }

  Future<void> _onSchoolDataLoaded(IndividualSchool school) =>
      launchHandled(() {
        _dataSubject.add(
          school.accreditationList
              .map((accreditation) {
                return IndividualAccreditationData(
                  dateTime: accreditation.dateTime,
                  inspectedBy: accreditation.inspectedBy,
                  result: _getAccreditationResult(accreditation),
                  standards: [
                    AccreditationByStandard(
                      standard: 'individualSchoolAccreditationsSE1',
                      result: accreditation.se_1?.round(),
                      criteria1: accreditation.se_1_1?.round(),
                      criteria2: accreditation.se_1_2?.round(),
                      criteria3: accreditation.se_1_3?.round(),
                      criteria4: accreditation.se_1_4?.round(),
                    ),
                    AccreditationByStandard(
                      standard: 'individualSchoolAccreditationsSE2',
                      result: accreditation.se_2?.round(),
                      criteria1: accreditation.se_2_1?.round(),
                      criteria2: accreditation.se_2_2?.round(),
                      criteria3: accreditation.se_2_3?.round(),
                      criteria4: accreditation.se_2_4?.round(),
                    ),
                    AccreditationByStandard(
                      standard: 'individualSchoolAccreditationsSE3',
                      result: accreditation.se_3?.round(),
                      criteria1: accreditation.se_3_1?.round(),
                      criteria2: accreditation.se_3_2?.round(),
                      criteria3: accreditation.se_3_3?.round(),
                      criteria4: accreditation.se_3_4?.round(),
                    ),
                    AccreditationByStandard(
                      standard: 'individualSchoolAccreditationsSE4',
                      result: accreditation.se_4?.round(),
                      criteria1: accreditation.se_4_1?.round(),
                      criteria2: accreditation.se_4_2?.round(),
                      criteria3: accreditation.se_4_3?.round(),
                      criteria4: accreditation.se_4_4?.round(),
                    ),
                    AccreditationByStandard(
                      standard: 'individualSchoolAccreditationsSE5',
                      result: accreditation.se_5?.round(),
                      criteria1: accreditation.se_5_1?.round(),
                      criteria2: accreditation.se_5_2?.round(),
                      criteria3: accreditation.se_5_3?.round(),
                      criteria4: accreditation.se_5_4?.round(),
                    ),
                    AccreditationByStandard(
                      standard: 'individualSchoolAccreditationsSE6',
                      result: accreditation.se_6?.round(),
                      criteria1: accreditation.se_6_1?.round(),
                      criteria2: accreditation.se_6_2?.round(),
                      criteria3: accreditation.se_6_3?.round(),
                      criteria4: accreditation.se_6_4?.round(),
                    ),
                  ],
                  classroomObservation1: accreditation.co_1?.round(),
                  classroomObservation2: accreditation.co_2?.round(),
                );
              })
              .toList()
              .chainSort((lv, rv) {
                if (lv.dateTime == null) return 1;
                if (rv.dateTime == null) return -1;
                return rv.dateTime.compareTo(lv.dateTime);
              }),
        );
      });
}
