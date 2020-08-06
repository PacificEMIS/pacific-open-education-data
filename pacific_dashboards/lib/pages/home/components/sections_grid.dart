import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';

class SectionsGrid extends StatelessWidget {
  SectionsGrid({@required List<Section> sections})
      : assert(sections != null),
        _sections = sections;

  final List<Section> _sections;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      childAspectRatio: 1.0,
      shrinkWrap: true,
      children: _sections.map((section) => _Section(section: section)).toList(),
    );
  }
}

class _Section extends StatelessWidget {
  final Section _section;

  const _Section({Key key, @required Section section})
      : assert(section != null),
        _section = section,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5.0),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color.fromRGBO(8, 36, 73, 0.4),
            blurRadius: 16.0,
            offset: const Offset(0.0, 16.0),
          ),
        ],
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
        ),
        child: InkWell(
          splashColor: Theme.of(context).accentColor.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, _section.routeName);
          },
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    child: SvgPicture.asset(
                      _section.logoPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Text(
                      _section.getName(context),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: Theme.of(context).textTheme.headline5,
                    ),
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
