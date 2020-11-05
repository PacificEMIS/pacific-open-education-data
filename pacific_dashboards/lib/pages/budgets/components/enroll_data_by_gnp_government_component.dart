import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pacific_dashboards/shared_ui/tables/multi_table_widget.dart';

import '../budget_data.dart';

final _sLongNumberFormat = NumberFormat('###,###,###', 'en');

enum SpendingComponentType {
  gnp,
  govt,
  sectorEce,
  sectorPrimary,
  sectorSecondary,
  sectorsTotal,
}

class EnrollDataByGnpAndGovernmentSpendingComponent<T> extends StatelessWidget {
  final List<T> _data;
  final SpendingComponentType _type;

  const EnrollDataByGnpAndGovernmentSpendingComponent({
    Key key,
    @required SpendingComponentType type,
    @required List<T> data,
  })  : assert(data != null),
        assert(type != null),
        _data = data,
        _type = type,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _transformToTableData(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          switch (_type) {
            case SpendingComponentType.gnp:
              return _GnpMultiTable(data: snapshot.data);
            case SpendingComponentType.govt:
              return _GovernmentMultiTable(data: snapshot.data);
            case SpendingComponentType.sectorEce:
              return _SectorMultiTable(
                data: snapshot.data,
                actualExtractor: (data) => data.eceActual,
                budgetedExtractor: (data) => data.eceBudget,
              );
            case SpendingComponentType.sectorPrimary:
              return _SectorMultiTable(
                data: snapshot.data,
                actualExtractor: (data) => data.primaryActual,
                budgetedExtractor: (data) => data.primaryBudget,
              );
            case SpendingComponentType.sectorSecondary:
              return _SectorMultiTable(
                data: snapshot.data,
                actualExtractor: (data) => data.secondaryActual,
                budgetedExtractor: (data) => data.secondaryBudget,
              );
            case SpendingComponentType.sectorsTotal:
              return _SectorMultiTable(
                data: snapshot.data,
                actualExtractor: (data) => data.totalActual,
                budgetedExtractor: (data) => data.totalBudget,
              );
          }
        }
        return Container();
      },
    );
  }

  Future<Map<String, dynamic>> _transformToTableData() {
    return Future.microtask(() {
      switch (_type) {
        case SpendingComponentType.gnp:
        case SpendingComponentType.govt:
          final Map<String, DataByGnpAndGovernmentSpending> result = {};
          for (var it in _data) {
            final dataByGnpAndGovernmentSpending =
                it as DataByGnpAndGovernmentSpending;
            result[dataByGnpAndGovernmentSpending.year.toString()] =
                DataByGnpAndGovernmentSpending(
              gNP: dataByGnpAndGovernmentSpending.gNP,
              edExpense: dataByGnpAndGovernmentSpending.edExpense,
              govtExpense: dataByGnpAndGovernmentSpending.govtExpense,
              percentageEdGovt: dataByGnpAndGovernmentSpending.percentageEdGovt,
              percentageEdGnp: dataByGnpAndGovernmentSpending.percentageEdGnp,
              year: dataByGnpAndGovernmentSpending.year,
            );
          }
          return result;
        case SpendingComponentType.sectorEce:
        case SpendingComponentType.sectorPrimary:
        case SpendingComponentType.sectorSecondary:
        case SpendingComponentType.sectorsTotal:
          final Map<String, DataSpendingBySector> result = {};
          for (var it in _data) {
            final dataBySectorSpending = it as DataSpendingBySector;
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
              totalBudget: dataBySectorSpending.totalBudget,
            );
          }
          return result;
      }
      throw FallThroughError();
    });
  }
}

class _GnpMultiTable extends StatelessWidget {
  final Map<String, DataByGnpAndGovernmentSpending> _data;

  const _GnpMultiTable({
    Key key,
    @required Map<String, DataByGnpAndGovernmentSpending> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiTableWidget(
      data: _data,
      columnNames: [
        'budgetsYearColumn',
        'budgetsGnpColumn',
        'budgetsEdExpenseColumn',
        'budgetsEdGNPPercentageColumn',
      ],
      columnFlex: [2, 3, 3, 3],
      domainValueBuilder: (index, data) {
        switch (index) {
          case 0:
            return data.domain.toString();
          case 1:
            return _sLongNumberFormat.format(data.measure.gNP);
          case 2:
            return _sLongNumberFormat.format(data.measure.edExpense);
          case 3:
            return data.measure.percentageEdGnp.toInt().toString();
        }
        throw FallThroughError();
      },
    );
  }
}

class _GovernmentMultiTable extends StatelessWidget {
  final Map<String, DataByGnpAndGovernmentSpending> _data;

  const _GovernmentMultiTable({
    Key key,
    @required Map<String, DataByGnpAndGovernmentSpending> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiTableWidget(
      data: _data,
      columnNames: [
        'budgetsYearColumn',
        'budgetsGovtExpenseColumn',
        'budgetsEdExpenseColumn',
        'budgetsEdGovtPercentageColumn',
      ],
      columnFlex: [2, 3, 3, 3],
      domainValueBuilder: (index, data) {
        switch (index) {
          case 0:
            return data.domain.toString();
          case 1:
            return _sLongNumberFormat.format(data.measure.govtExpense);
          case 2:
            return _sLongNumberFormat.format(data.measure.edExpense);
          case 3:
            return data.measure.percentageEdGovt.toInt().toString();
        }
        throw FallThroughError();
      },
    );
  }
}

class _SectorMultiTable extends StatelessWidget {
  final Map<String, DataSpendingBySector> _data;
  final double Function(DataSpendingBySector) _actualExtractor;
  final double Function(DataSpendingBySector) _budgetedExtractor;

  const _SectorMultiTable({
    Key key,
    @required Map<String, DataSpendingBySector> data,
    @required double Function(DataSpendingBySector) actualExtractor,
    @required double Function(DataSpendingBySector) budgetedExtractor,
  })  : assert(data != null),
        assert(actualExtractor != null),
        assert(budgetedExtractor != null),
        _data = data,
        _actualExtractor = actualExtractor,
        _budgetedExtractor = budgetedExtractor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiTableWidget(
      data: _data,
      columnNames: [
        'budgetsDistrictColumn',
        'budgetsActualColumn',
        'budgetsBudgetedColumn',
      ],
      columnFlex: [4, 3, 3],
      domainValueBuilder: (index, data) {
        switch (index) {
          case 0:
            return data.domain.toString();
          case 1:
            return _sLongNumberFormat.format(_actualExtractor(data.measure));
          case 2:
            return _sLongNumberFormat.format(_budgetedExtractor(data.measure));
        }
        throw FallThroughError();
      },
    );
  }
}
