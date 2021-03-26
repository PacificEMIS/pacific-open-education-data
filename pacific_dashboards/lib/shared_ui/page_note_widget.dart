import 'package:flutter/material.dart';

class PageNoteWidget extends StatelessWidget {
  final Stream<String> _noteStream;

  const PageNoteWidget({Key key, @required Stream<String> noteStream})
      : assert(noteStream != null),
        _noteStream = noteStream,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _noteStream,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              snapshot.data,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
