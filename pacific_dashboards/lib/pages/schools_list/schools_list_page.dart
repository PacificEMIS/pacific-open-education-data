import 'dart:ui';

import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';
import 'package:pacific_dashboards/pages/schools_list/schools_list_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

class SchoolsListPage extends MvvmStatefulWidget {
  static const String kRoute = '/SchoolList';

  SchoolsListPage({Key key})
      : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createIndividualSchoolsList(ctx),
        );

  @override
  State<StatefulWidget> createState() {
    return SchoolsListPageState();
  }
}

class SchoolsListPageState
    extends MvvmState<SchoolsListViewModel, SchoolsListPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: PlatformAppBar(
        title: Text('schoolsListTitle'.localized(context)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _SearchBar(viewModel: viewModel),
          Container(
            height: 1,
            color: AppColors.kCoolGray,
          ),
          Expanded(
            child: StreamBuilder<bool>(
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
                    stream: viewModel.schoolsStream,
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (ctx, index) {
                            final school = data[index];
                            return _SchoolRow(
                              viewModel: viewModel,
                              school: school,
                              isEven: index.isEven,
                            );
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final SchoolsListViewModel _viewModel;

  const _SearchBar({Key key, SchoolsListViewModel viewModel})
      : assert(viewModel != null),
        _viewModel = viewModel,
        super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
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
                hintText: 'schoolsListSearchHint'.localized(context),
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

class _SchoolRow extends StatelessWidget {
  final bool _isEven;
  final ShortSchool _school;
  final SchoolsListViewModel _viewModel;

  const _SchoolRow({
    Key key,
    @required SchoolsListViewModel viewModel,
    @required ShortSchool school,
    @required bool isEven,
  })  : assert(viewModel != null),
        assert(school != null),
        assert(isEven != null),
        _viewModel = viewModel,
        _school = school,
        _isEven = isEven,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: _isEven ? AppColors.kAthensGray : Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _viewModel.onSchoolPressed(_school),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 86,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
