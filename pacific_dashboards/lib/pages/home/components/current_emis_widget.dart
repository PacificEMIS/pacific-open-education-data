import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/pages/home/home_view_model.dart';
import 'package:pacific_dashboards/res/strings.dart';

class CurrentEmisWidget extends StatelessWidget {
  final HomeViewModel _viewModel;

  const CurrentEmisWidget({
    Key key,
    @required HomeViewModel viewModel,
  })  : assert(viewModel != null),
        _viewModel = viewModel,
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
              height: 160,
              width: 160,
              child: snapshot.hasData
                  ? Image.asset(snapshot.data.logo)
                  : Container(),
            ),
            Container(
              height: 96,
              width: 266,
              alignment: Alignment.center,
              child: Center(
                child: snapshot.hasData
                    ? Text(
                        snapshot.data == Emis.fedemis
                            ? 'fedemisTitleMultiline'.localized(context)
                            : snapshot.data.getName(context),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3,
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
