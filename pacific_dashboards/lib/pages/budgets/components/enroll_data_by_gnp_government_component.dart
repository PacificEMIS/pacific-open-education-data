import 'package:flutter/material.dart';
import 'package:pacific_dashboards/shared_ui/multi_table_widget.dart';

import '../budget_data.dart';

class EnrollDataByGnpAndGovernmentSpendingComponent extends StatelessWidget {
  final List<DataByGnpAndGovernmentSpending> _data;
  final String _type;

  const EnrollDataByGnpAndGovernmentSpendingComponent(
      {Key key,
      String type,
      @required List<DataByGnpAndGovernmentSpending> data})
      : assert(data != null),
        _data = data,
        _type = type,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, DataByGnpAndGovernmentSpending>>(
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
          } else if (_type == 'actualExpenditure') {
            return MultiTableWidget(
                type: _type,
                data: snapshot.data,
                columnNames: ['year', 'gNP', 'edExpense', 'edGNPPercentage'],
                columnFlex: [2, 3, 3, 3]);
          } else if (_type == 'budget') {
            return MultiTableWidget(
                type: _type,
                data: snapshot.data,
                columnNames: ['year', 'gNP', 'edExpense', 'edGNPPercentage'],
                columnFlex: [2, 3, 3, 3]);
          } else if (_type == 'actualRecurrentExpenditure') {
            return MultiTableWidget(
                type: _type,
                data: snapshot.data,
                columnNames: ['year', 'gNP', 'edExpense', 'edGNPPercentage'],
                columnFlex: [2, 3, 3, 3]);
          } else if (_type == 'budgetRecurrent') {
            return MultiTableWidget(
                type: _type,
                data: snapshot.data,
                columnNames: ['year', 'gNP', 'edExpense', 'edGNPPercentage'],
                columnFlex: [2, 3, 3, 3]);
          } else if (_type == 'actualExpPerHead') {
            return MultiTableWidget(
                type: _type,
                data: snapshot.data,
                columnNames: ['year', 'gNP', 'edExpense', 'edGNPPercentage'],
                columnFlex: [2, 3, 3, 3]);
          } else if (_type == 'budgetExpPerHead') {
            return MultiTableWidget(
                type: _type,
                data: snapshot.data,
                columnNames: ['year', 'gNP', 'edExpense', 'edGNPPercentage'],
                columnFlex: [2, 3, 3, 3]);
          } else if (_type == 'enrollment') {
            return MultiTableWidget(
                type: _type,
                data: snapshot.data,
                columnNames: ['year', 'gNP', 'edExpense', 'edGNPPercentage'],
                columnFlex: [2, 3, 3, 3]);
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Future<Map<String, DataByGnpAndGovernmentSpending>> _transformToTableData() {
    return Future.microtask(() {
      final Map<String, DataByGnpAndGovernmentSpending> result = {};
      for (var it in _data) {
        result[it.year.toString()] = DataByGnpAndGovernmentSpending(
            gNP: it.gNP,
            edExpense: it.edExpense,
            govtExpense: it.govtExpense,
            percentageEdGovt: it.percentageEdGovt,
            percentageEdGnp: it.percentageEdGnp,
            year: it.year);
      }
      return result;
    });
  }
}
