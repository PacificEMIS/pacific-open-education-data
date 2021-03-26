import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/pages/download/download_page.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';

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
        content: StreamBuilder<Emis>(
          stream: _viewModel.selectedEmisStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return Container(
              width: 280,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...Emis.values.map(
                    (emis) {
                      return _Country(
                        emis: emis,
                        viewModel: _viewModel,
                        isSelected: emis == snapshot.data,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 80, 24, 20),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          DownloadPage.kRoute,
                          arguments: DownloadPageArgs(emis: snapshot.data),
                        );
                      },
                      child: Text(
                        'downloadCurrentCountry'.localized(context),
                        style: Theme.of(context).textTheme.button.copyWith(
                              color: AppColors.kBlue,
                            ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Country extends StatelessWidget {
  const _Country({
    Key key,
    @required Emis emis,
    @required HomeViewModel viewModel,
    @required bool isSelected,
  })  : assert(emis != null),
        assert(viewModel != null),
        assert(isSelected != null),
        _emis = emis,
        _viewModel = viewModel,
        _isSelected = isSelected,
        super(key: key);

  final HomeViewModel _viewModel;
  final Emis _emis;
  final bool _isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withAlpha(30),
      onTap: () {
        Navigator.of(context).pop();
        _viewModel.onEmisChanged(_emis);
      },
      child: Container(
        color:
            _isSelected ? Color.fromRGBO(242, 246, 249, 1) : Colors.transparent,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 30.0,
                top: 8,
                bottom: 8,
              ),
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
