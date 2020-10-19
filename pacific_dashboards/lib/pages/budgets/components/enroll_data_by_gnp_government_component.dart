import 'package:flutter/material.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';

import '../budget_data.dart';

class EnrollDataByGnpAndGovernmentSpendingComponent<T> extends StatelessWidget {
  final List<T> _data;
  final String _type;

  const EnrollDataByGnpAndGovernmentSpendingComponent({
    Key key,
    String type,
    @required List<T> data,
  })  : assert(data != null),
        _data = data,
        _type = type,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _transformToTableData(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          if (_type == 'Govt') {
            return MultiTableWidget(
              type: _type,
              data: snapshot.data,
              columnNames: [
                'year',
                'govtExpense',
                'edExpense',
                'edGovtPercentage'
              ],
              columnFlex: [2, 3, 3, 3],
            );
          } else if (_type == 'GNP') {
            return MultiTableWidget(
              type: _type,
              data: snapshot.data,
              columnNames: ['year', 'gNP', 'edExpense', 'edGNPPercentage'],
              columnFlex: [2, 3, 3, 3],
            );
          } else if (_type == 'ECE' ||
              _type == 'Primary' ||
              _type == 'Secondary' ||
              _type == 'Total') {
            return _generateMultiTableActualBudgeted(snapshot);
          }
        }
        return Container();
      },
    );
  }

  MultiTableWidget _generateMultiTableActualBudgeted(
      AsyncSnapshot<Map<String, dynamic>> snapshot) {
    return MultiTableWidget(
      type: _type,
      data: snapshot.data,
      columnNames: ['State', 'Actual', 'Budgeted'],
      columnFlex: [4, 3, 3],
    );
  }

  Future<Map<String, dynamic>> _transformToTableData() {
    return Future.microtask(() {
      if (_type == 'GNP' || _type == 'Govt') {
        final Map<String, DataByGnpAndGovernmentSpending> result = {};
        for (var it in _data) {
          var dataByGnpAndGovernmentSpending =
              it as DataByGnpAndGovernmentSpending;
          result[dataByGnpAndGovernmentSpending.year.toString()] =
              DataByGnpAndGovernmentSpending(
                  gNP: dataByGnpAndGovernmentSpending.gNP,
                  edExpense: dataByGnpAndGovernmentSpending.edExpense,
                  govtExpense: dataByGnpAndGovernmentSpending.govtExpense,
                  percentageEdGovt:
                      dataByGnpAndGovernmentSpending.percentageEdGovt,
                  percentageEdGnp:
                      dataByGnpAndGovernmentSpending.percentageEdGnp,
                  year: dataByGnpAndGovernmentSpending.year);
        }
        return result;
      } else {
        final Map<String, DataSpendingBySector> result = {};
        for (var it in _data) {
          var dataBySectorSpending = it as DataSpendingBySector;
          result[dataBySectorSpending.districtCode.toString()] =
              DataSpendingBySector(
                  districtCode: dataBySectorSpending.districtCode,
                  eceActual: dataBySectorSpending.eceActual,
                  eceBudget: dataBySectorSpending.eceBudget,
                  primaryActual: dataBySectorSpending.primaryActual,
                  primaryBudget: dataBySectorSpending.primaryBudget,
                  secondaryActual: dataBySectorSpending.secondaryActual,
                  secondaryBudget: dataBySectorSpending.secondaryBudget,
                  totalActual: dataBySectorSpending.totalActual,
                  totalBudget: dataBySectorSpending.totalBudget);
        }
        return result;
      }
    });
  }
}
