import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      contentPadding: const EdgeInsets.only(top: 10.0),
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'homeChangeCountryTitle'.localized(context),
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: AppColors.kTextMain),
        ),
        Text('downloadCountryData'.localized(context),
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w400)
            // .copyWith(color: AppColors.kTextMain),
            ),
      ]),
      content: StreamBuilder<Emis>(
        stream: _viewModel.selectedEmisStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Padding(
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
              ],
            ),
          );
        },
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
      splashColor: Theme.of(context).colorScheme.secondary.withAlpha(30),
      onTap: () {
        Navigator.of(context).pop();
        _viewModel.onEmisChanged(_emis);
      },
      child: Container(
        color:
            _isSelected ? Color.fromRGBO(242, 246, 249, 1) : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 20,
              child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 8, bottom: 8, right: 8),
                  child: (_isSelected)
                      ? Stack(alignment: Alignment.bottomLeft, children: [
                          Image.asset(_emis.logo, width: 40, height: 40),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: SvgPicture.asset(
                              'images/rounded_check.svg',
                            ),
                            width: 12,
                            height: 12,
                          ),
                        ])
                      : Image.asset(_emis.logo, width: 40, height: 40)),
            ),
            Expanded(
              flex: 40,
              child: Text(
                _emis.getName(context),
                style:
                    Theme.of(context).textTheme.button.copyWith(fontSize: 18),
              ),
            ),
            Expanded(
              flex: 25,
              child: _isSelected
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 24),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              DownloadPage.kRoute,
                              arguments: DownloadPageArgs(emis: _emis),
                            );
                          },
                          child: Text('Download',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                    )
                  : Container(),
            ),
            Container(width: 10),
          ],
        ),
      ),
    );
  }
}
