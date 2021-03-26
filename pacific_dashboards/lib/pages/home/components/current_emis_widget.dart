import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/pages/home/home_view_model.dart';
import 'package:pacific_dashboards/res/strings.dart';

class CurrentEmisWidget extends StatelessWidget {
  final HomeViewModel _viewModel;
  final bool _useMobileLayout;

  const CurrentEmisWidget(
      {Key key,
      @required HomeViewModel viewModel,
      @required bool useMobileLayout})
      : assert(viewModel != null, useMobileLayout != null),
        _viewModel = viewModel,
        _useMobileLayout = useMobileLayout,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Emis>(
      stream: _viewModel.selectedEmisStream,
      builder: (ctx, snapshot) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: _useMobileLayout ? 180 : 270,
              width: _useMobileLayout ? 180 : 270,
              child: snapshot.hasData
                  ? Image.asset(
                      snapshot.data.logo,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            Container(
              height: _useMobileLayout ? 96 : 120,
              width: _useMobileLayout ? 266 : 399,
              alignment: Alignment.center,
              child: Center(
                child: snapshot.hasData
                    ? Text(
                        snapshot.data == Emis.fedemis
                            ? 'fedemisTitleMultiline'.localized(context)
                            : snapshot.data.getName(context),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3,
                        textScaleFactor: _useMobileLayout ? 1 : 1.3,
                      )
                    : Container(),
              ),
            ),
          ],
        );
      },
    );
  }
}
