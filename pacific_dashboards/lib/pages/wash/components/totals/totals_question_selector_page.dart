import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/filter/filter.dart';
import 'package:pacific_dashboards/models/wash/question.dart';
import 'package:pacific_dashboards/res/strings.dart';

class TotalsQuestionSelectorPage extends StatefulWidget {
  final List<Question> questions;
  final Question initiallySelectedQuestion;

  const TotalsQuestionSelectorPage({
    Key key,
    @required this.questions,
    @required this.initiallySelectedQuestion,
  })  : assert(questions != null),
        super(key: key);

  @override
  _TotalsQuestionSelectorPageState createState() =>
      _TotalsQuestionSelectorPageState();
}

class _TotalsQuestionSelectorPageState
    extends State<TotalsQuestionSelectorPage> {
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initiallySelectedQuestion == null
        ? -1
        : widget.questions.indexOf(widget.initiallySelectedQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _close(context),
        ),
        title:
            Text('washDistrictTotalsQuestionSelectorTitle'.localized(context)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          final question = widget.questions[index];
          return RadioListTile<int>(
            title: Text(
              '${question.id}: ${question.name}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            value: index,
            groupValue: _selectedIndex,
            onChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Theme.of(context).accentColor,
          );
        },
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: 56,
          width: 56,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: const Icon(
              Icons.done,
              color: Colors.white,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () => _apply(context),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _close(BuildContext context) {
    Navigator.pop(context);
  }

  void _apply(BuildContext context) {
    Navigator.pop(
      context,
      _selectedIndex >= 0 ? widget.questions[_selectedIndex] : null,
    );
  }
}
