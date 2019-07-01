import 'package:flutter/material.dart';

class CategoryGridWidget extends StatelessWidget {
  final List<String> _kCategoryData = <String>[
    "Schools",
    "Teachers",
    "Exams",
    "School Accreditations",
    "Indicators",
    "Budgets"
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: new NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 8.0 / 9.0,
      children: _kCategoryData
          .map(
            (data) => Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                     Navigator.pushNamed(context, '/$data');
                    },
                    child: Container(
                      width: 156,
                      height: 156,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            "images/icons/$data.png",
                            width: 64,
                            height: 64,
                          ),
                          new Container(
                            margin: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              data,
                              style: TextStyle(fontFamily: "NotoSans"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          )
          .toList(),
    );
  }
}
