import 'package:flutter/material.dart';
import 'package:arch/arch.dart';
import 'package:pacific_dashboards/models/wash/wash.dart';
import 'package:pacific_dashboards/pages/wash/components/totals/totals_view_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/tables/chart_info_table_widget.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pacific_dashboards/res/themes.dart';

class TotalsComponent extends StatelessWidget {
  final WashTotalsViewData _data;
  final VoidCallback _onQuestionSelectorPressed;

  const TotalsComponent({
    Key key,
    @required WashTotalsViewData data,
    @required VoidCallback onQuestionSelectorPressed,
  })  : assert(data != null),
        assert(onQuestionSelectorPressed != null),
        _data = data,
        _onQuestionSelectorPressed = onQuestionSelectorPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 52),
            child: FlatButton(
              onPressed: _onQuestionSelectorPressed,
              color: AppColors.kGrayLight,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: [
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 24,
                    color: AppColors.kBlueDark,
                  ),
                  Expanded(
                    child: Text(
                      _data.selectedQuestion == null
                          ? 'washDistrictTotalsNoQuestionSelectedLabel'
                              .localized(context)
                          : '${_data.selectedQuestion.id}: '
                              '${_data.selectedQuestion.name}',
                      style: Theme.of(context).textTheme.washSelectedQuestion,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
