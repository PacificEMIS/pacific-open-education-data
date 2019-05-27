import 'package:flutter/material.dart';
import 'package:pacific_dashboards/ui/pages/counter/CounterBloc.dart';

class CounterPage extends StatefulWidget {
  CounterPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {

  CounterBloc _bloc;

  @override
  void initState() {
    _bloc = CounterBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            StreamBuilder(
              stream: _bloc.counterObservable,
              builder: (context, AsyncSnapshot<int> snapshot) {
                var textStyle = Theme.of(context).textTheme.display1;
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data.toString(),
                    style: textStyle,
                  );
                } else {
                  return Text(
                    'No data from observable',
                    style: textStyle,
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: new FloatingActionButton(
                  onPressed: _bloc.increment,
                  tooltip: 'Increment',
                  child: new Icon(Icons.add),
                )
            ),
            new FloatingActionButton(
              onPressed: _bloc.decrement,
              tooltip: 'Decrement',
              child: new Icon(Icons.remove),
        ),
      ]),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}