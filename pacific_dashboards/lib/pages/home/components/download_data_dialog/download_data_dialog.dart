import 'package:arch/arch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/home/components/download_data_dialog/download_data_dialog_view_model.dart';
import 'package:pacific_dashboards/pages/home/components/section.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:pacific_dashboards/res/strings.dart';
import 'package:pacific_dashboards/view_model_factory.dart';

void showDownloadDataDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return _DownloadDataDialog();
    },
  );
}

class _DownloadDataDialog extends MvvmStatefulWidget {
  _DownloadDataDialog({Key key})
      : super(
          key: key,
          viewModelBuilder: (context) => ViewModelFactory.instance
              .createDownloadDataDialogViewModel(context),
        );

  @override
  __DownloadDataDialogState createState() => __DownloadDataDialogState();
}

class __DownloadDataDialogState
    extends MvvmState<DownloadDataDialogViewModel, _DownloadDataDialog> {
  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
        ),
        contentPadding: const EdgeInsets.only(top: 10.0, right: 0),
        title: Text(
          'Downloading',
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: AppColors.kTextMain),
        ),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<bool>(
                stream: viewModel.individualSchoolEnabledStream,
                builder: (context, snapshot) {
                  final isChecked = snapshot.data ?? false;
                  return StreamBuilder<bool>(
                      stream: viewModel.progressStream.map((e) => e == 0.0),
                      builder: (context, snapshot) {
                        final isEnabled = snapshot.data ?? false;
                        return CheckboxListTile(
                          value: isChecked,
                          onChanged: isEnabled
                              ? viewModel.onIndividualSchoolEnabledChanged
                              : null,
                          title: Text(
                            'Download individual schools? '
                            'This will take much more time.',
                          ),
                        );
                      });
                },
              ),
              const SizedBox(height: 8),
              StreamBuilder<double>(
                stream: viewModel.progressStream,
                builder: (context, snapshot) {
                  return LinearProgressIndicator(
                    minHeight: 10,
                    value: snapshot.data ?? 0.0,
                  );
                },
              ),
              const SizedBox(height: 8),
              StreamBuilder<LoadingItem>(
                stream: viewModel.currentItemStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Loading: '),
                      Expanded(
                        child: Text(
                          snapshot.data.getName(context),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              StreamBuilder<List<LoadingItem>>(
                stream: viewModel.loadingErrorsStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data.isEmpty) {
                    return Container();
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Errors:'),
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return _ErrorItem(item: snapshot.data[index]);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.onCancelPressed();
                    },
                    child: Text('Cancel'),
                  ),
                  StreamBuilder<double>(
                    stream: viewModel.progressStream,
                    builder: (context, snapshot) {
                      final isRunning = snapshot.hasData && snapshot.data > 0.0;
                      if (isRunning) {
                        return Container();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          viewModel.onDownloadPressed();
                        },
                        child: Text('Start'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorItem extends StatelessWidget {
  const _ErrorItem({Key key, @required this.item}) : super(key: key);

  final LoadingItem item;

  String _getItemDescription(BuildContext context) {
    if (item is IndividualSchoolsLoadingItem) {
      final individualSubItem = item as IndividualSchoolsLoadingItem;
      return '${individualSubItem.section.getName(context)} for school '
          '${individualSubItem.schoolId}';
    } else {
      return item.section.getName(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Failed to load: ${_getItemDescription(context)}',
      style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),
    );
  }
}
