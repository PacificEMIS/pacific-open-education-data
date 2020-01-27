import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pacific_dashboards/data/data_source/local/model/lookup/hive_lookup.dart';
import 'package:pacific_dashboards/data/data_source/local/model/lookup/hive_lookups.dart';

Future<void> configureHive() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(HiveLookupsAdapter())
    ..registerAdapter(HiveLookupAdapter());
}