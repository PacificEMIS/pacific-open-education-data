import 'package:flutter/material.dart';

class ModuleNote extends StatelessWidget {
  const ModuleNote({Key key, @required String note})
      : assert(note != null),
        _note = note,
        super(key: key);

  final String _note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        _note,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
