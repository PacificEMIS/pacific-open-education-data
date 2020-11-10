import 'package:arch/arch.dart';
import 'package:flutter/material.dart';

class LoadingStack extends StatelessWidget {
  final Stream<bool> _loadingStateStream;
  final Widget _child;

  const LoadingStack({
    Key key,
    @required Stream<bool> loadingStateStream,
    @required Widget child,
  })  : assert(loadingStateStream != null),
        assert(child != null),
        _loadingStateStream = loadingStateStream,
        _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _child,
        StreamBuilder<bool>(
          stream: _loadingStateStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final isLoading = snapshot.data;
            if (isLoading) {
              return Center(
                child: PlatformProgressIndicator(),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
