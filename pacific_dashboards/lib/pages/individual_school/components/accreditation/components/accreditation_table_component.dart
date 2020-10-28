import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/accreditation/individual_accreditation_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/themes.dart';

const Color _kBorderColor = AppColors.kGeyser;
const double _kBorderWidth = 1.0;
const double _kCellHeight = 40.0;
const List<int> _kCellFlexes = [4, 3, 2, 2, 2, 2];

class AccreditationTableComponent extends StatelessWidget {
  final List<AccreditationByStandard> _data;

  const AccreditationTableComponent({
    Key key,
    @required List<AccreditationByStandard> data,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _HeaderRow(),
          Container(
            height: _kBorderWidth,
            color: _kBorderColor,
          ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _Cell(
          flex: _kCellFlexes[0],
          child: _StandardText(title: 'Standard'),
        ),
        _Cell(
          flex: _kCellFlexes[1],
          child: _CenteredText(title: 'Result'),
        ),
        _Cell(
          flex: _kCellFlexes[2],
          child: _CenteredText(title: 'C1'),
        ),
        _Cell(
          flex: _kCellFlexes[3],
          child: _CenteredText(title: 'C2'),
        ),
        _Cell(
          flex: _kCellFlexes[4],
          child: _CenteredText(title: 'C3'),
        ),
        _Cell(
          flex: _kCellFlexes[5],
          child: _CenteredText(title: 'C4'),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  final Widget _child;
  final int _flex;
  final Color _color;

  const _Cell({
    Key key,
    @required Widget child,
    @required int flex,
    Color color,
  })  : assert(flex != null),
        assert(child != null),
        _child = child,
        _flex = flex,
        _color = color,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _flex,
      child: Container(
        height: _kCellHeight,
        decoration: BoxDecoration(
          color: _color,
        ),
        child: _child,
      ),
    );
  }
}

class _StandardText extends StatelessWidget {
  final String _title;

  const _StandardText({
    Key key,
    @required String title,
  })  : _title = title ?? '-',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            _title,
            style: Theme.of(context).textTheme.individualAccreditationLevel,
          ),
        ],
      ),
    );
  }
}

class _CenteredText extends StatelessWidget {
  final String _title;

  const _CenteredText({
    Key key,
    @required String title,
  })  : _title = title ?? '-',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _title,
          style: Theme.of(context).textTheme.individualAccreditationLevel,
        ),
      ],
    );
  }
}
