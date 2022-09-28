import 'package:arch/arch.dart';
import 'package:example/mvvm_example/exmaple_view_model.dart';
import 'package:flutter/material.dart';

class ExamplePage extends MvvmStatefulWidget {
  ExamplePage({Key key})
      : super(
          key: key,
          viewModelBuilder: (ctx) => ExampleViewModel(ctx),
        );

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends MvvmState<ExampleViewModel, ExamplePage> {
  bool _isFirstBuildPassed = false;
  @override
  Widget buildWidget(BuildContext context) {
    if (!_isFirstBuildPassed) {
      viewModel.onFirstBuild();
      _isFirstBuildPassed = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            SizedBox(
              height: 64,
              child: StreamBuilder<bool>(
                stream: viewModel.activityIndicatorStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data) {
                    return Container();
                  }
                  return Center(child: PlatformProgressIndicator());
                }
              ),
            ),
            StreamBuilder<int>(
              stream: viewModel.counterStream,
              builder: (ctx, snapshot) {
                return Text(
                  '${snapshot.data ?? 0}',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.onAddPressed,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
