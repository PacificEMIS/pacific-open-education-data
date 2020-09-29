import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/exams/individual_exams_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';

class HistoryComponent extends StatelessWidget {
  final Stream<bool> _loadingStream;
  final Stream<List<ExamReportsHistoryByYearData>> _dataStream;

  const HistoryComponent({
    Key key,
    @required Stream<bool> loadingStream,
    @required Stream<List<ExamReportsHistoryByYearData>> dataStream,
  })  : assert(loadingStream != null),
        assert(dataStream != null),
        _loadingStream = loadingStream,
        _dataStream = dataStream,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: StreamBuilder<bool>(
        stream: _loadingStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          final isLoading = snapshot.data;
          if (isLoading) {
            return Container(
              height: 100,
              child: Center(
                child: PlatformProgressIndicator(),
              ),
            );
          }
          return StreamBuilder<List<ExamReportsHistoryByYearData>>(
            stream: _dataStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return _HistoryTable(data: snapshot.data);
            },
          );
        },
      ),
    );
  }
}

const Color _kBorderColor = AppColors.kGeyser;
const Color _kFillColor = AppColors.kGrayLight;
const double _kBorderWidth = 1.0;

class _HistoryTable extends StatelessWidget {
  final List<ExamReportsHistoryByYearData> _data;

  const _HistoryTable({
    Key key,
    @required List<ExamReportsHistoryByYearData> data,
  })  : assert(data != null),
        _data = data,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
        border: Border.all(
          width: _kBorderWidth,
          color: _kBorderColor,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _HeaderRow(),
          Container(
            height: _kBorderWidth,
            color: _kBorderColor,
          ),
          for (var byYearData in _data)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _YearCell(year: byYearData.year),
                ...byYearData.rows.mapIndexed((index, item) {
                  return _DataRow(
                    data: item,
                    haveBackground: index % 2 == 1,
                  );
                }),
              ],
            )
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final ExamReportsHistoryRowData _data;
  final bool _haveBackground;

  const _DataRow({
    Key key,
    @required ExamReportsHistoryRowData data,
    @required bool haveBackground,
  })  : assert(data != null),
        assert(haveBackground != null),
        _data = data,
        _haveBackground = haveBackground,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Row(
      measure: _MeasureCell(value: '${_data.examCode}: ${_data.examName}'),
      male: _CandidatesCell(
        count: _data.male,
        percent: _data.malePercent,
      ),
      female: _CandidatesCell(
        count: _data.female,
        percent: _data.femalePercent,
      ),
      total: _CandidatesCell(
        count: _data.total,
      ),
      haveBackground: _haveBackground,
    );
  }
}

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Row(
      measure: _HeaderCell(
        value: 'individualSchoolExamsHistoryTableCode'.localized(context),
      ),
      male: _HeaderCell(
        value: 'labelMale'.localized(context),
      ),
      female: _HeaderCell(
        value: 'labelFemale'.localized(context),
      ),
      total: _HeaderCell(
        value: 'labelTotal'.localized(context),
      ),
      haveBackground: false,
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String _value;

  const _HeaderCell({Key key, @required String value})
      : assert(value != null),
        _value = value,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _value,
      overflow: TextOverflow.fade,
      style: Theme.of(context)
          .textTheme
          .individualDashboardsExamHistoryTableHeader,
    );
  }
}

class _MeasureCell extends StatelessWidget {
  final String _value;

  const _MeasureCell({Key key, @required String value})
      : assert(value != null),
        _value = value,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _value,
      overflow: TextOverflow.fade,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}

class _YearCell extends StatelessWidget {
  final int _year;

  const _YearCell({Key key, @required int year})
      : assert(year != null),
        _year = year,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: _kFillColor,
      child: Center(
        child: Text(
          '$_year${'individualSchoolExamsHistoryYear'.localized(context)}',
          style: Theme.of(context)
              .textTheme
              .individualDashboardsExamHistoryTableYearHeader,
        ),
      ),
    );
  }
}

class _CandidatesCell extends StatelessWidget {
  final int _count;
  final int _percent;

  const _CandidatesCell({
    Key key,
    @required int count,
    int percent,
  })  : assert(count != null),
        _count = count,
        _percent = percent,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.fade,
      text: TextSpan(
        text: '$_count',
        style: Theme.of(context).textTheme.subtitle2,
        children: [
          if (_percent != null)
            TextSpan(
              text: ' ($_percent%)',
              style: Theme.of(context)
                  .textTheme
                  .individualDashboardsExamHistoryTablePercentage,
            )
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final Widget _measure;
  final Widget _male;
  final Widget _female;
  final Widget _total;
  final bool _haveBackground;

  const _Row({
    Key key,
    @required Widget measure,
    @required Widget male,
    @required Widget female,
    @required Widget total,
    @required bool haveBackground,
  })  : assert(measure != null),
        assert(male != null),
        assert(female != null),
        assert(total != null),
        assert(haveBackground != null),
        _measure = measure,
        _male = male,
        _female = female,
        _total = total,
        _haveBackground = haveBackground,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: _haveBackground ? _kFillColor : Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(width: 16),
          Expanded(child: _measure),
          const SizedBox(width: 8),
          Container(
            width: 60,
            child: _male,
          ),
          const SizedBox(width: 8),
          Container(
            width: 60,
            child: _female,
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            child: _total,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
