import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pacific_dashboards/pages/schools_list/bloc/schools_list_bloc.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';
import 'package:pacific_dashboards/shared_ui/platform_app_bar.dart';

class SchoolsListPage extends StatefulWidget {
  const SchoolsListPage({Key key}) : super(key: key);

  static const String kRoute = '/SchoolList';

  @override
  State<StatefulWidget> createState() {
    return SchoolsListPageState();
  }
}

class SchoolsListPageState extends State<SchoolsListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SchoolsListBloc, SchoolsListState>(
      listener: (ctx, state) {},
      child: Scaffold(
        appBar: PlatformAppBar(
          title: Text(AppLocalizations.individualSchools),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _SearchBar(),
            Container(
              height: 1,
              color: AppColors.kCoolGray,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (ctx, index) {
                  return _SchoolRow(
                    id: 'SCH$index',
                    name: 'School of great $index',
                    isEven: index.isEven,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
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
    setState(() {
      _isCloseButtonVisible = _controller.text.isNotEmpty;
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
              onChanged: (text) {
                BlocProvider.of<SchoolsListBloc>(context)
                    .add(SearchTextChangedSchoolsListEvent(text));
              },
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              cursorColor: AppColors.kTextMain,
              style: Theme.of(context).textTheme.subtitle2,
              decoration: InputDecoration(
                hintText: AppLocalizations.searchSchoolsHint,
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
                ? SvgPicture.asset(
                    'images/ic_search_close.svg',
                    fit: BoxFit.contain,
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
  final String _id;
  final String _name;

  const _SchoolRow({
    Key key,
    @required String id,
    @required String name,
    @required bool isEven,
  })  : assert(id != null),
        assert(name != null),
        assert(isEven != null),
        _id = id,
        _name = name,
        _isEven = isEven,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 36.0,
        color: _isEven ? AppColors.kCoolGray : Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(_id),
            Text(_name),
          ],
        ),
      ),
    );
  }
}
