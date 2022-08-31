import 'package:flutter/material.dart';
import 'package:pacific_dashboards/pages/download/loading_item.dart';
import 'package:pacific_dashboards/res/strings.dart';

class ErrorItem {
  const ErrorItem({
    @required this.item,
    @required this.status,
  });

  final LoadingItem item;
  final String status;
}