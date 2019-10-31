import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pacific_dashboards/res/strings/strings.dart';

class CategoryGridWidget extends StatelessWidget {
  final List<String> _kCategoryData = <String>[
    AppLocalizations.schools,
    AppLocalizations.teachers,
    AppLocalizations.exams,
    AppLocalizations.schoolAccreditations,
    // AppLocalizations.indicators,
    // AppLocalizations.budgets
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: new NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 1.0,
      shrinkWrap: true,
      children: _kCategoryData
          .map(
            (data) => new Container(
              margin: const EdgeInsets.only(left: 5.0),
              child: Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.pushNamed(context, '/$data');
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
                            child: SvgPicture.asset("images/icons/$data.svg",
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Text(
                              data,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                  fontFamily: "NotoSans",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(99, 105, 109, 1.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Color.fromRGBO(8, 36, 73, 0.4),
                    blurRadius: 16.0,
                    offset: new Offset(0.0, 16.0),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
