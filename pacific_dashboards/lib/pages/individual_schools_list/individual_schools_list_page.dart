import 'dart:ffi';
import 'dart:ui';

import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/individual_schools_list/individual_schools_list_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class IndividualSchoolsListPage extends MvvmStatefulWidget {
  static const String kRoute = '/IndividualSchoolList';
  final List<ShortSchool> selectedSchools;
  final List<ShortSchool> individualSchools;
  final bool isSelectAll;

  IndividualSchoolsListPage({
    Key key,
    @required this.selectedSchools,
    @required this.individualSchools,
    @required this.isSelectAll,
  }) : super(
          key: key,
          viewModelBuilder: (ctx) => ViewModelFactory.instance.createIndividualSchoolsDownloadList(
              ctx, selectedSchools ?? [], individualSchools ?? [], isSelectAll ?? false),
        );

  @override
  State<StatefulWidget> createState() {
    return IndividualSchoolsListPageState();
  }
}

class IndividualSchoolsListPageState extends MvvmState<IndividualSchoolsListViewModel, IndividualSchoolsListPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppBar(
        title: Text('Individual Schools'.localized(context)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, [viewModel.SelectedSchools, viewModel.IndividualSchools]);
          },
        ),
      ),
      body: Container(
        color: AppColors.kLightGray,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SearchBar(viewModel: viewModel),
            Container(
              height: 1,
              color: AppColors.kGrayLight,
            ),
            Expanded(
              child:SingleChildScrollView(child: StreamBuilder<bool>(
                stream: viewModel.activityIndicatorStream,
                initialData: false,
                builder: (ctx, snapshot) {
                  final haveProgress = snapshot.data;
                  if (haveProgress) {
                    return Center(
                      child: PlatformProgressIndicator(),
                    );
                  } else {
                    return StreamBuilder<List<ShortSchool>>(
                      stream: viewModel.IndividualSchoolsStream,
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          return Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    viewModel.SelectedSchools.length > 0 &&
                                            viewModel.SelectedSchools.length < viewModel.IndividualSchools.length
                                        ? InkResponse(
                                            onTap: () => viewModel.onSelectAllSchoolPressed(true),
                                            child: Padding(
                                              padding: EdgeInsets.all(12),
                                              child: SvgPicture.asset(
                                                'images/check_box_24px.svg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          )
                                        : Checkbox(
                                            onChanged: (value) {
                                              viewModel.onSelectAllSchoolPressed(value);
                                            },
                                            fillColor: MaterialStateProperty.all(AppColors.kBlue),
                                            value:
                                                viewModel.SelectedSchools.length == viewModel.IndividualSchools.length),
                                    Expanded(
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text(
                                          'Select all',
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                      ]),
                                    ),
                                  ]),
                            ),
                            Container(
                              height: 1,
                              color: AppColors.kCoolGray,
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (ctx, index) {
                                final school = data[index];
                                return SchoolRow(
                                  viewModel: viewModel,
                                  school: school,
                                  isSelected: viewModel.isSelectedSchoolsContains(school.id),
                                  isEven: index.isEven,
                                );
                              },
                            )
                          ]);
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                },
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
                  onPressed: () {
                    Navigator.pop(context, [viewModel.SelectedSchools, viewModel.IndividualSchools]);
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: AppColors.kBlue,
                    padding: const EdgeInsets.all(16),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ).copyWith(
                    backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.kBlue),
                  ),
                  child: Text(
                    'SUBMIT'.localized(context),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final IndividualSchoolsListViewModel _viewModel;

  const SearchBar({Key key, IndividualSchoolsListViewModel viewModel})
      : assert(viewModel != null),
        _viewModel = viewModel,
        super(key: key);

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  bool _isCloseButtonVisible = false;
  bool _isSearchIconOpaque = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() {
    final text = _controller.text;
    widget._viewModel.onSearchTextChanged(text);
    setState(() {
      _isCloseButtonVisible = text.isNotEmpty;
    });
  }

  void _onFocusChanged() {
    setState(() {
      _isSearchIconOpaque = !_focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            child: Opacity(
              opacity: _isSearchIconOpaque ? 0.5 : 1,
              child: SvgPicture.asset(
                'images/ic_search.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              cursorColor: AppColors.kTextMain,
              style: Theme.of(context).textTheme.subtitle2,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: AppColors.kCoolGray,
                      fontStyle: FontStyle.italic,
                    ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 9,
                ),
              ),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            child: _isCloseButtonVisible
                ? InkResponse(
                    onTap: () => _controller.clear(),
                    child: SvgPicture.asset(
                      'images/ic_search_close.svg',
                      fit: BoxFit.contain,
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

class SchoolRow extends StatelessWidget {
  final bool _isEven;
  final bool _isSelected;
  final ShortSchool _school;
  final IndividualSchoolsListViewModel _viewModel;

  const SchoolRow({
    Key key,
    @required IndividualSchoolsListViewModel viewModel,
    @required ShortSchool school,
    @required bool isEven,
    @required bool isSelected,
  })  : assert(viewModel != null),
        assert(school != null),
        assert(isEven != null),
        _viewModel = viewModel,
        _school = school,
        _isEven = isEven,
        _isSelected = isSelected,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [BoxShadow(blurRadius: 8, color: Color.fromARGB(16, 0, 92, 157), offset: Offset(0, 8))]),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            fillColor: MaterialStateProperty.all(AppColors.kBlue),
            value: _isSelected,
            onChanged: (value) {
              print('School pressed');
              _viewModel.onSchoolPressed(_school);
            },
          ),
          Container(
            width: 66,
            height: 20,
            child: Text(
              _school.id,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: AppColors.kBlue,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              _school.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
    );
  }
}
