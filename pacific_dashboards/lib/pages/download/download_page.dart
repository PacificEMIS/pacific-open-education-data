import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/pages/download/download_view_model.dart';
import 'package:pacific_dashboards/pages/download/state.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class DownloadPageArgs {
  const DownloadPageArgs({
    @required this.emis,
  });

  final Emis emis;
}

class DownloadPage extends MvvmStatefulWidget {
  static const String kRoute = '/DownloadPage';

  DownloadPage({Key key})
      : super(
          key: key,
          viewModelBuilder: (context) =>
              ViewModelFactory.instance.createDownloadViewModel(context),
        );

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends MvvmState<DownloadViewModel, DownloadPage> {
  @override
  Widget buildWidget(BuildContext context) {
    final DownloadPageArgs args = ModalRoute.of(context).settings.arguments;

    return StreamBuilder<DownloadPageState>(
        initialData: PreparationDownloadPageState.initial(),
        stream: viewModel.stateStream,
        builder: (context, snapshot) {
          final state = snapshot.requireData;
          return WillPopScope(
            onWillPop: () async {
              return state is PreparationDownloadPageState;
            },
            child: Scaffold(
              appBar: _buildAppBar(context, state),
              body: Builder(
                builder: (context) {
                  if (state is PreparationDownloadPageState) {
                    return _PreparingBody(
                      viewModel: viewModel,
                      state: state,
                      emis: args.emis,
                    );
                  } else if (state is ActiveDownloadPageState) {
                    return _ActiveBody(
                      viewModel: viewModel,
                      state: state,
                      emis: args.emis,
                    );
                  }
                  throw FallThroughError();
                },
              ),
            ),
          );
        });
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    DownloadPageState state,
  ) {
    return state is PreparationDownloadPageState
        ? PlatformAppBar(
            title: Text('downloadTitle'.localized(context)),
          )
        : PlatformAppBar(
            title: Text('downloadTitle'.localized(context)),
            leading: Container(),
            automaticallyImplyLeading: false,
            actions: [
              if (state is ActiveDownloadPageState && state.isDownloading)
                TextButton(
                  onPressed: () {
                    viewModel.onCancelPressed();
                  },
                  child: Text(
                    'downloadCancel'.localized(context),
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
            ],
          );
  }
}

class _PreparingBody extends StatelessWidget {
  const _PreparingBody({
    Key key,
    @required this.viewModel,
    @required this.state,
    @required this.emis,
  }) : super(key: key);

  final DownloadViewModel viewModel;
  final PreparationDownloadPageState state;
  final Emis emis;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'downloadNote'.localized(context),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${'downloadSubtitle1'.localized(context)} '
                    '${emis.getName(context)}'
                    ' ${'downloadSubtitle2'.localized(context)}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(14, 54, 91, 0.08),
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: GestureDetector(
                      onTap: () {
                        viewModel.onIndividualSchoolEnabledChanged(
                            !state.areIndividualSchoolsEnabled);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: state.areIndividualSchoolsEnabled,
                            onChanged:
                                viewModel.onIndividualSchoolEnabledChanged,
                          ),
                          Expanded(
                            child: Text(
                              'downloadIndSchools'.localized(context),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              16,
              0,
              16,
              24 + MediaQuery.of(context).padding.bottom,
            ),
            child: ElevatedButton(
              onPressed: viewModel.onDownloadPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ).copyWith(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => AppColors.kBlue),
              ),
              child: Text(
                'downloadAction'.localized(context),
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const double _kBorderWidth = 1.0;
const Color _kBorderColor = AppColors.kGeyser;

class _ActiveBody extends StatelessWidget {
  const _ActiveBody({
    Key key,
    @required this.viewModel,
    @required this.state,
    @required this.emis,
  }) : super(key: key);

  final DownloadViewModel viewModel;
  final ActiveDownloadPageState state;
  final Emis emis;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${'downloadSubtitle1'.localized(context)} '
                    '${emis.getName(context)}'
                    ' ${'downloadSubtitle2'.localized(context)}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 16),
                  Theme(
                    data: Theme.of(context).copyWith(
                      accentColor: AppColors.kLightGreen,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: LinearProgressIndicator(
                        value: state.progress,
                        backgroundColor: AppColors.kGrayLight,
                        minHeight: 20,
                      ),
                    ),
                  ),
                  Text(
                    '${state.currentIndex}/${state.total}',
                    style: Theme.of(context).textTheme.overline,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 16),
                  if (state.failedToLoadItems.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(4),
                        ),
                        border: Border.all(
                          width: _kBorderWidth,
                          color: _kBorderColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 8, 6, 8),
                                child: Icon(
                                  Icons.error_outline_outlined,
                                  size: 24,
                                  color: AppColors.kRed,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    'downloadFailedToLoad'.localized(context),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: state.isDownloading
                                    ? null
                                    : viewModel.onRestartPressed,
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.resolveWith(
                                    (states) => const EdgeInsets.fromLTRB(
                                        16, 10, 16, 10),
                                  ),
                                  textStyle: MaterialStateProperty.resolveWith(
                                    (states) {
                                      return Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                            color: states.contains(
                                                    MaterialState.disabled)
                                                ? AppColors.kCoolGray
                                                : AppColors.kLightGreen,
                                          );
                                    },
                                  ),
                                ),
                                child:
                                    Text('downloadReload'.localized(context)),
                              ),
                            ],
                          ),
                          Container(
                            height: _kBorderWidth,
                            color: _kBorderColor,
                          ),
                          for (var i = 0;
                              i < state.failedToLoadItems.length;
                              i++)
                            Container(
                              color: i.isEven
                                  ? Colors.transparent
                                  : AppColors.kGrayLight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                child: Text(
                                  state.failedToLoadItems[i].getName(context),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!state.isDownloading)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                24 + MediaQuery.of(context).padding.bottom,
              ),
              child: ElevatedButton(
                onPressed: viewModel.onDonePressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ).copyWith(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => AppColors.kBlue),
                ),
                child: Text(
                  'downloadDone'.localized(context),
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
