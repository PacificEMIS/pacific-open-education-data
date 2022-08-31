import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/download/error_item.dart';
import 'package:pacific_dashboards/pages/download/loading_item.dart';

import '../home/components/section.dart';

abstract class DownloadPageState {}

class PreparationDownloadPageState extends DownloadPageState {
  PreparationDownloadPageState({
    @required this.sections,
  });

  factory PreparationDownloadPageState.initial() {
    return PreparationDownloadPageState(sections: []);
  }

  final List<Section> sections;

  PreparationDownloadPageState copyWith({Section section}) {
    sections.contains(section) ?
    sections.remove(section) :
    sections.add(section);
    return PreparationDownloadPageState(
      sections: sections,
    );
  }

  PreparationDownloadPageState copyWithSections({List<Section> sections}) {
    return PreparationDownloadPageState(
      sections: sections,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreparationDownloadPageState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => sections.hashCode;
}

class ActiveDownloadPageState extends DownloadPageState {
  ActiveDownloadPageState({
    @required this.isDownloading,
    @required this.currentIndex,
    @required this.total,
    @required this.failedToLoadItems,
  });

  factory ActiveDownloadPageState.initial({@required int total}) {
    return ActiveDownloadPageState(
      isDownloading: true,
      currentIndex: 0,
      total: total,
      failedToLoadItems: [],
    );
  }

  final bool isDownloading;
  final int currentIndex;
  final int total;
  final List<ErrorItem> failedToLoadItems;

  double get progress => currentIndex / total;

  ActiveDownloadPageState copyWith({
    bool isDownloading,
    int currentIndex,
    int total,
    List<ErrorItem> failedToLoadItems,
  }) {
    return ActiveDownloadPageState(
      isDownloading: isDownloading ?? this.isDownloading,
      currentIndex: currentIndex ?? this.currentIndex,
      total: total ?? this.total,
      failedToLoadItems: failedToLoadItems ?? this.failedToLoadItems,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveDownloadPageState &&
          runtimeType == other.runtimeType &&
          isDownloading == other.isDownloading &&
          progress == other.progress &&
          total == other.total &&
          failedToLoadItems == other.failedToLoadItems;

  @override
  int get hashCode =>
      isDownloading.hashCode ^
      progress.hashCode ^
      total.hashCode ^
      failedToLoadItems.hashCode;
}
