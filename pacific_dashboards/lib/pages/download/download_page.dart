import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/pages/download/download_view_model.dart';
import 'package:pacific_dashboards/pages/download/state.dart';
import 'package:pacific_dashboards/pages/individual_school/individual_school_page.dart';
import 'package:pacific_dashboards/pages/schools_list/schools_list_page.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

import '../../models/short_school/short_school.dart';
import '../home/components/section.dart';
import '../individual_schools_list/individual_schools_list_page.dart';

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
          viewModelBuilder: (context) => ViewModelFactory.instance.createDownloadViewModel(context),
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

            leading: null,
            automaticallyImplyLeading: false,
            actions: [
              if (state is ActiveDownloadPageState && state.isDownloading)
                CancelDialog(viewModel: viewModel),
            ],
          );
  }
}

class CancelDialog extends StatelessWidget {
  const CancelDialog({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final DownloadViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return  Container(
                height: 240,
                child: AlertDialog(
                    shape: const RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.only(top: 10.0, right: 0),
                    title: Text(
                      'Cancel'.localized(context),
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
                              'Are you sure you want to cancel the download'.localized(context),
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
                                      viewModel.onCancelPressed();
                                    },
                                    child: Text(
                                      'Yes'.localized(context),
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
                                    onPressed: () {Navigator.of(context).pop();},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(
                                              8))),
                                    ),
                                    child: Text(
                                      'No'.localized(context),
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
            });
      },
      child: Text(
        'downloadCancel'.localized(context),
        style: Theme.of(context).textTheme.button.copyWith(
              color: Colors.white,
            ),
      ),
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
                  Column(children: [
                    FutureBuilder<List<Section>>(
                        future: viewModel.getSections(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Column(children: [
                              DownloadItem(
                                  context: context,
                                  viewModel: viewModel,
                                  state: state,
                                  sections: snapshot.data,
                                  emis: emis),
                              Container(height: 2, color: Colors.black12),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int index) {
                                    return DownloadItem(
                                        emis: emis,
                                        section: snapshot.data[index],
                                        viewModel: viewModel,
                                        state: state,
                                        sections: snapshot.data, context: context);
                                  })
                            ]);
                          }
                        })
                  ])
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: AppColors.kLightGray,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              16,
              0,
              16,
              24 + MediaQuery.of(context).padding.bottom,
            ),
            child: ElevatedButton(
              onPressed: viewModel.selectedSchools != null && viewModel.selectedSchools.length > 0 ||
                      viewModel.isSectionsSelected()
                  ? viewModel.onDownloadPressed
                  : null,
              style: ElevatedButton.styleFrom(
                shadowColor: AppColors.kBlue,
                padding: const EdgeInsets.all(16),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ).copyWith(
                backgroundColor: MaterialStateColor.resolveWith((states) => viewModel.selectedSchools != null && viewModel.selectedSchools.length > 0 ||
                    viewModel.isSectionsSelected() ? AppColors.kBlue : AppColors.kCoolGray),
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

class DownloadItem extends StatelessWidget {
  const DownloadItem({
    Key key,
    @required this.context,
    @required this.viewModel,
    @required this.state,
    @required this.sections,
    @required this.emis,
    this.section,
  }) : super(key: key);

  final BuildContext context;
  final DownloadViewModel viewModel;
  final PreparationDownloadPageState state;
  final Section section;
  final List<Section> sections;
  final Emis emis;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            viewModel.selectedSchools != null &&
                        state.sections.length > 0 &&
                        state.sections.length < sections.length &&
                        section == null ||
                    viewModel.selectedSchools != null &&
                        section == Section.individualSchools &&
                        viewModel.selectedSchools.length > 0 &&
                        viewModel.selectedSchools.length != viewModel.individualSchools.length && !state.sections
                        .contains(Section.individualSchools) ||
                        state.sections.length > 0 && state.sections.length < sections.length && section == null ||
                         state.sections.length < sections.length && viewModel.selectedSchools != null && viewModel
                .selectedSchools.length > 0 && section == null
                ? InkResponse(
                    onTap:
                      section == Section.individualSchools ? () => viewModel.onSelectedRegionValueChanged(section)
                        : () => viewModel.onSelectAllSectionsPressed(sections),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'images/check_box_24px.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : Checkbox(
                    activeColor: AppColors.kBlue,
                    value: section == null
                        ? state.sections.length == sections.length
                        : section == Section.individualSchools &&
                                viewModel.individualSchools != null &&
                                viewModel.individualSchools.length == viewModel.selectedSchools.length &&
                                viewModel.individualSchools.length != 0 ||
                            state.sections.contains(section),
                    onChanged: (value) {
                      section == null
                          ? viewModel.onSelectAllSectionsPressed(value ? sections : [])
                          : viewModel.onSelectedRegionValueChanged(section);
                    },
                  ),
            Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  section == null ? 'selectAll'.localized(context) : section.name.localized(context),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                section == null || section != Section.individualSchools
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: Container(
                          width: 100,
                          height: 25,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                onPrimary: Colors.black87,
                                primary: Colors.black87,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            onPressed: () {
                              _openIndividualSchools(context, viewModel);
                            },
                            child: Text('Choose any',
                                style: Theme.of(context).textTheme.button.copyWith(color: Colors.white, fontSize: 12)),
                          ),
                        ),
                      ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

void _openIndividualSchools(BuildContext context, DownloadViewModel viewModel) {
  Navigator.push<List<List<ShortSchool>>>(
    context,
    MaterialPageRoute(builder: (context) {
      return IndividualSchoolsListPage(
          selectedSchools: viewModel.selectedSchools,
          individualSchools: viewModel.individualSchools,
          isSelectAll: viewModel.isAllSchoolSelected());
    }),
  ).then((schoolsId) {
    viewModel.onUpdateSchoolsList(schoolsId[0], schoolsId[1]);
  });
}

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
                      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.kLightGreen),
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
                  if (state.failedToLoadItems.isNotEmpty) _LoadingErrors(state: state, viewModel: viewModel),
                ],
              ),
            ),
          ),
        ),
        if (!state.isDownloading)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: AppColors.kLightGray,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                16,
                5,
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
                  backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.kBlue),
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

class _LoadingErrors extends StatelessWidget {
  const _LoadingErrors({
    Key key,
    @required this.state,
    @required this.viewModel,
  }) : super(key: key);

  static const double _kBorderWidth = 1.0;
  static const Color _kBorderColor = AppColors.kGeyser;

  final ActiveDownloadPageState state;
  final DownloadViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          const Radius.circular(4),
        ),
        border: Border.all(
          width: _kBorderWidth,
          color: _kBorderColor,
        ),
      ),
      clipBehavior: Clip.antiAlias,
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
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'downloadFailedToLoad'.localized(context),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              TextButton(
                onPressed: state.isDownloading ? null : viewModel.onRestartPressed,
                style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                    (states) => const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  ),
                  textStyle: MaterialStateProperty.resolveWith(
                    (states) => Theme.of(context).textTheme.button,
                  ),
                ),
                child: Text('downloadReload'.localized(context)),
              ),
            ],
          ),
          Container(
            height: _kBorderWidth,
            color: _kBorderColor,
          ),
          for (var i = 0; i < state.failedToLoadItems.length; i++)
            Container(

              color: i.isEven ? Colors.transparent : AppColors.kGrayLight,
              child: Padding(

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(
                  state.failedToLoadItems[i].item.getName(context),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                  Text(
                    state.failedToLoadItems[i].status,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.grey),
                  ),]),
              ),
            ),
        ],
      ),
    );
  }
}
