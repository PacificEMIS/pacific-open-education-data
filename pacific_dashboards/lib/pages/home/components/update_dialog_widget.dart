import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';

import '../home_view_model.dart';

class UpdateDialog extends StatelessWidget {
  final HomeViewModel _viewModel;

  const UpdateDialog({
    Key key,
    @required HomeViewModel viewModel,
  })
      : assert(viewModel != null),
        _viewModel = viewModel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
          ),
          contentPadding: const EdgeInsets.only(top: 10.0, right: 0),
          title: Text(
            'updateApp'.localized(context),
            style: Theme
                .of(context)
                .textTheme
                .headline3
                .copyWith(
                color: AppColors.kTextMain, fontWeight: FontWeight.normal),
          ),
          content: Container(
            width: 280,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Text(
                    'appIsOutdatedPopup'.localized(context),
                    style: Theme
                        .of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.black54),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                    [
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 4, 0, 4),
                        height: 50,
                        width: 135,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'updateCancel'.localized(context),
                            style: Theme
                                .of(context)
                                .textTheme
                                .button
                                .copyWith(
                              color: AppColors.kBlue,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 4, 24, 4),
                        height: 50,
                        width: 135,
                        child: ElevatedButton(
                          onPressed: () => _viewModel.openStorePage(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    8))),
                          ),
                          child: Text(
                            'update'.localized(context),
                            style: Theme
                                .of(context)
                                .textTheme
                                .button
                                .copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ]
                )
              ],
            ),
          )
      ),
    );
  }
}

