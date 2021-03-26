import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/individual_school/components/accreditation/components/accreditation_level_component.dart';
import 'package:pacific_dashboards/pages/individual_school/components/accreditation/individual_accreditation_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/themes.dart';

const Color _kBorderColor = AppColors.kGeyser;
const double _kBorderWidth = 1.0;
const double _kCellHeight = 40.0;
const List<int> _kCellFlexes = [45, 25, 20, 20, 20, 20];

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
          ..._data.mapIndexed((index, accreditation) {
            return _StandardRow(
              data: accreditation,
              index: index,
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _StandardRow extends StatelessWidget {
  final AccreditationByStandard _data;
  final int _index;

  const _StandardRow({
    Key key,
    @required AccreditationByStandard data,
    @required int index,
  })  : assert(data != null),
        assert(index != null),
        _data = data,
        _index = index,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _index % 2 == 0 ? Colors.white : AppColors.kGrayLight,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _Cell(
            flex: _kCellFlexes[0],
            child: _StandardText(
              title: _data.standard.localized(context),
              textStyle:
                  Theme.of(context).textTheme.individualAccreditationStandard,
            ),
          ),
          _Cell(
            flex: _kCellFlexes[1],
            child: AccreditationLevelComponent(
              level: _data.result,
              wrapContent: false,
            ),
          ),
          _Cell(
            flex: _kCellFlexes[2],
            child: AccreditationLevelComponent(
              level: _data.criteria1,
              wrapContent: false,
            ),
          ),
          _Cell(
            flex: _kCellFlexes[3],
            child: AccreditationLevelComponent(
              level: _data.criteria2,
              wrapContent: false,
            ),
          ),
          _Cell(
            flex: _kCellFlexes[4],
            child: AccreditationLevelComponent(
              level: _data.criteria3,
              wrapContent: false,
            ),
          ),
          _Cell(
            flex: _kCellFlexes[5],
            child: AccreditationLevelComponent(
              level: _data.criteria4,
              wrapContent: false,
            ),
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
          child: _StandardText(
            title: 'individualSchoolAccreditationsStandard'.localized(context),
            textStyle: Theme.of(context).textTheme.individualAccreditationLevel,
          ),
        ),
        _Cell(
          flex: _kCellFlexes[1],
          child: _CenteredText(
            title: 'individualSchoolAccreditationsResult'.localized(context),
          ),
        ),
        _Cell(
          flex: _kCellFlexes[2],
          child: _CriteriaText(
            title: 'individualSchoolAccreditationsCriteria1Short'
                .localized(context),
            tooltip:
                'individualSchoolAccreditationsCriteria1'.localized(context),
          ),
        ),
        _Cell(
          flex: _kCellFlexes[3],
          child: _CriteriaText(
            title: 'individualSchoolAccreditationsCriteria2Short'
                .localized(context),
            tooltip:
                'individualSchoolAccreditationsCriteria2'.localized(context),
          ),
        ),
        _Cell(
          flex: _kCellFlexes[4],
          child: _CriteriaText(
            title: 'individualSchoolAccreditationsCriteria3Short'
                .localized(context),
            tooltip:
                'individualSchoolAccreditationsCriteria3'.localized(context),
          ),
        ),
        _Cell(
          flex: _kCellFlexes[5],
          child: _CriteriaText(
            title: 'individualSchoolAccreditationsCriteria4Short'
                .localized(context),
            tooltip:
                'individualSchoolAccreditationsCriteria4'.localized(context),
          ),
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
  final TextStyle _textStyle;

  const _StandardText({
    Key key,
    @required String title,
    @required TextStyle textStyle,
  })  : assert(textStyle != null),
        _title = title ?? '-',
        _textStyle = textStyle,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              _title,
              style: _textStyle,
            ),
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

class _CriteriaText extends StatelessWidget {
  final String _title;
  final String _tooltip;

  const _CriteriaText({
    Key key,
    @required String title,
    @required String tooltip,
  })  : _title = title ?? '-',
        _tooltip = tooltip,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _tooltip,
      preferBelow: false,
      textStyle: Theme.of(context).textTheme.individualAccreditationLevel,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 32,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _title,
            style: Theme.of(context).textTheme.individualAccreditationLevel,
          ),
          SizedBox(width: 2),
          Image.asset(
            'images/ic_hint.png',
            width: 14,
            height: 14,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
