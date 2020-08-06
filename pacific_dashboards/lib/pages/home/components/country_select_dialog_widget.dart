import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';

import '../home_view_model.dart';

class CountrySelectDialog extends StatelessWidget {
  final HomeViewModel _viewModel;

  const CountrySelectDialog({
    Key key,
    @required HomeViewModel viewModel,
  })  : assert(viewModel != null),
        _viewModel = viewModel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 244,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
        ),
        contentPadding: const EdgeInsets.only(top: 10.0, right: 0),
        title: Text(
          'homeChangeCountryTitle'.localized(context),
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: AppColors.kTextMain),
        ),
        content: Container(
          height: 200,
          width: 280,
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 0.0,
            right: 0.0,
          ),
          child: Column(
            children: [
              ...Emis.values.map((emis) {
                return _Country(
                  emis: emis,
                  viewModel: _viewModel,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _Country extends StatelessWidget {
  final HomeViewModel _viewModel;
  final Emis _emis;

  const _Country({
    Key key,
    @required Emis emis,
    @required HomeViewModel viewModel,
  })  : assert(emis != null),
        assert(viewModel != null),
        _emis = emis,
        _viewModel = viewModel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        splashColor: Theme.of(context).accentColor.withAlpha(30),
        onTap: () {
          Navigator.of(context).pop();
          _viewModel.onEmisChanged(_emis);
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30.0),
              child: Image.asset(_emis.logo, width: 40, height: 40),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  _emis.getName(context),
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
