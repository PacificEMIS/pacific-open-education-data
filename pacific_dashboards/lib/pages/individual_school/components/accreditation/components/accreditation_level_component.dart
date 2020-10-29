import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/themes.dart';

class AccreditationLevelComponent extends StatelessWidget {
  final int _level;
  final bool _wrapContent;

  const AccreditationLevelComponent({
    Key key,
    @required int level,
    bool wrapContent = true,
  })  : _level = level,
        _wrapContent = wrapContent,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.individualAccreditationLevel;
    return Row(
      mainAxisSize: _wrapContent ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${_level ?? '-'}', style: textStyle),
        if (_level != null && _level > 0 && _level < 5)
          Icon(
            Icons.star,
            size: 14,
            color: AppColors.kLevels[_level - 1],
          ),
      ],
    );
  }
}
