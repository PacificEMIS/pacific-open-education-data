import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/res/strings.dart';

class LoadingStack extends StatelessWidget {
  final Stream<bool> _loadingStateStream;
  final Stream<String> _errorStateStream;
  final Widget _child;

  const LoadingStack({
    Key key,
    @required Stream<bool> loadingStateStream,
    @required Stream<String> errorStateStream,
    @required Widget child,
  })  : assert(loadingStateStream != null),
        assert(child != null),
        _loadingStateStream = loadingStateStream,
        _errorStateStream = errorStateStream,
        _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _child,
        StreamBuilder<String>(
            stream: _errorStateStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return StreamBuilder<bool>(
                  stream: _loadingStateStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox();
                    }
                    final isLoading = snapshot.data;
                    if (isLoading) {
                      return Center(
                        child: PlatformProgressIndicator(),
                      );
                    }
                    return SizedBox();
                  },
                );
              }
              final isLoading = snapshot.data;
              if (isLoading != null &&
                  isLoading.isNotEmpty &&
                  isLoading == 'error_server_unavailable') {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'noPreviouslyFetchedDataAndNoInternet'.localized(context),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                );
              }
              return SizedBox();
            }),
      ],
    );
  }
}
