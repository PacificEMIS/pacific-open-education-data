import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/dashboards/components/enroll/enroll_data.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';

class EnrollDataByGradeComponent extends StatelessWidget {
  const EnrollDataByGradeComponent({
    Key key,
    @required List<EnrollDataByGrade> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  final List<EnrollDataByGrade> _data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, GenderTableData>>(
      future: _transformToTableData(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return MultiTableWidget(
            data: snapshot.data,
            columnNames: const [
              'individualSchoolDashboardEnrollByGradeLevelGenderGrade',
              'labelMale',
              'labelFemale',
              'labelTotal'
            ],
            columnFlex: const [3, 3, 3, 3],
            domainValueBuilder: GenderTableData.sDomainValueBuilder,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<Map<String, GenderTableData>> _transformToTableData() {
    return Future.microtask(() {
      final result = <String, GenderTableData>{};
      for (final it in _data) {
        result[it.grade] = GenderTableData(it.male, it.female);
      }
      return result;
    });
  }
}
