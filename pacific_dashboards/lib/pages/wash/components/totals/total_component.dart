import 'package:flutter/material.dart';
import 'package:arch/arch.dart';
import 'package:pacific_dashboards/pages/wash/components/totals/totals_view_data.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/charts/chart_data.dart';
import 'package:pacific_dashboards/shared_ui/charts/horizontal_stacked_scrollable_bar_chart.dart';
import 'package:pacific_dashboards/shared_ui/mini_tab_layout.dart';
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
        if (_data.data != null)
          FutureBuilder<Map<String, Color>>(
            future: _chartPalette,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return MiniTabLayout(
                tabs: _Tab.values,
                tabNameBuilder: (tab) {
                  return _getTabName(context, tab);
                },
                builder: (context, tab) {
                  return _Chart(
                    data: _data.data,
                    colorPalette: snapshot.data,
                    measureExtractor: (it) {
                      switch (tab) {
                        case _Tab.accumulated:
                          return it.accumulated;
                        case _Tab.evaluated:
                          return it.evaluated;
                      }
                      throw FallThroughError();
                    },
                  );
                },
              );
            },
          ),
      ],
    );
  }

  String _getTabName(BuildContext context, _Tab tab) {
    switch (tab) {
      case _Tab.evaluated:
        return '${'washDistrictTotalsEvaluatedTab'.localized(context)}${_data.year}';
      case _Tab.accumulated:
        return '${'washDistrictTotalsAccumulatedTab'.localized(context)}${_data.year}';
    }
    throw FallThroughError();
  }

  Future<Map<String, Color>> get _chartPalette => Future.microtask(
        () {
          final colorMap = Map<String, Color>();
          _data.data
              .expand((it) => it.answerDataList)
              .map((e) => e.answer)
              .uniques((it) => it)
              .forEachIndexed((index, item) {
            colorMap[item] = index < AppColors.kDynamicPalette.length
                ? AppColors.kDynamicPalette[index]
                : HexColor.fromStringHash(item);
          });
          return colorMap;
        },
      );
}

enum _Tab {
  evaluated,
  accumulated,
}

class _Chart extends HorizontalStackedScrollableBarChart {
  final List<WashTotalsViewDataByDistrict> _data;
  final num Function(WashTotalsViewDataByAnswer) _measureExtractor;
  final Map<String, Color> _colorPalette;

  const _Chart({
    Key key,
    @required List<WashTotalsViewDataByDistrict> data,
    @required num Function(WashTotalsViewDataByAnswer) measureExtractor,
    @required Map<String, Color> colorPalette,
  })  : assert(data != null),
        assert(measureExtractor != null),
        assert(colorPalette != null),
        _data = data,
        _measureExtractor = measureExtractor,
        _colorPalette = colorPalette,
        super(key: key);

  bool get showScrollbar => true;

  @override
  List<ChartData> get chartData => _data
      .expand(
        (byDistrict) => byDistrict.answerDataList.map(
          (byAnswer) => ChartData(
            byDistrict.district,
            _measureExtractor(byAnswer),
            _colorPalette[byAnswer.answer],
          ),
        ),
      )
      .toList();

  @override
  int get domainLength => _data.length;

  @override
  List<Pair<String, Color>> get legend => _colorPalette.mapToList(
        (key, value) => Pair(key, value),
      );

  @override
  double get bottomPadding => 72;
}
